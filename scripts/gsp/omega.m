clc,clear

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
load([main_dir, '/results/gsp/g.mat'], 'g')
eigenvectors = g.Finv;
n_roi = 90;
n_time = 150;

%% awake
sub_dir = dir([main_dir, '/results/func_networks/AAL/*']);
sub_dir([1,2]) = [];

w_reposo = zeros(length(sub_dir), n_roi, n_time);
w_transicion = zeros(length(sub_dir), n_roi, n_time);
w_alteracion = zeros(length(sub_dir), n_roi, n_time);
w_recuperacion = zeros(length(sub_dir), n_roi, n_time);

for iSub=1:length(sub_dir)
   
   %reposo
   load([main_dir, '/results/func_networks/AAL/', sub_dir(iSub).name, '/cond1/func_roi.mat'])
   
   for t=1:n_time
       w_reposo(iSub, :, t) = compute_projections(func_roi(:, t), eigenvectors);
   end
   
   %transicion
   load([main_dir, '/results/func_networks/AAL/', sub_dir(iSub).name, '/cond2/func_roi.mat'])
   
   for t=1:n_time
       w_transicion(iSub, :, t) = compute_projections(func_roi(:, t), eigenvectors);
   end
   
   %alteracion
   load([main_dir, '/results/func_networks/AAL/', sub_dir(iSub).name, '/cond3/func_roi.mat'])
   
   for t=1:n_time
       w_alteracion(iSub, :, t) = compute_projections(func_roi(:, t), eigenvectors);
   end
   
   %recuperacion
   load([main_dir, '/results/func_networks/AAL/', sub_dir(iSub).name, '/cond4/func_roi.mat'])
   
   for t=1:n_time
       w_recuperacion(iSub, :, t) = compute_projections(func_roi(:, t), eigenvectors);
   end
   
end

power_reposo = abs(w_reposo);
power_transicion = abs(w_transicion);
power_alteracion = abs(w_alteracion);
power_recuperacion = abs(w_recuperacion);

entropy_reposo = zeros(length(sub_dir), n_time);
entropy_transicion = zeros(length(sub_dir), n_time);
entropy_alteracion = zeros(length(sub_dir), n_time);
entropy_recuperacion = zeros(length(sub_dir), n_time);
for i=1:length(sub_dir)
   for t=1:n_time
    prob_reposo = power_reposo(i, :, t)/sum(power_reposo(i, :, t));
    entropy_reposo(i, t) = -sum(prob_reposo.*log(prob_reposo));
    
    prob_transicion = power_transicion(i, :, t)/sum(power_transicion(i, :, t)); 
    entropy_transicion(i, t) = -sum(prob_transicion.*log(prob_transicion));
    
    prob_alteracion = power_alteracion(i, :, t)/sum(power_alteracion(i, :, t)); 
    entropy_alteracion(i, t) = -sum(prob_alteracion.*log(prob_alteracion));
    
    prob_recuperacion = power_recuperacion(i, :, t)/sum(power_recuperacion(i, :, t)); 
    entropy_recuperacion(i, t) = -sum(prob_recuperacion.*log(prob_recuperacion));
   end
end

entropy_reposo_mitad_sub = mean(entropy_reposo(:, 1:75), 2);
entropy_reposo_sub = mean(entropy_reposo, 2);
entropy_transicion_sub = mean(entropy_transicion, 2);
entropy_alteracion_sub = mean(entropy_alteracion, 2);
entropy_recuperacion_sub = mean(entropy_recuperacion, 2);

dif_transicion =  entropy_transicion_sub - entropy_reposo_mitad_sub;
dif_alteracion =  entropy_alteracion_sub - entropy_reposo_mitad_sub;
dif_recuperacion =  entropy_recuperacion_sub - entropy_reposo_mitad_sub;

bar([mean(dif_transicion), mean(dif_alteracion), mean(dif_recuperacion)])
hold on
errorbar([mean(dif_transicion), mean(dif_alteracion), mean(dif_recuperacion)], [std(dif_transicion)/sqrt(length(sub_dir)), std(dif_alteracion)/sqrt(length(sub_dir)), std(dif_recuperacion)/sqrt(length(sub_dir))], '.')

