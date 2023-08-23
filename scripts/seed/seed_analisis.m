clc,clear

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
seed_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/seed/masks';
results_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/results/seed';
session_list = dir('/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/data/sub01');
session_list(1:2) = [];

seed_name = 'visual_5-2_-79_12';
seed_header = spm_vol([seed_dir, '/', seed_name, '.nii']);
seed_mask = spm_read_vols(seed_header);
seed_mask = logical(reshape(seed_mask, 1, 91*109*91));

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
    %% BORRAR 
    if iSess == 8, cond_data(:,:,:,1) = cond_data(:,:,:,2);end
    
    cond_data = reshape(cond_data, 91*109*91, 600);
    %%
    for iCond=1:length(cond_list)
       condition = cond_data(:, 150*(iCond-1)+1:150*iCond);
       seed_timeseries = mean(condition(seed_mask, :));
       C(iSess, iCond, :) = corr(seed_timeseries', condition');
    end
end

%export correlation data
for iSess=1:length(session_list)
   for iCond=1:length(cond_list)
        mkdir([results_dir, '/', seed_name, '/', 'condicion', num2str(iCond)]);
        cond_export_header = cond_header(1);
        cond_export_header.fname = [results_dir, '/', seed_name, '/', 'condicion', num2str(iCond),'/', session_list(iSess).name, '_condicion_', num2str(iCond), '.nii'];
        correlation = reshape(C(iSess, iCond, :), 91,109,91);
        spm_write_vol(cond_export_header, correlation);
   end
   
   %difference 2 - 1
   cond_export_header = cond_header(1);
   cond_export_header.fname = [results_dir, '/', seed_name, '/', session_list(iSess).name, '_diferencia_2-1', '.nii'];
   diff_21 = reshape(C(iSess, 2, :)-C(iSess, 1, :), 91,109,91);
   spm_write_vol(cond_export_header, diff_21);
   
   %difference 3 - 1
   cond_export_header = cond_header(1);
   cond_export_header.fname = [results_dir, '/', seed_name, '/', session_list(iSess).name, '_diferencia_3-1', '.nii'];
   diff_31 = reshape(C(iSess, 3, :)-C(iSess, 1, :), 91,109,91);
   spm_write_vol(cond_export_header, diff_31);
   
   %difference 4 - 1
   cond_export_header = cond_header(1);
   cond_export_header.fname = [results_dir, '/', seed_name, '/', session_list(iSess).name, '_diferencia_4-1', '.nii'];
   diff_41 = reshape(C(iSess, 4, :)-C(iSess, 1, :), 91,109,91);
   spm_write_vol(cond_export_header, diff_41);
   
end

%export averaging sessions
C_all_sessions = squeeze(mean(C));

cond_1_header = cond_header(1);
cond_1_header.fname = [results_dir, '/', seed_name, '/', 'all_sessions_diferencia_2-1', '.nii'];
diff_21 = reshape(C_all_sessions(2, :)-C_all_sessions(1, :), 91,109,91);
spm_write_vol(cond_1_header, diff_21);

cond_1_header = cond_header(1);
cond_1_header.fname = [results_dir, '/', seed_name, '/', 'all_sessions_diferencia_3-1', '.nii'];
diff_31 = reshape(C_all_sessions(3, :)-C_all_sessions(1, :), 91,109,91);
spm_write_vol(cond_1_header, diff_31);

cond_1_header = cond_header(1);
cond_1_header.fname = [results_dir, '/', seed_name, '/', 'all_sessions_diferencia_4-1', '.nii'];
diff_41 = reshape(C_all_sessions(4, :)-C_all_sessions(1, :), 91,109,91);
spm_write_vol(cond_1_header, diff_41);
