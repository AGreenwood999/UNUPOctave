% TODO: This needs some check for required information, right now "Name" and "DilutionFactor" and "FinalVolume"
% It also requires that the platemap, each sheet has the row and index number to make sure it's read right
%
% load_96well_plate_platemap  Parse a 96-well plate layout from a spreadsheet.
%
%   PLATEMAP = load_96well_plate_platemap(FILENAME) reads every sheet in the
%   spreadsheet FILENAME (read via the Octave `io` package) and returns a
%   struct PLATEMAP with one field per sheet name.
%
%   Each sheet is expected to hold one piece of well-level metadata laid out
%   as an 8x12 plate grid (rows A-H, columns 1-12), with cell A1 declaring
%   how to interpret the sheet:
%     "str"   - sheet holds text data (e.g. well Name labels)
%     "num"   - sheet holds numeric data (e.g. DilutionFactor, FinalVolume);
%               shape is checked against the expected plate grid
%     "mixed" - sheet holds a mix of types, returned as a raw cell array
%   Any other (or missing) value in A1 falls through to the "mixed"-style
%   raw read, with a warning, since there's then no way to know if a plain
%   numeric conversion would be safe.
%
%   Returns PLATEMAP.(sheet_name) for every sheet found in the file, e.g.
%   PLATEMAP.Name, PLATEMAP.DilutionFactor, PLATEMAP.FinalVolume.
function platemap = load_96well_plate_platemap(filename)
    pkg load io

    % Sheet names in this file become the field names of the output struct
    % (e.g. a "Name" sheet -> platemap.Name).
    [~, info] = xlsfinfo(filename);
    names = info(:, 1);

    for i = 1:length(names)
        % TODO: might want to check to see if the output is the right size ie 8x12
        [num, txt, raw] = xlsread(filename, names{i});

        % Cell A1 of each sheet declares its data type so we know how to
        % read the rest of the sheet (see header comment above).
        switch (raw{1, 1})
            case "str"
                % Drop the header row/column (row 1 = column numbers,
                % column 1 = row letters) and trim whitespace from labels.
                platemap.(names{i}) = strtrim(txt(2:end, 2:end));
            case "num"
                platemap.(names{i}) = num(2:end, :);
                [r, c] = size(platemap.(names{i}));

                if r != 8 || c != 12 
                    error([
                        "Plate map '", filename, "' has invalid shape on sheet '", names{i} ,"' for numeric data type.\nThe skeleton of the sheet should look like:\n",...
                        "num\t1\t2\t3\t4\t5\t6\t7\t8\t9\t10\t11\t12\n",...
                        "A\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\n",...
                        "B\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\n",...
                        "C\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\n",...
                        "D\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\n",...
                        "E\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\n",...
                        "F\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\n",...
                        "G\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\n",...
                        "H\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\t#\n",...
                        "Also ensure datatypes in the libreoffice sheet are correct (ie no alpha characters in numeric data).\n"
                    ])
                end
            case "mixed"
                % No safe type conversion possible; hand back the raw cell
                % array (still trimmed of the header row/column).
                platemap.(names{i}) = raw(2:end, 2:end);
            otherwise
                warning(["Type was not specified in cell A1 in sheet: '", names{i}, "' of plate map file: '", filename, "'.\nExpected 'str', 'num' or 'mixed'.\n\nUsing raw readings unintentionally may cause problems...\n"]);
                platemap.(names{i}) = raw(2:end, 2:end);
        end
    end
end
