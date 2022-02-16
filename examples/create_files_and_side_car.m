function create_files_and_side_car(pth, file_cfg, task)

    bf = bids.File(file_cfg, 'use_schema', true);
    bf = bf.reorder_entities({'sub', 'ses', 'sample', 'task', 'run', 'split'});

    output_file = fullfile(pth, bf.bids_path, bf.filename);
    system(sprintf('touch %s', output_file));

    metadata.TaskName = task;
    create_side_car(pth, bf, metadata);

    other_suffixes = {'contacts', 'probes', 'events', 'channels'};
    for i = 1:numel(other_suffixes)

        file_cfg.ext = '.tsv';
        file_cfg.suffix = other_suffixes{i};

        bf = bids.File(file_cfg, 'use_schema', true);
        bf = bf.reorder_entities({'sub', 'ses', 'sample', 'task', 'run', 'split'});

        output_file = fullfile(pth, return_rel_path(bf), bf.filename);

        column_header = 'place_holder';

        content.(column_header) = 'foo';
        bids.util.tsvwrite(output_file, content);

        metadata.(column_header) = 'column description';
        create_side_car(pth, bf, metadata);

    end

end

function create_side_car(pth, bf, metadata)

    sidecar = fullfile(pth, return_rel_path(bf), bf.json_filename);
    bids.util.jsonencode(sidecar, metadata);

end

function bids_path = return_rel_path(bf)

    % TODO
    % fix inferring relative path file based on schema
    % this should only return one value when modality is provided
    bids_path = fullfile(['sub-' bf.entities.sub], ['ses-', bf.entities.ses], 'ephys');

end
