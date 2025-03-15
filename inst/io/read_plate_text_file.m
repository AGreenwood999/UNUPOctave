function data = read_plate_text_file(file) 
% Reads data from text file
    raw_file = dlmread(file, '\t');
    data = raw_file(4:11,3:14);
end
