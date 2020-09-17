v5_path =  '/home/remi/gin/V5_high-res/pilot_1/raw';

plot_events(v5_path)

% %%
% modalities = bids.query(BIDS, 'modalities');
% types = bids.query(BIDS, 'types');
% subjects = bids.query(BIDS, 'subjects');
% tasks = bids.query(BIDS, 'tasks');
% runs = bids.query(BIDS, 'runs');
% tsv_files = bids.query(BIDS, 'data', 'type', 'events');
% 
% %%
% 
% plot_events(path_to_bids)