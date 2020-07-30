function [tau] = TauCO2(lamda, d_eff, t_air, dataCO2)
% Коефіцієнт пропускання за рахунок ослабленя вуглекислим газом
% lamda - довжина хвилі, мкм
% d_eff - ефективна довжина шляху/траси, км
% t_air - температура повітря, °K
% dataCO2 - дані пропускання вуглекислого газу

%% Для помилки
str = 'Помилка (типу) вхідних даних.';

if (min(lamda(:)) < 0.3 || max(lamda(:)) > 14)
    error(str);
end

% Ефективна довжина шляху в залежності від температури
% 101325/133.3*760 => p_1 / p_0 * d_eff... % + 273.15
d_eff = d_eff .* 273.15 ./ t_air;

dataCO2_1 = dataCO2{1};
dataCO2_2 = dataCO2{2};
dataCO2_3 = dataCO2{3};

% Фільтрувати, якщо виходить за діапазон
% менше min значення
d_eff = ~(d_eff < min(dataCO2_1(:))) .* d_eff +...
    (d_eff < min(dataCO2_1)) .* min(dataCO2_1);

% Пропускання
tau = interp2(dataCO2_1, dataCO2_2, dataCO2_3,...
    d_eff, lamda);

% більше max значення
for i = 1:size(tau(:), 1)
    if (~isfinite(tau(i)))
        tau(i) = 0;
    end
end

end

