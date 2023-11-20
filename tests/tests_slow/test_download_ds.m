function test_suite = test_download_ds %#ok<*STOUT>

  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;

end

function test_download_ds_moae()

  if ~run_slow_test_only()
    moxunit_throw_test_skipped_exception('slow test only');
  end

  output_dir = bids.util.download_ds('source', 'spm', ...
                                     'demo', 'moae', ...
                                     'out_path', temp_dir(), ...
                                     'force', false, ...
                                     'verbose', true, ...
                                     'delete_previous', false);

  output_dir = bids.util.download_ds('source', 'spm', ...
                                     'demo', 'moae', ...
                                     'out_path', temp_dir(), ...
                                     'force', true, ...
                                     'verbose', true, ...
                                     'delete_previous', false);

  output_dir = bids.util.download_ds('source', 'spm', ...
                                     'demo', 'moae', ...
                                     'out_path', temp_dir(), ...
                                     'force', true, ...
                                     'verbose', true, ...
                                     'delete_previous', true);

end

function test_download_ds_facerep()

  if ~run_slow_test_only()
    moxunit_throw_test_skipped_exception('slow test only');
  end

  output_dir = bids.util.download_ds('source', 'spm', ...
                                     'demo', 'facerep', ...
                                     'out_path', temp_dir(), ...
                                     'force', true, ...
                                     'verbose', true, ...
                                     'delete_previous', true);

end
