% filter_samples  Keep or drop a subset of an already-computed samples struct.
%
%   SUBSET = filter_samples(SAMPLES, PATTERN) returns a struct containing
%   only the samples (fields of SAMPLES, as produced by get_samples.m)
%   whose original name matches PATTERN exactly.
%
%   SUBSET = filter_samples(SAMPLES, PATTERN, MODE) matches using a
%   different strategy -- "exact" (default), "prefix", "suffix", or
%   "regex" -- see select_wells.m for what each means. Matching is done
%   against each sample's original (unsanitized) name, i.e.
%   SAMPLES.(field).name, not the sanitized struct field itself.
%
%   SUBSET = filter_samples(SAMPLES, PATTERN, MODE, true) inverts the
%   match, returning everything that does NOT match PATTERN -- e.g. to
%   drop a known-bad sample or family of samples:
%     good = filter_samples(data.samples, "Sample3_replicate2", "exact", true);
function subset = filter_samples(samples, pattern, mode, invert)
    if nargin < 3
        mode = "exact";
    end
    if nargin < 4
        invert = false;
    end

    fields = fieldnames(samples);
    subset = struct();
    for i = 1:length(fields)
        is_match = matches_pattern(samples.(fields{i}).name, pattern, mode);
        if is_match != invert
            subset.(fields{i}) = samples.(fields{i});
        end
    end
end

%!shared samples
%! samples.ThisFoo.name = "This - foo";
%! samples.ThisBar.name = "This - bar";
%! samples.ThatBaz.name = "That - baz";

%!test
%! subset = filter_samples (samples, "This", "prefix");
%! assert (sort (fieldnames (subset)), sort ({"ThisFoo"; "ThisBar"}));

%!test
%! % Inverted: everything except the "This" family.
%! subset = filter_samples (samples, "This", "prefix", true);
%! assert (fieldnames (subset), {"ThatBaz"});

%!test
%! % Exact mode, single sample dropped -- the stated use case (exclude
%! % one bad sample, keep everything else).
%! subset = filter_samples (samples, "That - baz", "exact", true);
%! assert (sort (fieldnames (subset)), sort ({"ThisFoo"; "ThisBar"}));
