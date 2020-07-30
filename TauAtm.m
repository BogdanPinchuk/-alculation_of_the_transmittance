function [tau] = TauAtm(lamda, range, alpha, h0, Earth, temperature,...
    data, params, include)
% Результуючий коефіцієнт пропускання атмосфери з коефіцієнтом ослаблення
% lamda - довжина хвилі, мкм
% range - довжина шляху/траси, км
% alpha - кут нахилу відносно горизонту, зенітний кут [град]
% h0 - висота цілі
% Earth - параметри Землі
% temperature - температура повітря, K
% data - дані із таблиць для розрахунку пропускання
% params - параметри розрахунку
% include - метод розрахунку
% 0 - розрахунок лише коефіцієнта пропускання
% 1 - розрахунок лише коефіцієнта ослабдення
% 2 - розраховувати добуток коефіцієнта випромінювання і ослаблення

%% Для помилки
str = 'Помилка (типу) вхідних даних.';

if (min(lamda) < 0.3 || max(lamda) > 14)
    error(str);
end

func(alpha);

% Ефективна довжина шляху
d_h2o = EffectivePath(range, alpha, "H2O", h0, Earth.R_k, params);
d_co2 = EffectivePath(range, alpha, "CO2", h0, Earth.R_k, params);
d_sct = EffectivePath(range, alpha, "Scat", h0, Earth.R_k, params);

% Коефіцієнти
if (range == 0)
    % при 0 товщині, пропускання буде дорівнювати 1, але коефіцієнт
    % ослаблення 0 отже сумарно все дорівнюватиме нулю,
    % фізично одночасно в одній точці не може знаходитися і приймач і
    % випромінювач, тому точка получається "виколотою"
    tau = ones(size(lamda, 1), size(lamda, 2));
else
    tau = TauH2O(lamda, d_h2o, temperature, Earth.RH, data.H2O,...
        data.WV, params.method) .*...
        TauCO2(lamda, d_co2, temperature, data.CO2) .*...
        TauScat(lamda, d_sct, Earth.d_v);
end

% при пропусканні 1, випромінювання не попадає на ціль, так як немає
% чому випромінювати (вакуум), тому коефіцієнт ослаблення 0
if (include > 0)
    tau = tau + (tau == 0);
    if (include == 1)
        tau = log(tau);
    elseif (include == 2)
        tau = (1 - tau) .* log(tau);
    elseif (include == 3)
        tau = tau .* log(tau);
    end
end

end

