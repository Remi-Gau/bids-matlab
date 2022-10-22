function layout_timing
  %
  % runs bids.layout on the bids-examples
  % and gives an estimate of the timing for each
  %
  % requires tests/utils to be in the matlab path to run

  % (C) Copyright 2022 BIDS-MATLAB developers

  debug = false;

  % nb of iterations for each dataset to get an average
  nb_runs = 2;

  % schema / index_dependencies
  conditions = [1 1
                0 1
                0 0];

  for c = 1:size(conditions, 1)

    use_schema = conditions(c, 1);
    index_dependencies = conditions(c, 2);

    pth_bids_example = get_test_data_dir();

    datasets = dir(pth_bids_example);
    remove = arrayfun(@(x) ~x.isdir || ismember(x.name, {'.', '..', '.git', '.github'}), datasets);
    datasets(remove) = [];

    tsv_content = struct('dataset', {}, 'nb_files', {});
    for r = 1:nb_runs
      tsv_content(1).(['time_' num2str(r)]) = {};
    end

    for d = 1:numel(datasets)

      tsv_content.dataset{d} = datasets(d).name;

      fprintf('%s:', datasets(d).name);

      for r = 1:nb_runs

        fprintf('.');

        tic;
        BIDS = bids.layout(fullfile(pth_bids_example, datasets(d).name), ...
                           'use_schema', use_schema, ...
                           'verbose', false, ...
                           'index_dependencies', index_dependencies);
        tsv_content.nb_files{d} = num2str(numel(bids.query(BIDS, 'data')));
        tsv_content.(['time_' num2str(r)]){d} = toc;

      end

      fprintf('\n');

      if debug && d > 2
        break
      end

    end

    platform = 'malab';
    if bids.internal.is_octave()
      platform = 'octave';
    end

    filename = ['bids_', platform, ...
                '_schema_', num2str(use_schema), ...
                '_dep_', num2str(index_dependencies), ...
                '.tsv'];

    bids.util.tsvwrite(fullfile(pwd, filename), tsv_content);

    fprintf('\n');

  end

end
