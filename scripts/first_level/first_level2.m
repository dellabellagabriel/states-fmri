clear,clc

spm('defaults', 'FMRI');
spm_jobman('initcfg');

main_dir = '/home/usuario/disco1/proyectos/2023-resting-state-estados-fMRI_conn';
session_list = dir([main_dir, '/data/sub01/*']);
session_list(1:2) = [];

matlabbatch{1}.spm.stats.fmri_spec.dir = {[main_dir, '/results/first_level2']};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 36;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
%%

%onsets, chequear notas.txt
onsets      = [18,30,13,14,8,15,18, 10, 12, 18 , 12, 7];
onsets_rec  = [20, 26, 26, 19, 22];

duration = 0;

Sescont = 1;

for iSess=8:length(session_list)
    %set the scans
    scans = {};
    for t=1:150
        scans{t} = [main_dir, '/data/sub01/', session_list(iSess).name, '/functional/cond2/smooth/swautransicion.nii,', num2str(t)];
    end
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).scans = scans';
    
    %set the conditions (5 scans antes y despues)
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).cond(1).name = 'Thresh';
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).cond(1).onset = onsets(iSess);
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).cond(1).duration = duration;
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).cond(1).orth = 1;
    

    %regresores
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).multi_reg = {};
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).multi_reg = {[main_dir, '/data/sub01/', session_list(iSess).name, '/functional/cond2/nii/rp_transicion.txt']};
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).hpf = 128;
    
    Sescont = Sescont + 1;
    %set the scans
    scans = {};
    for t=1:150
        scans{t} = [main_dir, '/data/sub01/', session_list(iSess).name, '/functional/cond4/smooth/swaurecuperacion.nii,', num2str(t)];
    end
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).scans = scans';
    
    %set the conditions (5 scans antes y despues)
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).cond(1).name = 'Thresh_falso';
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).cond(1).onset = onsets_rec(iSess - 7);
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).cond(1).duration = duration;
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).cond(1).orth = 1;    

    %regresores
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).multi_reg = {};
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).multi_reg = {[main_dir, '/data/sub01/', session_list(iSess).name, '/functional/cond4/nii/rp_recuperacion.txt']};
    matlabbatch{1}.spm.stats.fmri_spec.sess(Sescont).hpf = 128;
    
    Sescont = Sescont + 1;
end

matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

matfile = [main_dir, '/results/first_level2/batch.mat'];
save(matfile,'matlabbatch');
jobs{1} = matfile;
spm_jobman('run', jobs);