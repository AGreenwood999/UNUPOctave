% select_wells  Logical index of plate wells matching a given name.
%
%   IDX = select_wells(PLATEMAP, NAME) returns a logical index into
%   PLATEMAP.Name (and therefore into any other well-aligned data, such as
%   absorbance readings) selecting only the wells whose Name matches NAME
%   exactly (e.g. "Blank", "Standard", or a sample name).
function idx = select_wells(platemap, name)
    idx = cellfun(@(x) strcmp(x, name), platemap.Name);
end

%!test
%! % Basic case: one match, easy to hand-verify.
%! platemap.Name = {"Blank", "Standard", "Sample1", "Sample1"};
%! idx = select_wells (platemap, "Sample1");
%! assert (idx, logical ([0, 0, 1, 1]));

%!test
%! % No wells match the requested name -- should be all-false, not an error.
%! platemap.Name = {"Blank", "Standard", "Sample1"};
%! idx = select_wells(platemap, "Sample2");
%! assert (idx, logical([0, 0, 0]));

%!test
%! % Matching is case-sensitive: "blank" should not match "Blank".
%! platemap.Name = {"Blank", "Sample1"};
%! idx = select_wells (platemap, "blank");
%! assert (idx, logical([0, 0]));

%!test
%! % Every well matches (e.g. checking against a name that's on the whole plate).
%! platemap.Name = {"Standard", "Standard", "Standard"};
%! idx = select_wells (platemap, "Standard");
%! assert (idx, logical([1, 1, 1]));
