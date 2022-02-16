function ds_template_generator(pth, folders, samples, runs, file_extension, task)

    for i_sub = 1:numel(folders.subjects)

        for i_ses = 1:numel(folders.sessions)

            for i_sample = 1:numel(samples)

                for i_run = 1:numel(runs)

                    % TODO why is entity order messed up?
                    file_cfg = struct('ext', file_extension, ...
                                      'modality', 'ephys', ...
                                      'suffix', 'ephys', ...
                                      'entities', struct('sub', folders.subjects{i_sub}, ...
                                                         'ses', folders.sessions{i_ses}, ...
                                                         'sample', samples{i_sample}, ...
                                                         'run', runs{i_run}, ...
                                                         'task', task));

                    create_files_and_side_car(pth, file_cfg, task);

                end

            end

        end

    end
