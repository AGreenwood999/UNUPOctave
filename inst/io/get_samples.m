% get_samples  Compute per-sample Fe/Fe3O4 concentration and mass from a fitted standards curve.
%
%   SAMPLES = get_samples(DATA) finds every well in DATA.platemap.Name that
%   isn't labeled "Blank" or "Standard" (and isn't empty), groups replicate
%   wells by name, and for each sample name back-calculates:
%     - well_concentration_Fe   : Fe concentration implied by the well's
%                                 absorbance and the standards curve
%                                 (DATA.standards.m / .b)
%     - sample_concentration_Fe : well concentration corrected for
%                                 DilutionFactor
%     - sample_mass_Fe          : sample concentration scaled by
%                                 FinalVolume
%     - sample_mass_Fe3O4       : Fe mass converted to Fe3O4 mass via the
%                                 molar mass ratio, 1.382
%
%   DATA must have fields:
%     .absorbance      - background-corrected absorbance, one per well
%     .standards.m, .b - linear calibration from get_standards
%     .platemap.Name, .platemap.DilutionFactor, .platemap.FinalVolume
%
%   Sample names are sanitized into valid struct field names (see
%   sanitize_fieldname.m) since raw plate-map labels (e.g. "Sample 1")
%   aren't always legal Octave field names. The original, unsanitized
%   label is preserved as SAMPLES.(field).name for display purposes (e.g.
%   plot legends).
%
%   Returns a struct SAMPLES with one field per sample name.
function samples = get_samples(data)
    % Every well name that isn't a Blank/Standard/empty is treated as a
    % distinct sample; replicate wells share a name and get grouped below.
    raw_names = unique(data.platemap.Name(cellfun(@(x) !strcmp(x, "Blank") && !strcmp(x, "Standard") && !isempty(x), data.platemap.Name)));

    samples = struct();
    for i = 1:length(raw_names)
        idx = select_wells(data.platemap, raw_names{i});

        dilution_factor = data.platemap.DilutionFactor(idx);
        final_volume = data.platemap.FinalVolume(idx);

        field = sanitize_fieldname(raw_names{i});
        if isfield(samples, field)
            % Two different plate-map labels sanitized to the same struct
            % field -- without this check the second sample would silently
            % overwrite the first.
            warning(["Sample name '", raw_names{i}, "' collides with an existing field '", field, "' after sanitizing for struct use -- its data will overwrite the previous entry."]);
        end

        samples.(field).name = raw_names{i};
        samples.(field).absorbance = data.absorbance(idx);
        samples.(field).well_concentration_Fe = (data.absorbance(idx) - data.standards.b) ./ data.standards.m;
        samples.(field).sample_concentration_Fe = samples.(field).well_concentration_Fe .* dilution_factor;
        samples.(field).sample_mass_Fe = samples.(field).sample_concentration_Fe .* final_volume;
        samples.(field).sample_mass_Fe3O4 = samples.(field).sample_mass_Fe * 1.382;
    end
end



%!shared data
%! data.platemap.Name = {"Blank", "Standard", "Sample A", "Sample A", "Sample B"};
%! data.platemap.DilutionFactor = [1; 1; 2; 2; 5];
%! data.platemap.FinalVolume = [1; 1; 10; 10; 20];
%! data.absorbance = [0; 0; 0.3; 0.5; 0.9];
%! data.standards.m = 0.2;
%! data.standards.b = 0.1;

%!test
%! % Blank/Standard wells are excluded; sample names are sanitized to
%! % valid fields, and the original label is preserved for display.
%! samples = get_samples (data);
%! assert (isequal (sort (fieldnames (samples)), sort ({"Sample_A"; "Sample_B"})));
%! assert (samples.Sample_A.name, "Sample A");
%! assert (samples.Sample_B.name, "Sample B");

%!test
%! % Hand-computed arithmetic for a replicated sample:
%! % well_concentration_Fe = (absorbance - b) / m
%! % sample_concentration_Fe = well_concentration_Fe * DilutionFactor
%! % sample_mass_Fe = sample_concentration_Fe * FinalVolume
%! % sample_mass_Fe3O4 = sample_mass_Fe * 1.382
%! samples = get_samples (data);
%! assert (samples.Sample_A.well_concentration_Fe, [1; 2], 1e-10);
%! assert (samples.Sample_A.sample_concentration_Fe, [2; 4], 1e-10);
%! assert (samples.Sample_A.sample_mass_Fe, [20; 40], 1e-10);
%! assert (samples.Sample_A.sample_mass_Fe3O4, [27.64; 55.28], 1e-10);
%! assert (samples.Sample_B.sample_mass_Fe3O4, 552.8, 1e-10);

%!shared collision_data
%! % "Sample A" and "Sample-A" both sanitize to "Sample_A" -- this should
%! % warn rather than silently clobber the first sample's data.
%! collision_data.platemap.Name = {"Sample A", "Sample-A"};
%! collision_data.platemap.DilutionFactor = [1; 1];
%! collision_data.platemap.FinalVolume = [1; 1];
%! collision_data.absorbance = [0.3; 0.5];
%! collision_data.standards.m = 0.2;
%! collision_data.standards.b = 0.1;

%!warning get_samples (collision_data)
