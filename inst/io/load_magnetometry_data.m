function data = load_magnetometry_data(filename, mass_g)
    [data._num, data._txt, data._raw] = xlsread(filename);

    % TODO: This should error if it's not found
    idx = cellfun(@(x) strcmp(x, "G cm^3"), data._txt);
    [i,j] = find(idx);

    % WARN: It is yet to be seen how fragile this is 
    data.G = [data._raw{i+1:end, 1}];
    data.emu = [data._raw{i+1:end, j}];
    data.emu_g = data.emu / mass_g;
end
