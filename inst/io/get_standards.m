% TODO: should standards concentrations be defined in the plate map?
%
% get_standards  Fit a linear absorbance-vs-concentration standards curve.
%
%   STANDARDS = get_standards(DATA, CONC) pulls every well labeled
%   "Standard" out of DATA.absorbance, pairs them up against the known
%   concentrations in CONC, and fits a first-order (linear) least-squares
%   curve to them.
%
%   CONC should list the known concentration of each standard in plate
%   order, and is tiled to match however many replicate wells exist per
%   standard (e.g. 2 replicates of a 5-point curve -> 10 Standard wells,
%   CONC repeated twice). If the number of Standard wells found isn't a
%   clean multiple of length(CONC), this reshape will produce nonsense
%   (or error) -- see the TODO above.
%
%   Returns a struct STANDARDS with fields:
%     .X, .Y  - the concentration/absorbance pairs used for the fit
%     .params - polyfit coefficients [slope, intercept]
%     .s      - polyfit's stats struct (see `help polyfit`)
%     .m, .b  - slope and intercept, pulled out of .params for convenience
%     .r2     - R^2 of the fit (Octave-specific polyfit output field)
function standards = get_standards(data, conc)
    standards.Y = data.absorbance(select_wells(data.platemap, "Standard"));
    standards.X = repmat(conc, [length(standards.Y) / length(conc), 1]); % is this fragile with badly sized Y or conc?

    [standards.params, standards.s] = polyfit(standards.X, standards.Y, 1);
    standards.m = standards.params(1);
    standards.b = standards.params(2);
    standards.r2 = standards.s.rsquared;
end


%!shared data
%! data.platemap.Name = {"Standard", "Standard", "Standard", "Sample1"};
%! data.absorbance = [0.1; 0.3; 0.5; 0.4]; % three Standard wells, one Sample well

%!test
%! % Three points falling exactly on a line -- slope/intercept/r2 are all
%! % exactly known, so this pins down the fit math precisely.
%! standards = get_standards(data, [0; 1; 2]);
%! assert(standards.m, 0.2, 1e-10);
%! assert(standards.b, 0.1, 1e-10);
%! assert(standards.r2, 1, 1e-10);

%!error get_standards(data, [0; 1])
