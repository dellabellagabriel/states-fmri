% this computes the eigenvectors of the structural matrix and saves them 

clc,clear

addpath(genpath('/home/usuario/disco1/toolboxes/GraSP'))

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';

load([main_dir, '/scripts/gsp/anat/sc_bin.mat'], 'sc_bin');
header_aal = spm_vol([main_dir, '/scripts/func_networks/masks/AAL.nii']);
aal = spm_read_vols(header_aal);

deg = diag(sum(sc_bin));
lapla = deg - sc_bin;
deg_sqrt = inv(sqrt(deg));
lapla_sim = deg_sqrt * lapla * deg_sqrt; 
options.matrix = lapla_sim;

g = grasp_struct;
g.A = sc_bin;
g = grasp_eigendecomposition(g, options);

%%
for iAV = 1:90
    display(iAV)
    
    AV = zeros(size(aal));
    %AVnorm = zscore(g.Finv(:,iAV));
    for iReg = 1:90
        AV(aal == iReg) = g.Finv(iReg,iAV);
    end
    
    header = header_aal;
    header.dt = [16 0];
    header.fname = [main_dir, '/results/gsp/eigenvectors_nii/', num2str(iAV),'_AV.nii'];
    spm_write_vol(header,AV);
    
end

