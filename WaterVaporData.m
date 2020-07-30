function dataWV = WaterVaporData()
% Завантаження даних питомої кількості осадженої води

%% Завантаження даних
dataExcel = xlsread('WaterVapor.xlsx');

% питома кількість осадженої води і температура в °С
w_0 = dataExcel(:, 2) .* 10 .^ dataExcel(:, 3);
t = dataExcel(:, 1);

dataWV = {w_0, t};

end

