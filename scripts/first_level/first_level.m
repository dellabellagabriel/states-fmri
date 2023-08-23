clear,clc

spm('defaults', 'FMRI');
spm_jobman('initcfg');

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
session_list = dir([main_dir, '/data/sub01/*']);
session_list(1:2) = [];

matlabbatch{1}.spm.stats.fmri_spec.dir = {[main_dir, '/results/first_level']};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 36;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
%%

%onsets, chequear notas.txt
onsets = [18,30,13,14,8,15,18, 10, 12, 18];
duration = 5;

for iSess=1:length(session_list)
   %set the scans
   scans = {};
   for t=1:150
       scans{t} = [main_dir, '/data/sub01/', session_list(iSess).name, '/functional/cond2/smooth/swautransicion.nii,', num2str(t)];
   end
   matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).scans = scans';
   
   %set the conditions (5 scans antes y despues)
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(1).name = 'before';
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(1).onset = onsets(iSess)-duration;
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(1).duration = duration;
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(1).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(2).name = 'after';
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(2).onset = onsets(iSess);
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(2).duration = duration;
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(2).orth = 1;
    
    %antes y despues todo
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(3).name = 'antes todo';
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(3).onset = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(3).duration = onsets(iSess);
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(3).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(4).name = 'despues todo';
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(4).onset = onsets(iSess);
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(4).duration = 150-onsets(iSess);
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).cond(4).orth = 1;
    
    %regresores
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).multi_reg = {[main_dir, '/data/sub01/', session_list(iSess).name, '/functional/cond2/nii/rp_transicion.txt']};
    matlabbatch{1}.spm.stats.fmri_spec.sess(iSess).hpf = 128;
   
end

matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

matfile = [main_dir, '/results/first_level/batch.mat'];
save(matfile,'matlabbatch');
jobs{1} = matfile;
spm_jobman('run', jobs);