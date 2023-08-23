clc,clear

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
sub_list = dir([main_dir, '/results/func_networks/consensus_264/*']);
sub_list([1,2]) = [];

windows_reposo = [];
windows_transicion = [];
windows_alteracion = [];
windows_recuperacion = [];
for iSub=1:length(sub_list)
   subname = sub_list(iSub).name;
   display(subname);
   
   load([main_dir, '/results/func_networks/consensus_264/', subname, '/cond1/func_roi.mat'], 'func_roi')
   if iSub == 8
        func_roi(:,1) = func_roi(:,2);
   end
   windows_reposo(iSub, :, :) = bold_to_windows(func_roi);
   
   load([main_dir, '/results/func_networks/consensus_264/', subname, '/cond2/func_roi.mat'], 'func_roi')
   if iSub == 8
        func_roi(:,1) = func_roi(:,2);
   end
   windows_transicion(iSub, :, :) = bold_to_windows(func_roi);
   
   load([main_dir, '/results/func_networks/consensus_264/', subname, '/cond3/func_roi.mat'], 'func_roi')
   if iSub == 8
        func_roi(:,1) = func_roi(:,2);
   end
   windows_alteracion(iSub, :, :) = bold_to_windows(func_roi);
   
   load([main_dir, '/results/func_networks/consensus_264/', subname, '/cond4/func_roi.mat'], 'func_roi')
   if iSub == 8
        func_roi(:,1) = func_roi(:,2);
   end
   windows_recuperacion(iSub, :, :) = bold_to_windows(func_roi);
   
end

windows_for_brainstates(1,:,:,:) = windows_reposo;
windows_for_brainstates(2,:,:,:) = windows_transicion;
windows_for_brainstates(3,:,:,:) = windows_alteracion;
windows_for_brainstates(4,:,:,:) = windows_recuperacion;
save([main_dir, '/results/brainstates/windows/windows_consensus_264.mat'], '-v7.3', 'windows_for_brainstates')

windows = single(cat(1, windows_reposo, windows_transicion, windows_alteracion, windows_recuperacion));
%windows = reshape(windows, 4*18*129, 4005);
windows = reshape(windows, 4*18*129, 34716);
