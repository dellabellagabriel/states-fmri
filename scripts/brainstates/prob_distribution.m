%% parameters
centroid_file = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/brainstates/centroids/Cord-10-264.mat';
windows_file = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/results/brainstates/windows/windows_consensus_264.mat';

%% processing

n_states = 10;
n_subs = 18;

load(centroid_file)
load(windows_file)

Cvec = [];
for i=1:size(Cord, 1)
    Cvec(i,:) = tri2vec(squeeze(Cord(i,:,:)));
end

prob = [];
for iSub=1:n_subs
    display(iSub)
    for iCond=1:4
        %display(iCond)

        data = squeeze(windows_for_brainstates(iCond, iSub,:,:));

        distances = pdist2(data, Cvec, 'cityblock');
        [~,km] = min(distances');
        [probh, ~] = probdist(km', n_states);
        prob(iSub, iCond, :) = probh';
        
    end
end

prob_reposo = squeeze(prob(:, 1, :));
prob_transicion = squeeze(prob(:, 2, :));
prob_alteracion = squeeze(prob(:, 3, :));
prob_recuperacion = squeeze(prob(:, 4, :));

prob_state_1 = squeeze(prob(:, :, 1));
prob_state_2 = squeeze(prob(:, :, 2));
prob_state_3 = squeeze(prob(:, :, 3));
prob_state_4 = squeeze(prob(:, :, 4));
prob_state_5 = squeeze(prob(:, :, 5));
prob_state_6 = squeeze(prob(:, :, 6));
prob_state_7 = squeeze(prob(:, :, 7));
prob_state_8 = squeeze(prob(:, :, 8));
prob_state_9 = squeeze(prob(:, :, 9));
prob_state_10 = squeeze(prob(:, :, 10));

%% histograma
max_val = 0.35;
subplot(1,4,1)
bar(mean(prob_reposo, 1))
hold on
errorbar(mean(prob_reposo, 1), std(prob_reposo)./sqrt(n_subs), '.')
title('reposo')
ylim([0 max_val])
xlim([0 n_states+1])

subplot(1,4,2)
bar(mean(prob_transicion, 1))
hold on
errorbar(mean(prob_transicion, 1), std(prob_transicion)./sqrt(n_subs), '.')
title('trans')
ylim([0 max_val])
xlim([0 n_states+1])

subplot(1,4,3)
bar(mean(prob_alteracion, 1))
hold on
errorbar(mean(prob_alteracion, 1), std(prob_alteracion)./sqrt(n_subs), '.')
title('alt')
ylim([0 max_val])
xlim([0 n_states+1])

subplot(1,4,4)
bar(mean(prob_recuperacion, 1))
hold on
errorbar(mean(prob_recuperacion, 1), std(prob_recuperacion)./sqrt(n_subs), '.')
title('recup')
ylim([0 max_val])
xlim([0 n_states+1])

%% histograma por brain state
figure
for i=1:n_states
   prob_state = squeeze(prob(:,:,i));
   subplot(2,5,i)
   bar(mean(prob_state))
   hold on
   errorbar(mean(prob_state), std(prob_state)./sqrt(n_subs), '.')
   set(gca, 'xticklabels', {'rep','tra','alt','rec'})
   title(['state ', num2str(i)])
   ylim([0 0.35])
end

%% plot centroids
figure
min_val = -0.5;
max_val = 0.5;

for i=1:n_states
    subplot(2,5,i)
    imagesc(squeeze(Cord(i,:,:)))
    caxis([min_val max_val])
    title(['state ', num2str(i)])
end

roi_id = importdata('/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/func_networks/masks/rois264_identity.txt');
Cord_networks = zeros(n_states, 14, 14);
figure
for iSub=1:n_states
   for iFunc=1:14
       for jFunc=1:14
            rois_i = roi_id == iFunc;
            rois_j = roi_id == jFunc;
            Cord_networks(i, iFunc, jFunc) = mean(mean(squeeze(Cord(i,rois_i,rois_j))));
            
            subplot(2,5,i)
            imagesc(squeeze(Cord_networks(i,:,:)))
            %caxis([-0.3, 0.3])
            title(['state ', num2str(i)])
       end
   end
end

%% plot dendrogram
tree = linkage(reshape(Cord, n_states, 264*264),'average');
h = dendrogram(tree);

%% plot centroides ordenados por red funcional
[~, roi_id_sorted] = sort(roi_id);
c1_func = squeeze(Cord(1,roi_id_sorted,roi_id_sorted));
c2_func = squeeze(Cord(2,roi_id_sorted,roi_id_sorted));
c3_func = squeeze(Cord(3,roi_id_sorted,roi_id_sorted));
c4_func = squeeze(Cord(4,roi_id_sorted,roi_id_sorted));
c5_func = squeeze(Cord(5,roi_id_sorted,roi_id_sorted));

imagesc(c1_func)
hold on
sum_par = 0;
for iFunc=1:14
    sum_par = sum_par + length(find(roi_id == iFunc));
    plot( [1 264], [sum_par+0.5 sum_par+0.5], 'color', [1 1 1])
    plot( [sum_par+0.5 sum_par+0.5], [1 264], 'color', [1 1 1])
end
caxis([-0.5 0.5])

%% principal eigenvector
[v,lambda] = eig(squeeze(Cord(1,:,:)));
centroid_v1 = v(:,90) * v(:,90)'; 
v1 = v(:,90);
[v,lambda] = eig(squeeze(Cord(2,:,:)));
centroid_v2 = v(:,90) * v(:,90)';
v2 = v(:,90);
[v,lambda] = eig(squeeze(Cord(3,:,:)));
centroid_v3 = v(:,90) * v(:,90)';
v3 = v(:,90);

min_val = -0.03;
max_val = 0.03;
figure
subplot(1,3,1)
imagesc(centroid_v1)
caxis([min_val max_val])
subplot(1,3,2)
imagesc(centroid_v2)
caxis([min_val max_val])
subplot(1,3,3)
imagesc(centroid_v3)
caxis([min_val max_val])

figure
subplot(1,3,1)
plot_nodes_in_cortex(v1)
title('state 1')
subplot(1,3,2)
plot_nodes_in_cortex(v2)
title('state 2')
subplot(1,3,3)
plot_nodes_in_cortex(v3)
title('state 3')