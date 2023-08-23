main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
sub_list = dir([main_dir, '/results/func_networks/AAL/*']);
sub_list([1,2]) = [];

tc_aal = {};

for iSub=1:length(sub_list)
   subname = sub_list(iSub).name;
   
   load([main_dir, '/results/func_networks/AAL/', subname, '/cond1/func_roi.mat'], 'func_roi')
   tc_aal{iSub, 1} = func_roi;
   
   load([main_dir, '/results/func_networks/AAL/', subname, '/cond2/func_roi.mat'], 'func_roi')
   tc_aal{iSub, 2} = func_roi;
   
   load([main_dir, '/results/func_networks/AAL/', subname, '/cond3/func_roi.mat'], 'func_roi')
   tc_aal{iSub, 3} = func_roi;
   
   load([main_dir, '/results/func_networks/AAL/', subname, '/cond4/func_roi.mat'], 'func_roi')
   tc_aal{iSub, 4} = func_roi;
   
end

save([main_dir, '/scripts/leida/LEiDA/bold.mat'], 'tc_aal')