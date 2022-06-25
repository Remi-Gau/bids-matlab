function data = Scale(transformer, data)
  %
  % Scales the values of one or more columns.
  % Semantics mimic scikit-learn, such that demeaning and
  % rescaling are treated as independent arguments,
  % with the default being to apply both
  % (i.e., standardizing each value so that it has zero mean and unit SD).
  %
  %
  % **JSON EXAMPLE**:
  %
  % .. code-block:: json
  %
  %       {
  %         "Name":  "Scale",
  %         "Input": "reaction_time",
  %         "Demean": true,
  %         "Rescale": true,
  %         "ReplaceNa": true,
  %         "Output": "scaled_reaction_time"
  %       }
  %
  %
  % Arguments:
  %
  % :param Input: **mandatory**.  Names of columns to standardize.
  % :type  Input: string or array
  %
  % :param Demean: optional. If ``true``, subtracts the mean from each input column
  %                          (i.e., applies mean-centering).
  % :type  Demean: boolean
  %
  % :param Rescale: optional. If ``true``, divides each column by its standard deviation.
  % :type  Rescale: boolean
  %
  % :param ReplaceNa: optional. Whether/when to replace missing values with 0.
  %                             If ``"off"``, no replacement is performed.
  %                             If ``"before"``, missing values are replaced with 0's
  %                             before scaling.
  %                             If ``"after"``, missing values are replaced with 0 after scaling.
  %                             Defaults to ``"off"``
  % :type  ReplaceNa: boolean
  %
  % :param Output: optional. Optional names of columns to output.
  %                          Must match length of input column if provided,
  %                          and columns will be mapped 1-to-1 in order.
  %                          If no output values are provided,
  %                          the scaling transformation is applied in-place to all the input.
  % :type  Output: string or array
  %
  %
  % **CODE EXAMPLE**::
  %
  %   transformer = struct('Name', 'Scale', ...
  %                        'Input', 'reaction_time',
  %                        'Demean', true,
  %                        'Rescale', true,
  %                        'ReplaceNa', true,
  %                        'Output', 'scaled_reaction_time');
  %
  %   data.reaction_time =
  %
  %   data = bids.transformers(transformer, data);
  %
  %   data.scaled_reaction_time =
  %
  %   ans =
  %
  %
  % (C) Copyright 2022 BIDS-MATLAB developers

  input = bids.transformers.get_input(transformer, data);
  output = bids.transformers.get_output(transformer, data);

  demean = true;
  if isfield(transformer, 'Demean')
    demean = transformer.Demean;
  end

  rescale = true;
  if isfield(transformer, 'Rescale')
    rescale = transformer.Rescale;
  end

  replace_na = 'off';
  if isfield(transformer, 'ReplaceNa')
    replace_na = transformer.ReplaceNa;
  end

  for i = 1:numel(input)

    this_input = data.(input{i});

    if ~isnumeric(this_input)
      error('non numeric variable: %s', input{i});
    end

    nan_values = isnan(this_input);

    if numel(unique(this_input)) == 1 && ismember(replace_na, {'off', 'before'})
      error(['Cannot scale a column with constant value %s\n', ...
             'If you want a constant column of 0 returned,\n'
             'set "replace_na" to "after"'], unique(this_input));
    end

    if strcmp(replace_na, 'before')
      this_input(nan_values) = zeros(sum(nan_values));
    end

    if demean
      this_input = this_input - mean(this_input, 'omitnan');
    end

    if rescale
      this_input = this_input / std(this_input, 'omitnan');
    end

    if strcmp(replace_na, 'after')
      this_input(nan_values) = zeros(sum(nan_values));
    end

    data.(output{i}) = this_input;

  end

end
