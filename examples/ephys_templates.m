% add bids-matlab to path
addpath(fullfile(pwd, '..'));
warning off;

pth = fullfile(pwd, 'dummy_ds');

task = 'reach';
file_extension = '.nwb';
samples = {'01'};
runs = {'01'};

folders.subjects = {'01'};
folders.sessions = {'01'};
folders.modalities = {'ephys'};

bids.init(pth, 'folders', folders, 'is_derivative', false, 'is_datalad_ds', false);

ds_template_generator(pth, folders, samples, runs, file_extension, task);
