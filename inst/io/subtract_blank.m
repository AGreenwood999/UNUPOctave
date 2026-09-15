% subtract_blank  Background-correct raw absorbance readings against the Blank wells.
%
%   CORRECTED = subtract_blank(DATA) subtracts the mean absorbance of every
%   well labeled "Blank" in DATA.platemap.Name from every well in
%   DATA.raw, so all downstream calculations start from a background-
%   corrected signal.
%
%   DATA must have fields:
%     .raw            - raw absorbance readings, one value per well
%     .platemap.Name  - cell array of well labels, aligned with .raw
function corrected = subtract_blank(data)
    blank = data.raw(select_wells(data.platemap, "Blank"));
    corrected = data.raw - mean(blank);
end


%!test
%! data.raw = [0.05; 0.06; 0.2; 0.3];
%! data.platemap.Name = {"Blank", "Blank", "Sample1", "Sample1"};
%! corrected = subtract_blank(data);
%! assert (corrected, [-0.005; 0.005; 0.145; 0.245], 1e-10);

%!test
%! % No Blank wells at all -- documents current behavior: mean([]) is NaN
%! % in Octave, so every well ends up NaN rather than erroring. Worth
%! % knowing this is what happens today, whether or not it's what you want.
%! data.raw = [0.1; 0.2];
%! data.platemap.Name = {"Sample1", "Sample1"};
%! corrected = subtract_blank (data);
%! assert (all (isnan (corrected)));