%% alteracion cuartiles

entropy_reposo1 = entropy_reposo(:, 1:37);
entropy_reposo2 = entropy_reposo(:, 38:74);
entropy_reposo3 = entropy_reposo(:, 75:111);
entropy_reposo4 = entropy_reposo(:, 112:end);

entropy_reposo1_sub = mean(entropy_reposo1, 2);
entropy_reposo2_sub = mean(entropy_reposo2, 2);
entropy_reposo3_sub = mean(entropy_reposo3, 2);
entropy_reposo4_sub = mean(entropy_reposo4, 2);

entropy_transicion1 = entropy_transicion(:, 1:37);
entropy_transicion2 = entropy_transicion(:, 38:74);
entropy_transicion3 = entropy_transicion(:, 75:111);
entropy_transicion4 = entropy_transicion(:, 112:end);

entropy_transicion1_sub = mean(entropy_transicion1, 2);
entropy_transicion2_sub = mean(entropy_transicion2, 2);
entropy_transicion3_sub = mean(entropy_transicion3, 2);
entropy_transicion4_sub = mean(entropy_transicion4, 2);

entropy_alteracion1 = entropy_alteracion(:, 1:37);
entropy_alteracion2 = entropy_alteracion(:, 38:74);
entropy_alteracion3 = entropy_alteracion(:, 75:111);
entropy_alteracion4 = entropy_alteracion(:, 112:end);

entropy_alteracion1_sub = mean(entropy_alteracion1, 2);
entropy_alteracion2_sub = mean(entropy_alteracion2, 2);
entropy_alteracion3_sub = mean(entropy_alteracion3, 2);
entropy_alteracion4_sub = mean(entropy_alteracion4, 2);

entropy_recuperacion1 = entropy_recuperacion(:, 1:37);
entropy_recuperacion2 = entropy_recuperacion(:, 38:74);
entropy_recuperacion3 = entropy_recuperacion(:, 75:111);
entropy_recuperacion4 = entropy_recuperacion(:, 112:end);

entropy_recuperacion1_sub = mean(entropy_recuperacion1, 2);
entropy_recuperacion2_sub = mean(entropy_recuperacion2, 2);
entropy_recuperacion3_sub = mean(entropy_recuperacion3, 2);
entropy_recuperacion4_sub = mean(entropy_recuperacion4, 2);

dif_alteracion1 =  entropy_alteracion1_sub - entropy_reposo_sub;
dif_alteracion2 =  entropy_alteracion2_sub - entropy_reposo_sub;
dif_alteracion3 =  entropy_alteracion3_sub - entropy_reposo_sub;
dif_alteracion4 =  entropy_alteracion4_sub - entropy_reposo_sub;

dif_transicion1 =  entropy_transicion1_sub - entropy_reposo_sub;
dif_transicion2 =  entropy_transicion2_sub - entropy_reposo_sub;
dif_transicion3 =  entropy_transicion3_sub - entropy_reposo_sub;
dif_transicion4 =  entropy_transicion4_sub - entropy_reposo_sub;


bar([mean(entropy_reposo1_sub), mean(entropy_reposo2_sub), mean(entropy_reposo3_sub), mean(entropy_reposo4_sub),...
    mean(entropy_transicion1_sub), mean(entropy_transicion2_sub), mean(entropy_transicion3_sub), mean(entropy_transicion4_sub),...
    mean(entropy_alteracion1_sub), mean(entropy_alteracion2_sub), mean(entropy_alteracion3_sub), mean(entropy_alteracion4_sub),...
    mean(entropy_recuperacion1_sub), mean(entropy_recuperacion2_sub), mean(entropy_recuperacion3_sub), mean(entropy_recuperacion4_sub)])

hold on
errorbar([mean(dif_transicion), mean(dif_alteracion), mean(dif_recuperacion)], [std(dif_transicion)/sqrt(length(sub_dir)), std(dif_alteracion)/sqrt(length(sub_dir)), std(dif_recuperacion)/sqrt(length(sub_dir))], '.')

