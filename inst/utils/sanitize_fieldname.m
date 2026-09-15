% sanitize_fieldname  Turn an arbitrary label into a valid struct field name.
%
%   VALID = sanitize_fieldname(NAME) replaces any character in NAME that
%   isn't a letter, digit, or underscore with an underscore, and prefixes
%   the result with "s_" if it would otherwise start with a digit (or be
%   empty) -- struct field names must start with a letter or underscore.
%
%   Used to turn free-text plate-map labels (e.g. "Sample 1") into legal
%   field names (e.g. "Sample_1") for use in get_samples.m. The original,
%   unsanitized label should be kept alongside the data (see
%   get_samples.m's SAMPLES.(field).name) since this transform is lossy.
function valid = sanitize_fieldname(name)
    valid = regexprep(name, " ", "");
    valid = regexprep(valid, "[^a-zA-Z0-9_]", "_");
    if isempty(valid) || !isempty(regexp(valid(1), "[0-9]", "once"))
        valid = ["s_", valid];
    end
end

%!assert (sanitize_fieldname ("Sample1"), "Sample1")
%!assert (sanitize_fieldname ("Sample 1"), "Sample1")
%!assert (sanitize_fieldname ("Fe-standard"), "Fe_standard")
%!assert (sanitize_fieldname ("3T3 cells"), "s_3T3cells")
%!assert (sanitize_fieldname (""), "s_")
%!assert (sanitize_fieldname ("_already_valid"), "_already_valid")
