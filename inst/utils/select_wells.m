% select_wells  Logical index of plate wells matching a given name/pattern.
%
%   IDX = select_wells(PLATEMAP, PATTERN) returns a logical index into
%   PLATEMAP.Name (and therefore into any other well-aligned data, like
%   absorbance) selecting wells whose Name matches PATTERN exactly.
%
%   IDX = select_wells(PLATEMAP, PATTERN, MODE) selects using a different
%   matching strategy:
%     "exact"  - (default) Name must equal PATTERN exactly
%     "prefix" - Name must start with PATTERN (e.g. "This" matches
%                "This - foo" and "This - bar")
%     "regex"  - PATTERN is a regular expression tested against Name
%                (e.g. "^This" is equivalent to prefix matching, but
%                regex also lets you match suffixes, wildcards, etc.)
function idx = select_wells(platemap, pattern, mode)
    if nargin < 3
        mode = "exact";
    end
    idx = cellfun(@(x) matches_pattern(x, pattern, mode), platemap.Name);
end

%!test
%! platemap.Name = {"Blank", "Standard", "Sample1", "Sample1"};
%! idx = select_wells (platemap, "Sample1");
%! assert (idx, logical ([0, 0, 1, 1]));

%!test
%! platemap.Name = {"Blank", "Standard", "Sample1"};
%! idx = select_wells (platemap, "Sample2");
%! assert (idx, logical ([0, 0, 0]));

%!test
%! platemap.Name = {"Blank", "Sample1"};
%! idx = select_wells (platemap, "blank");
%! assert (idx, logical ([0, 0]));

%!test
%! platemap.Name = {"Standard", "Standard", "Standard"};
%! idx = select_wells (platemap, "Standard");
%! assert (idx, logical ([1, 1, 1]));

%!test
%! % Prefix mode: everything starting with "This" groups together,
%! % regardless of what follows.
%! platemap.Name = {"This - foo", "This - bar", "That - baz", "Standard"};
%! idx = select_wells (platemap, "This", "prefix");
%! assert (idx, logical ([1, 1, 0, 0]));

%!test
%! % Exact mode is untouched by the new prefix-matching wells -- "This"
%! % alone still shouldn't match "This - foo".
%! platemap.Name = {"This - foo", "This"};
%! idx = select_wells (platemap, "This", "exact");
%! assert (idx, logical ([0, 1]));

%!test
%! % Regex mode for cases prefix can't express, e.g. matching either of
%! % two families of names in one call.
%! platemap.Name = {"This - foo", "That - bar", "Other - baz"};
%! idx = select_wells (platemap, "^(This|That)", "regex");
%! assert (idx, logical ([1, 1, 0]));
