% write_platemap_template  Generate a blank 96-well plate map template.
%
%   write_platemap_template(FILENAME) creates an ODS spreadsheet at
%   FILENAME with the three sheets load_96well_plate_platemap.m expects
%   (Name, DilutionFactor, FinalVolume), each pre-filled with the required
%   type tag, header row, and row labels -- ready to open and edit by hand.
function write_platemap_template(filename)
    pkg load io

    row_labels = {"A", "B", "C", "D", "E", "F", "G", "H"};

    % --- Name sheet (str): leave wells blank for the user to fill in ---
    name_sheet = cell(9, 13);
    name_sheet{1, 1} = "str";
    for c = 1:12
        name_sheet{1, c+1} = c;
    end
    for r = 1:8
        name_sheet{r+1, 1} = row_labels{r};
        for c = 1:12
            name_sheet{r+1, c+1} = ""; % e.g. "Blank", "Standard", "Sample1"
        end
    end

    % --- DilutionFactor sheet (num): default every well to 1 ---
    dilution_sheet = cell(9, 13);
    dilution_sheet{1, 1} = "num";
    for c = 1:12
        dilution_sheet{1, c+1} = c;
    end
    for r = 1:8
        dilution_sheet{r+1, 1} = row_labels{r};
        for c = 1:12
            dilution_sheet{r+1, c+1} = 1;
        end
    end

    % --- FinalVolume sheet (num): default every well to 1 ---
    volume_sheet = cell(9, 13);
    volume_sheet{1, 1} = "num";
    for c = 1:12
        volume_sheet{1, c+1} = c;
    end
    for r = 1:8
        volume_sheet{r+1, 1} = row_labels{r};
        for c = 1:12
            volume_sheet{r+1, c+1} = 1;
        end
    end

    % Keep one file handle open across all three sheet writes -- calling
    % xlswrite(filename, ...) directly per sheet reopens the file each
    % time and will clobber the sheets written before it.
    ods = xlsopen(filename, true);
    ods = xlswrite(ods, name_sheet, "Name", "A1");
    ods = xlswrite(ods, dilution_sheet, "DilutionFactor", "A1");
    ods = xlswrite(ods, volume_sheet, "FinalVolume", "A1");
    xlsclose(ods);
end
