clc,clear
close all

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';

seed_dir = fullfile(main_dir,'scripts/seed/masks');

seed_name = 'pcc_1_-61_38_5mm';
seed_header = spm_vol([seed_dir, '/', seed_name, '.nii']);
seed_mask = spm_read_vols(seed_header);
seed_mask = logical(reshape(seed_mask, 1, 91*109*91));

%gray mask coregistered to 91x109x91
graymask = spm_vol([main_dir, '/scripts/bold_activation/masks/rwc1ct1.nii']);
graymask = spm_read_vols(graymask);
graymask = logical(reshape(graymask, 1, 91*109*91));

%chequear notas.txt
thresh = [18,30,13,14,8,15,18, 10, 12, 18];


pre_period = 5;
post_period = 5;

session_list = dir(fullfile(main_dir, 'data/sub01'));
session_list(1:2) = [];


for iSess=1:length(session_list)
    sessionName = session_list(iSess).name;
    
    display(sessionName);
    
    cd(fullfile(main_dir, 'data/sub01', sessionName, 'functional','cond2/smooth'));

    header = spm_vol('swautransicion.nii');
    data = spm_read_vols(header);

    data = reshape(data,91*109*91,150);

    C_seed(iSess, :) = mean(data(seed_mask,:));
    C_gray(iSess, :) = mean(data(graymask,:));
    C_all(iSess, :) = mean(data);
    
end


for i = 1:length(thresh)
    range_min = thresh(i) - pre_period;
    range_max = thresh(i) + post_period;
    D_seed(i,:) = C_seed(i, range_min:range_max);
    D_gray(i,:) = C_gray(i, range_min:range_max);
    D_all(i,:) = C_all(i, range_min:range_max);
end

%%
figure    
plot(-pre_period:post_period,zscore(mean(D_seed)), 'linewidth', 2, 'color',[1, 0.2, 0])
hold on
plot([0 0 ],[-11 11],'linestyle','--','color','k')
ylim([-1.5 3])
xlabel('tiempo')
ylabel('BOLD')
title('precuneus')
    

figure    
plot(-pre_period:post_period,zscore(mean(D_gray)), 'linewidth', 2, 'color',[1, 0.2, 0])
hold on
plot([0 0 ],[-11 11],'linestyle','--','color','k')
ylim([-2 4])
xlabel('tiempo')
ylabel('BOLD')
title('toda la materia gris')

figure    
plot(-pre_period:post_period,zscore(mean(D_all)), 'linewidth', 2, 'color',[1, 0.2, 0])
hold on
plot([0 0 ],[-11 11],'linestyle','--','color','k')
ylim([-2 3])
xlabel('tiempo')
ylabel('BOLD')
title('toda la cabeza')
    
    
