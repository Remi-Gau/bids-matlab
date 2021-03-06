function test_suite = test_get_metadata_suffixes %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_get_metadata_suffixes_basic()
  % ensures that "similar" suffixes are distinguished

  data_dir = fullfile(fileparts(mfilename('fullpath')), 'data', 'SurfaceData');

  file = fullfile(data_dir, 'sub-06_hemi-R_space-individual_den-native_thickness.shape.gii');
  side_car = fullfile(data_dir, 'sub-06_hemi-R_space-individual_den-native_thickness.json');
  metadata = bids.internal.get_metadata(file);
  expected_metadata = bids.util.jsondecode(side_car);
  assertEqual(metadata, expected_metadata);

  file = fullfile(data_dir, 'sub-06_hemi-R_space-individual_den-native_midthickness.surf.gii');
  side_car = fullfile(data_dir, 'sub-06_hemi-R_space-individual_den-native_midthickness.json');
  metadata = bids.internal.get_metadata(file);
  expected_metadata = bids.util.jsondecode(side_car);
  assertEqual(metadata, expected_metadata);

  file = fullfile(data_dir, 'sub-06_space-individual_den-native_thickness.dscalar.nii');
  side_car = fullfile(data_dir, 'sub-06_space-individual_den-native_thickness.json');
  metadata = bids.internal.get_metadata(file);
  expected_metadata = bids.util.jsondecode(side_car);
  assertEqual(metadata, expected_metadata);

end

function test_get_metadata_particiants()
  % test files with no underscore in name.

  pth_bids_example = get_test_data_dir();

  file = fullfile(pth_bids_example, 'ds001', 'participants.tsv');
  side_car = fullfile(pth_bids_example, 'ds001', 'participants.json');
  metadata = bids.internal.get_metadata(file);
  expected_metadata = bids.util.jsondecode(side_car);
  assertEqual(metadata, expected_metadata);

end
