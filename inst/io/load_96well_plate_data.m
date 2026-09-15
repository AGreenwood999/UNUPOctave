% TODO: Is there a better way than passing stds_conc?
%
% load_96well_plate_data  Load and process a 96-well plate absorbance assay.
%
%   OUT = load_96well_plate_data(DATA_CSV, PLATEMAP_ODS, STDS_CONC) reads a
%   raw absorbance reading CSV (DATA_CSV) alongside its plate-layout
%   spreadsheet (PLATEMAP_ODS), then runs the full processing pipeline:
%     1. Load the plate map (well -> Name/DilutionFactor/FinalVolume, etc.)
%     2. Subtract the mean blank-well reading from every well's raw signal
%     3. Fit a standards curve (absorbance vs. known Fe concentration,
%        STDS_CONC) to get a linear calibration (slope/intercept)
%     4. Back out Fe concentration/mass (and Fe3O4 mass) for every
%        non-blank, non-standard well
%
%   STDS_CONC is a vector of known Fe standard concentrations, in the same
%   order the standard wells appear on the plate (see get_standards.m for
%   how this is reshaped against the actual standard wells found).
%
%   Returns a struct OUT with fields:
%     .platemap   - the parsed plate map (see load_96well_plate_platemap.m)
%     .raw        - raw absorbance readings straight from the CSV
%     .absorbance - raw readings after blank subtraction
%     .standards  - fitted standards curve (see get_standards.m)
%     .samples    - per-sample concentrations/masses (see get_samples.m)
function out = load_96well_plate_data(data_csv, platemap_ods, stds_conc)
    out.platemap = load_96well_plate_platemap(platemap_ods);

    out.raw = csvread(data_csv);

    % Background-correct every well against the mean of the Blank wells.
    out.absorbance = subtract_blank(out);

    % Fit absorbance -> concentration calibration from the Standard wells.
    out.standards = get_standards(out, stds_conc);

    % Convert every remaining (non-blank, non-standard) well into a
    % per-sample concentration/mass using that calibration.
    out.samples = get_samples(out);
end
