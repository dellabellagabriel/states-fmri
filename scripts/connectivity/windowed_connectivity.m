clear,clc

addpath /home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/func_networks

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
session_list = dir([main_dir, '/data/sub01']);
session_list(1:2) = [];

roi = 'consensus_264';
n_rois = 264;

C = zeros(length(session_list), 4, n_rois, n_rois);
for iSess=1:length(session_list)-1
    sessionName = session_list(iSess).name;
    
   for iCond=1:4
    load([main_dir,'/results/func_networks/', roi, '/', sessionName,'/cond', num2str(iCond),'/func_roi.mat'])
    
   end
end