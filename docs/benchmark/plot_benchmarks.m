% (C) Copyright 2022 BIDS-MATLAB developers

no_schema = bids.util.tsvread('bids_matlab_schema_0.tsv');
with_schema = bids.util.tsvread('bids_matlab_schema_1.tsv');
pybids = bids.util.tsvread('pybids.tsv');

close all;

figure('name', 'benchmark', 'position', [100 100 1000 1000]);
hold on;

[time_mean, time_std] = return_mean_and_std(no_schema);
scatter(no_schema.nb_files, time_mean, 'b');

[time_mean, time_std] = return_mean_and_std(with_schema);
scatter(no_schema.nb_files, time_mean, 'b', 'filled');

[time_mean, time_std] = return_mean_and_std(pybids);
scatter(no_schema.nb_files, time_mean, 'g', 'filled');

legend({'bids-matlab: no schema', 'bids-matlab: with schema', 'pybids'});

ylabel('time elapsed');
xlabel('number of files indexed');

%%
function [this_mean, this_std] = return_mean_and_std(dataset)

  fields = fieldnames(dataset);
  fields = fields(~cellfun('isempty', regexpi(fields, '^time.*', 'match')));

  for r = 1:numel(fields)
    times(:, r) = dataset.(fields{r});
  end
  this_mean  = mean(times, 2);
  this_std = std(times, 0, 2);
end
