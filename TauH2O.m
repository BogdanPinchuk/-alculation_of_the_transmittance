function [tau] = TauH2O(lamda, d_eff, t_air, RH,...
    dataH2O, dataWV, method)
% Коефіцієнт пропускання за рахунок ослабленя парами води
% lamda - довжина хвилі, мкм
% d_eff - ефективна довжина шляху/траси, км
% t_air - температура повітря, °K
% RH - relative humidity, відносна вологість %
% dataH2O - дані пропускання парів води
% dataWV - дані питомої кількості води
% method - метод розрахунку
% 0 - розрахунок за апроксимованою формулою, + більший діапазон значень
% 1 - розрахунок за табличними даними, - t = [-50,+50]°С

%% Для помилки
str = 'Помилка (типу) вхідних даних.';

if (min(lamda(:)) < 0.3 || max(lamda(:)) > 14)
    error(str);
end

dataWV_1 = dataWV{1};
dataWV_2 = dataWV{2};
dataH2O_1 = dataH2O{1};
dataH2O_2 = dataH2O{2};
dataH2O_3 = dataH2O{3};

% Питома кількість осадженої води
w_0 = NumberOfWP(t_air - 273.15, method, dataWV_2, dataWV_1);

% Ефективна кількість осадженої води
w_eff = w_0 .* d_eff .* RH ./ 100;

% Фільтрувати, якщо виходить за діапазон
% менше min значення
w_min = min(dataH2O_1);
w_max = max(dataH2O_1);

w_eff = (w_eff < w_min) .* w_min +...
    (w_eff > w_max) .* w_max +...
    ((w_min <= w_eff) & (w_eff <= w_max)) .* w_eff;

% Пропускання
tau = interp2(dataH2O_1, dataH2O_2, dataH2O_3,...
    w_eff, lamda);

% більше max значення
% for i = 1:size(tau(:), 1)
%     if (~isfinite(tau(i)))
%         tau(i) = 0;
%     end
% end

end

