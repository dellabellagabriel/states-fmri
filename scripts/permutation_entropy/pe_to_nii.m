load('/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/permutation_entropy/entropy_complexity.mat')
mask_header = spm_vol('/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/func_networks/masks/BrainMask_05_91x109x91.img');
mask = logical(spm_read_vols(mask_header));

for iSub=1:size(he, 1)
    for iCond=1:size(he, 2)
       he_data = zeros(size(mask));
       he_data(mask) = he(iSub, iCond, :);
       
       sc_data = zeros(size(mask));
       sc_data(mask) = sc(iSub, iCond, :);
       
       header = mask_header;
       header.dt = [16 0];
       header.fname = ['/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/results/permutation_entropy/he-sub', num2str(iSub), '-cond', num2str(iCond), '.nii'];
       spm_write_vol(header, he_data);
       
       header = mask_header;
       header.dt = [16 0];
       header.fname = ['/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/results/permutation_entropy/sc-sub', num2str(iSub), '-cond', num2str(iCond), '.nii'];
       spm_write_vol(header, sc_data);
    end
end