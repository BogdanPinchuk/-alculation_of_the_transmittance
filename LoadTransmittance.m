function [dataH2O, dataCO2] = LoadTransmittance()
% Завантаження даних пропускання атмосфери

% Кількість осадженої води, або довжина траси
x_data = [0, 0.1, 0.2, 0.5, 1, 2, 5, 10, 20, 50, 100, 200, 500, 1000];

%% Завантаження даних H2O
dataExcel = xlsread('H2O.xlsx');

% довжина хвилы
y_data = dataExcel(:, 1);
z_data = dataExcel(:, 2:size(dataExcel, 2));

dataH2O = {x_data, y_data, z_data};

%% Завантаження даних H2O
dataExcel = xlsread('CO2.xlsx');

% довжина хвилы
y_data = dataExcel(:, 1);
z_data = dataExcel(:, 2:size(dataExcel, 2));

dataCO2 = {x_data, y_data, z_data};

end