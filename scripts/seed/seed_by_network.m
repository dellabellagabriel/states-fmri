clc,clear

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
seed_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/func_networks/masks';
results_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/results/seed/salience_rois';
session_list = dir('/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/data/sub01');
session_list(1:2) = [];

roi_ids = importdata([main_dir, '/scripts/func_networks/masks/rois264_identity.txt']);
roi_salience = find(roi_ids == 11);

seed_header = spm_vol([seed_dir, '/', 'consensus_264.nii']);
seed_mask = spm_read_vols(seed_header);

%iterar sobre cada roi perteneciente a la red de saliencia (11)
for iRoi=1:length(roi_salience)
    seed_mask_data = seed_mask == roi_salience(iRoi);
    seed_mask_data = logical(reshape(seed_mask_data, 1, 91*109*91));

    
    C = [];
    for iSess=1:length(session_list)
        sessionName = session_list(iSess).name;

        display(sessionName);

        cd([main_dir, '/data/sub01/', sessionName, '/functional']);
        cond_list = dir('.');
        cond_list(1:2) = [];

        %conditions are concatenated so we need to split them
        cond_header = spm_vol([main_dir, '/data/sub01/', sessionName, '/func-resting/', sessionName, '-resting.nii']);
        cond_data = spm_read_vols(cond_header);
        cond_data = reshape(cond_data, 91*109*91, 600);
        for iCond=1:length(cond_list)
           condition = cond_data(:, 150*(iCond-1)+1:150*iCond);
           seed_timeseries = mean(condition(seed_mask_data, :));
           C(iSess, iCond, iRoi, :) = corr(seed_timeseries', condition');
        end
    end
end

% average over regions
CC = squeeze(mean(C, 3));
header = cond_header(1);
for i=1:length(session_list)
   CC_trans = CC(i, 2, :) - CC(i, 1, :);
   CC_alter = CC(i, 3, :) - CC(i, 1, :);
   CC_recu = CC(i, 4, :) - CC(i, 1, :);
   
   CC_trans_brain = reshape(squeeze(CC_trans), 91, 109, 91);
   CC_alter_brain = reshape(squeeze(CC_alter), 91, 109, 91);
   CC_recu_brain = reshape(squeeze(CC_recu), 91, 109, 91);
   
   
   header.fname = [results_dir, '/transicion-', num2str(i), '.nii'];
   spm_write_vol(header, CC_trans_brain);
   
   header.fname = [results_dir, '/alteracion-', num2str(i), '.nii'];
   spm_write_vol(header, CC_alter_brain);
   
   header.fname = [results_dir, '/recuperacion-', num2str(i), '.nii'];
   spm_write_vol(header, CC_recu_brain);
end