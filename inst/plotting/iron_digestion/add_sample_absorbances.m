%{
argument samples is a complicated array structure, don't have time to document but it looks like this:
samples(1).name = "Quarters";
samples(1).absorbances = A(1:4, 3)';
samples(1).index = 1;
samples(1).dilutions.number = 2;
samples(1).dilutions.sample_volumes(1) = 3.64;
samples(1).dilutions.sample_volumes(2) = 0.216;
samples(1).dilutions.total_volumes(1) = 242.8;
samples(1).dilutions.total_volumes(2) = 1.242;

samples(2).name = "Quarters";
samples(2).absorbances = A(1:4, 4)';
samples(2).index = 2;
samples(2).dilutions.number = 3;
samples(2).dilutions.sample_volumes(1) = 3.64;
samples(2).dilutions.sample_volumes(2) = 0.216;
samples(2).dilutions.sample_volumes(3) = 0.414;
samples(2).dilutions.total_volumes(1) = 242.8;
samples(2).dilutions.total_volumes(2) = 1.242;
samples(2).dilutions.total_volumes(3) = 0.828;

samples(3).name = "Nickels";
samples(3).absorbances = A(1:4, 5)';
samples(3).index = 1;
samples(3).dilutions.number = 2;
samples(3).dilutions.sample_volumes(1) = 0.720;
samples(3).dilutions.sample_volumes(2) = 0.216;
samples(3).dilutions.total_volumes(1) = 48.6;
samples(3).dilutions.total_volumes(2) = 1.242;

samples(4).name = "Nickels";
samples(4).absorbances = A(1:4, 6)';
samples(4).index = 2;
samples(4).dilutions.number = 3;
samples(4).dilutions.sample_volumes(1) = 0.72; 
samples(4).dilutions.sample_volumes(2) = 0.216;
samples(4).dilutions.sample_volumes(3) = 0.414;
samples(4).dilutions.total_volumes(1) = 48.6;  
samples(4).dilutions.total_volumes(2) = 1.242; 
samples(4).dilutions.total_volumes(3) = 0.828; 

samples(5).name = "Pennies";
samples(5).absorbances = A(1:4, 7)';
samples(5).index = 1;
samples(5).dilutions.number = 2;
samples(5).dilutions.sample_volumes(1) = 0.720;
samples(5).dilutions.sample_volumes(2) = 0.216;
samples(5).dilutions.total_volumes(1) = 9.72;
samples(5).dilutions.total_volumes(2) = 1.242;

samples(6).name = "Pennies";
samples(6).absorbances = A(1:4, 8)';
samples(6).index = 2;
samples(6).dilutions.number = 3;
samples(6).dilutions.sample_volumes(1) = 0.72; 
samples(6).dilutions.sample_volumes(2) = 0.216;
samples(6).dilutions.sample_volumes(3) = 0.414;
samples(6).dilutions.total_volumes(1) = 9.72;  
samples(6).dilutions.total_volumes(2) = 1.242; 
samples(6).dilutions.total_volumes(3) = 0.828; 
%}

function add_sample_absorbances(samples)
  plot_1_samples = [];
  plot_2_samples = [];
  for i = 1:length(samples)
    subplot(1, 2, samples(i).index)
    plot(xlim, repmat(mean(samples(i).absorbances), 1, 2), "DisplayName", [samples(i).name " mean"])

    if samples(i).index == 1 
      plot_1_samples = [plot_1_samples samples(i)];
    else
      plot_2_samples = [plot_2_samples samples(i)];
    end
  end

  subplot(1, 2, 1)
  [start_x_loc_1, ~] = get_position_on_ax_by_percent(xlim, ylim, 10, 90);
  [end_x_loc_1, ~] = get_position_on_ax_by_percent(xlim, ylim, 90, 90);
  scatter_x_loc_1 = linspace(start_x_loc_1, end_x_loc_1, length(plot_1_samples));

  subplot(1, 2, 1)
  [start_x_loc_2, ~] = get_position_on_ax_by_percent(xlim, ylim, 10, 90);
  [end_x_loc_2, ~] = get_position_on_ax_by_percent(xlim, ylim, 90, 90);
  scatter_x_loc_2 = linspace(start_x_loc_2, end_x_loc_2, length(plot_1_samples));

  subplot(1, 2, 1)
  for i = 1:length(plot_1_samples)
    scatter(
      repmat(scatter_x_loc_1(i), 1, length(plot_1_samples(i).absorbances)),
      plot_1_samples(i).absorbances,
      "Displayname", plot_1_samples(i).name
    )
  end

  subplot(1, 2, 2)
  for i = 1:length(plot_2_samples)
    scatter(
      repmat(scatter_x_loc_2(i), 1, length(plot_2_samples(i).absorbances)),
      plot_2_samples(i).absorbances,
      "DisplayName", plot_2_samples(i).name
    )
  end
end
