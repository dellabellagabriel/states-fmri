clear,clc

addpath /home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/func_networks

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/';
session_list = dir([main_dir, '/data/sub01']);
session_list(1:2) = [];

roi = 'consensus_264';
n_rois = 264;

C = zeros(length(session_list), 4, n_rois, n_rois);
for iSess=1:length(session_list)
    sessionName = session_list(iSess).name;
    
   for iCond=1:4
    load([main_dir,'/results/func_networks/', roi, '/', sessionName,'/cond', num2str(iCond),'/func_roi.mat'])
    C(iSess, iCond, :,:) = corrcoef(func_roi');
   end
end

C_cond = squeeze(mean(C));
C_transicion = squeeze(C_cond(2,:,:)-C_cond(1,:,:));
C_alteracion = squeeze(C_cond(3,:,:)-C_cond(1,:,:));
C_recuperacion = squeeze(C_cond(4,:,:)-C_cond(1,:,:));