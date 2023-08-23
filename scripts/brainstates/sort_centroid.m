addpath /home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/brainstates/dataset

for i=1:size(C, 1)
   Cmat(i,:,:) = vec2tri(C(i,:));
   entropy(i) = histogram_entropy(squeeze(Cmat(i,:,:))); 
end

[~, idx] = sort(entropy, 'descend');
Cord = Cmat(idx, :, :);
save('Cord.mat', 'Cord')

%% estructural
load('/home/usuario/disco1/proyectos/2023-anestesia-graphSP/scripts/gsp/anat/sc.mat')

corrcoef(sc, squeeze(Cord(1,:,:)))
corrcoef(sc, squeeze(Cord(2,:,:)))
corrcoef(sc, squeeze(Cord(3,:,:)))
corrcoef(sc, squeeze(Cord(4,:,:)))
corrcoef(sc, squeeze(Cord(5,:,:)))