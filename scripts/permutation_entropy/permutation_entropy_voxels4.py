import numpy as np
import ordpy
import matplotlib.pyplot as plt
from glob import glob
import os
import scipy.io as sio
import nibabel as nib
import sys

MAIN_DIR = "/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn"
N_rois = 264
subs = glob(f"{MAIN_DIR}/results/func_networks/consensus_264/*")
N_subs = len(subs)
brain_mask = sio.loadmat(f"{MAIN_DIR}/scripts/seed/masks/brainmask.mat")["mask"]

# por voxel
subs = glob(f"{MAIN_DIR}/data/sub01/*")
he_matrix = np.zeros((N_subs, 4, N_rois)) #subs x conditions
sc_matrix = np.zeros((N_subs, 4, N_rois)) #subs x conditions
voxel_mask = brain_mask == 1
N_voxels_mask = np.sum(voxel_mask)
for iSub, sub in enumerate(subs[10:13]):
    he_voxel = np.zeros((91,109,91))
    sc_voxel = np.zeros((91,109,91))
    print(f"subject {os.path.basename(sub)}")
    
    data = nib.load(f"{sub}/func-resting/{os.path.basename(sub)}-resting.nii")

    for iCond in range(1,5):
        print(f"condition {iCond}")
        cond = data.get_fdata()[:,:,:, (iCond-1)*150:iCond*150]

        for x in range(91):
            for y in range(109):
                for z in range(91):
                    print(f"{x},{y},{z}", end="\r", flush=True)

                    if np.sum(cond[x,y,z,:] == 0) != 150:
                        he_voxel[x,y,z], sc_voxel[x,y,z] = ordpy.complexity_entropy(cond[x,y,z,:], dx=4)
                    else:
                        he_voxel[x,y,z], sc_voxel[x,y,z] = (0, 0)
                
        sio.savemat(f"/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/results/permutation_entropy/{os.path.basename(sub)}-cond{iCond}.mat", {"he": he_voxel, "sc": sc_voxel})       
