clc,clear

addpath /home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/scripts/pci/lz

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
sublist = dir([main_dir, '/results/func_networks/consensus_264/*']);
sublist([1,2]) = [];

pci_values = [];
pci_values_codebook = [];
pci_values_mean = [];
for iSub=1:length(sublist)
   subname = sublist(iSub).name; 
   display(subname)
   
   counter = 1;
   for iCond=1:4
       display(['condicion ', num2str(iCond)])
       load([main_dir, '/results/func_networks/consensus_264/', subname, '/cond', num2str(iCond), '/func_roi.mat'], 'func_roi') 
      
       
       for t=1:50:150
           tramo = func_roi(:,t:t+49);

          for iRoi=1:264
             h = abs(hilbert(tramo(iRoi,:)));
             sig = strrep(num2str(h > mean(h)), '  ', '');
             [value codeBook NumRep NumRepBin ] = lempelzivEnc(sig, cellstr(['0';'1']));
             outputLength = length( NumRepBin{1})*length(NumRepBin)-length(NumRepBin);
             pci_values(iSub, counter, iRoi) = outputLength;
             pci_values_codebook(iSub, counter, iRoi) = length(codeBook);
          end
      
          counter = counter + 1;
       end
      
   end
end

roi_id = importdata([main_dir, '/scripts/func_networks/masks/rois264_identity.txt']);
pci_networks = [];
for iFunc=1:14
    inds = find(roi_id == iFunc);
    pci_networks(:, :, iFunc) = mean(pci_values(:,:,inds), 3);
end

%% figure
p = mean(pci_values, 3);
bar(mean(p))
hold on
errorbar(mean(p), std(p)/sqrt(size(p,1)), '.')
%ylim([205 212])

p_codebook = mean(pci_values_codebook, 3);
bar(mean(p_codebook))
hold on
errorbar(mean(p_codebook), std(p_codebook)/sqrt(size(p_codebook,1)), '.')
%ylim([34 34.4])

p_networks = mean(pci_networks, 1);
bar(mean(p_networks))
hold on
errorbar(mean(p_networks), std(p_networks)/sqrt(size(p_networks,1)), '.')