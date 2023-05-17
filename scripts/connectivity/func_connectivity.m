clear,clc

addpath /home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/func_networks

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
session_list = dir([main_dir, '/data/sub01']);
session_list(1:2) = [];

roi = 'consensus_264';
n_rois = 264;
func_networks_list = importdata([main_dir, '/scripts/func_networks/masks/rois264_identity.txt']);

C = zeros(length(session_list), 4, n_rois, n_rois); %correlation per node
C_net = zeros(length(session_list), 4, 14, 14); %correlation per func network
C_intra = zeros(length(session_list), 4, 14);
C_inter = zeros(length(session_list), 4, 14);
for iSess=1:length(session_list)-1
    sessionName = session_list(iSess).name;
    
   for iCond=1:4
    %correlation per node
    load([main_dir,'/results/func_networks/', roi, '/', sessionName,'/cond', num2str(iCond),'/func_roi.mat'])
    C(iSess, iCond, :,:) = corrcoef(func_roi');
    
    %correlation per func network
    load([main_dir,'/results/func_networks/', roi, '/', sessionName,'/cond', num2str(iCond),'/func_network.mat'])
    C_net(iSess, iCond, :, :) = corrcoef(roi_data');
    
    for iNet=1:14
        func_networks_idx = func_networks_list == iNet;
        %intra connectivity
        nodes_func_network = func_roi(func_networks_idx, :);
        C_intra(iSess, iCond, iNet) = mean(mean(corrcoef(nodes_func_network')));

        %inter connectivity
        nodes_not_func_network = func_roi(~func_networks_idx, :);
        C_inter(iSess, iCond, iNet) = mean(mean(corr(nodes_func_network', nodes_not_func_network')));
    end
    
   end
end

save([main_dir, '/results/connectivity/connectivity.mat'], 'C_net')
save([main_dir, '/results/connectivity/intra_connectivity.mat'], 'C_intra')
save([main_dir, '/results/connectivity/inter_connectivity.mat'], 'C_inter')

% C_cond = squeeze(mean(C));
% C_transicion = squeeze(C_cond(2,:,:)-C_cond(1,:,:));
% C_alteracion = squeeze(C_cond(3,:,:)-C_cond(1,:,:));
% C_recuperacion = squeeze(C_cond(4,:,:)-C_cond(1,:,:));
% 
% save([main_dir, '/results/connectivity/', 'c_transicion.mat'], 'C_transicion')
% save([main_dir, '/results/connectivity/', 'c_alteracion.mat'], 'C_alteracion')
% save([main_dir, '/results/connectivity/', 'c_recuperacion.mat'], 'C_recuperacion')
% 
% C_net_cond = squeeze(mean(C_net));
% C_net_transicion = squeeze(C_net_cond(2,:,:)-C_net_cond(1,:,:));
% C_net_alteracion = squeeze(C_net_cond(3,:,:)-C_net_cond(1,:,:));
% C_net_recuperacion = squeeze(C_net_cond(4,:,:)-C_net_cond(1,:,:));

%save([main_dir, '/results/connectivity/', 'c_net_transicion.mat'], 'C_net_transicion')
%save([main_dir, '/results/connectivity/', 'c_net_alteracion.mat'], 'C_net_alteracion')
%save([main_dir, '/results/connectivity/', 'c_net_recuperacion.mat'], 'C_net_recuperacion')