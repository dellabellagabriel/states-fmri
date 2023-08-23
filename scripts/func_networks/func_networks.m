clear,clc

addpath /home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/func_networks

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
session_list = dir([main_dir, '/data/sub01']);
session_list(1:2) = [];

mask_name = 'consensus_264';
mask_dir = [main_dir, '/scripts/func_networks/masks'];
mask_header = spm_vol([mask_dir, '/', mask_name, '.nii']);
mask_data = spm_read_vols(mask_header);
roi_id = importdata([mask_dir, '/rois264_identity.txt']);

output_dir = [main_dir, '/results/func_networks/', mask_name];

for iSess=1:length(session_list)
    sessionName = session_list(iSess).name;
    mkdir([output_dir,'/',sessionName])
    
    display(sessionName);
    
    cd([main_dir, '/data/sub01/', sessionName, '/functional']);
    cond_list = dir('.');
    cond_list(1:2) = [];
    
    %conditions are concatenated so we need to split them
    cond_header = spm_vol([main_dir, '/data/sub01/', sessionName, '/func-resting/', sessionName, '-resting.nii']);
    cond_data = spm_read_vols(cond_header);
    for iCond=1:4
        display(['condicion ', num2str(iCond)])
        mkdir([output_dir,'/',sessionName,'/cond',num2str(iCond)]);
        
        func_roi = bold_to_networks(cond_data(:,:,:,150*(iCond-1)+1:150*iCond), mask_data);
        save([output_dir,'/',sessionName,'/cond',num2str(iCond),'/func_roi.mat'], 'func_roi');
        
        %we average over functional networks
        roi_data = zeros(15, 150);
        for iNetwork=1:15
           data_mask = func_roi(roi_id==iNetwork, :);
           roi_data(iNetwork,:) = mean(data_mask);
        end
        save([output_dir,'/',sessionName,'/cond',num2str(iCond),'/func_network.mat'], 'roi_data')
        
    end
end