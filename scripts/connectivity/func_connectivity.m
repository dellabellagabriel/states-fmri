clear,clc

addpath /home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/func_networks

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
session_list = dir([main_dir, '/data/sub01']);
session_list(1:2) = [];

roi = 'consensus_264';
n_rois = 264;

C = zeros(length(session_list), 4, n_rois, n_rois);
C_net = zeros(length(session_list), 4, 14, 14);
for iSess=1:length(session_list)-1
    sessionName = session_list(iSess).name;
    
   for iCond=1:4
    load([main_dir,'/results/func_networks/', roi, '/', sessionName,'/cond', num2str(iCond),'/func_roi.mat'])
    C(iSess, iCond, :,:) = corrcoef(func_roi');
    
    load([main_dir,'/results/func_networks/', roi, '/', sessionName,'/cond', num2str(iCond),'/func_network.mat'])
    C_net(iSess, iCond, :, :) = corrcoef(roi_data');
   end
end

C_cond = squeeze(mean(C));
C_transicion = squeeze(C_cond(2,:,:)-C_cond(1,:,:));
C_alteracion = squeeze(C_cond(3,:,:)-C_cond(1,:,:));
C_recuperacion = squeeze(C_cond(4,:,:)-C_cond(1,:,:));

save([main_dir, '/results/connectivity/', 'c_transicion.mat'], 'C_transicion')
save([main_dir, '/results/connectivity/', 'c_alteracion.mat'], 'C_alteracion')
save([main_dir, '/results/connectivity/', 'c_recuperacion.mat'], 'C_recuperacion')

C_net_cond = squeeze(mean(C_net));
C_net_transicion = squeeze(C_net_cond(2,:,:)-C_net_cond(1,:,:));
C_net_alteracion = squeeze(C_net_cond(3,:,:)-C_net_cond(1,:,:));
C_net_recuperacion = squeeze(C_net_cond(4,:,:)-C_net_cond(1,:,:));

save([main_dir, '/results/connectivity/', 'c_net_transicion.mat'], 'C_net_transicion')
save([main_dir, '/results/connectivity/', 'c_net_alteracion.mat'], 'C_net_alteracion')
save([main_dir, '/results/connectivity/', 'c_net_recuperacion.mat'], 'C_net_recuperacion')