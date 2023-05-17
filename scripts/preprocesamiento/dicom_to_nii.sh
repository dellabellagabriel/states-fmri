#!/bin/bash 

#This script converts the DICOM files into .nii for each session. It identifies conditions based on the DICOM name

path_to_dicom="/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn/data/sub01"


#for session in $path_to_dicom/*; do
for session in "$path_to_dicom/session10-20230515"; do

	echo $session

	dcm2niix -o $session/functional $session/dicom
	rm $session/functional/*.json
	
	mv -f $session/functional/*t1* $session/structural/
	
	echo "cond 1..."
	mkdir $session/functional/cond1/
	mkdir $session/functional/cond1/nii/	
	mv -f $session/functional/*REPOSO* $session/functional/cond1/nii

	echo "cond 2..."
	mkdir $session/functional/cond2/
	mkdir $session/functional/cond2/nii/
	mv -f $session/functional/*TRANSICION* $session/functional/cond2/nii
	
	echo "cond 3..."
	mkdir $session/functional/cond3/
	mkdir $session/functional/cond3/nii/
	mv -f $session/functional/*ALTERACION* $session/functional/cond3/nii
	
	echo "cond 4..."
	mkdir $session/functional/cond4/
	mkdir $session/functional/cond4/nii/
	mv -f $session/functional/*RECUPERACION* $session/functional/cond4/nii
done

