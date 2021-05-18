function test_suite = test_layout_derivatives %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_layout_prefix()

  pth_bids_example = get_test_data_dir();

  use_schema = false();

  copyfile(fullfile(pth_bids_example, 'ds001', 'sub-01', 'func', ...
                    'sub-01_task-balloonanalogrisktask_run-01_bold.nii.gz'), ...
           fullfile(pth_bids_example, 'ds001', 'sub-01', 'func', ...
                    'swuasub-01_task-balloonanalogrisktask_run-01_bold.nii'));

  BIDS = bids.layout(fullfile(pth_bids_example, 'ds001'), use_schema);

  data = bids.query(BIDS, 'data', ...
                    'sub', '01', ...
                    'run', '01', ...
                    'prefix', 'swua');
  basename = bids.internal.file_utils(data, 'basename');
  assertEqual(basename, {'swuasub-01_task-balloonanalogrisktask_run-01_bold'});

  assertEqual(bids.query(BIDS, 'prefixes'), {'swua'});

end

function test_layout_parse_json()

  pth_bids_example = get_test_data_dir();

  BIDS = bids.layout(fullfile(pth_bids_example, 'ds000248'));

  data = bids.query(BIDS, 'data', ...
                    'sub', '01', ...
                    'modality', 'anat');

  assertEqual(size(data, 1), 2);

  %%
  use_schema = false();

  BIDS = bids.layout(fullfile(pth_bids_example, 'ds000248'), use_schema);

  data = bids.query(BIDS, 'data', ...
                    'sub', '01', ...
                    'modality', 'anat');

  assertEqual(size(data, 1), 4);

end

function test_layout_schemaless()

  pth_bids_example = get_test_data_dir();

  use_schema = false();

  BIDS = bids.layout(fullfile(pth_bids_example, ...
                              'ds000001-fmriprep'), use_schema);

  modalities = {'anat', 'figures', 'func'};
  assertEqual(bids.query(BIDS, 'modalities'), modalities);

  data = bids.query(BIDS, 'data', ...
                    'sub', '10', ...
                    'modality', 'func', ...
                    'suffix', 'bold', ...
                    'run', '1', ...
                    'res', '2');

  basename = bids.internal.file_utils(data, 'basename');
  assertEqual(basename(2), {
                            ['sub-10_task-balloonanalogrisktask_run-1', ...
                             '_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold.nii']
                           });

  data = bids.query(BIDS, 'data', ...
                    'sub', '10', ...
                    'modality', 'func', ...
                    'suffix', 'bold', ...
                    'run', '1', ...
                    'space', 'MNI152NLin6Asym');

  basename = bids.internal.file_utils(data, 'basename');
  assertEqual(basename, {
                         ['sub-10_task-balloonanalogrisktask_run-1', ...
                          '_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold.nii']
                        });
end

function test_layout_nested_derivatives()

  pth_bids_example = get_test_data_dir();

  use_schema = false();

  BIDS = bids.layout(fullfile(pth_bids_example, ...
                              'ds000117', ...
                              'derivatives', ...
                              'meg_derivatives'), use_schema);

  modalities = {'meg'};
  assertEqual(bids.query(BIDS, 'modalities'), modalities);

  data = bids.query(BIDS, 'data', ...
                    'sub', '01', ...
                    'run', '01', ...
                    'proc', 'sss', ...
                    'suffix', 'meg');
  basename = bids.internal.file_utils(data, 'basename');
  assertEqual(basename, {'sub-01_ses-meg_task-facerecognition_run-01_proc-sss_meg'});

end