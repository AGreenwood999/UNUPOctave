% matches_pattern  Test a single string against a pattern under a given mode.
%
%   TF = matches_pattern(STR, PATTERN, MODE) where MODE is one of "exact",
%   "prefix", "suffix", or "regex" -- see select_wells.m for what each
%   mode means. Shared by select_wells.m and filter_samples.m so the
%   matching rules only need to be defined (and tested) in one place.
function tf = matches_pattern(str, pattern, mode)
    switch mode
        case "exact"
            tf = strcmp(str, pattern);
        case "prefix"
            tf = startsWith(str, pattern);
        case "suffix"
            tf = endsWith(str, pattern);
        case "regex"
            tf = !isempty(regexp(str, pattern, "once"));
        otherwise
            error(["matches_pattern: unknown mode '", mode, "'. Expected 'exact', 'prefix', 'suffix', or 'regex'."]);
    end
end

%!assert (matches_pattern ("This - foo", "This", "prefix"), true)
%!assert (matches_pattern ("That - foo", "This", "prefix"), false)
%!assert (matches_pattern ("foo - This", "This", "suffix"), true)
%!assert (matches_pattern ("This", "This", "exact"), true)
%!assert (matches_pattern ("This - foo", "This", "exact"), false)
%!assert (matches_pattern ("This - foo", "^(This|That)", "regex"), true)
