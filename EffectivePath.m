function path = EffectivePath(length, angle, absorb, h_0, R_k, params)
% Розрахунок ефектиної довжини шляху
% length - довжина шляху між цілю і ГСН або заданою точкою в просторі, км
% angle - нахил відносно горизонту [°]
% absorb - absorption, ослаблення, для якої складової розраховується ефектина
% довжина шляху, 'H2O', 0 - парів води, 'CO2', 1 - вуглекислого газу,
% 2 - 'Scat'
% h_0 - висота розташування цілі/об'єкта, км
% type - тип розрахунку,
% 0 - використання апроксимованої формули, яка дійстна для горизонтального
% типу атмосфери + швидший розрахунок
% 1 - розрахунок з врахування сферичності атмосфери
% R_k - радіус кривизни Землі у відповідій точці, км

%% Для помилки
str = 'Помилка (типу) вхідних даних.';

if isstring(absorb)
    if (upper(absorb) == "H2O")
        absorb = 0;
    elseif (upper(absorb) == "CO2")
        absorb = 1;
    elseif (upper(absorb) == "SCAT")
        absorb = 2;
    else
        error(str);
    end
elseif ~isnumeric(absorb)
    error(str);
end

% if (~isnumeric(params.type) || ...
%         (params.type ~= 0 && params.type ~= 1))
%     error(str);
% end

%% сталі для води і вуглекислого газу, які враховують розрідження атмосфери
k_h2o = 0.5154;
k_co2 = 0.3130;
k_sct = 0.1230;

if (absorb == 0)
    absorb = k_h2o;
elseif (absorb == 1)
    absorb = k_co2;
else
    absorb = k_sct;
end

% Переводимо градуси в радіани
angle = deg2rad(angle);

%% розрахунок ефективної довжини траси відповідним профілем
if (params.type == 0)
    % горизонтальний профіль атмосфери
    %dh = length .* sin(angle);
    dh = RealHeight(length, rad2deg(angle), h_0, R_k) - h_0;
    
    % dh == 0
    path1 = (dh == 0) .* length .* exp(-absorb .* h_0);
    % dh ~= 0
    path2 = (dh ~= 0) .* length .* exp(-absorb .* h_0) .*...
            (1 - exp(-absorb .* dh)) ./ (absorb .* dh);
        
    for i = 1:size(path2(:), 1)
        if (isnan(path2(i)))
            path2(i) = 0;
        end
    end
    % Разом
    path = path1 + path2;
%{   
%     if (dh == 0)
%         % коли траса горизонтальна
%         path = length * exp(-absorb * h_0);
%     elseif (abs(dh) >= abs(length))
%         % коли траса вертикальна
%         path = sign(dh) * exp(-absorb * h_0) *...
%             (1 - exp(-absorb * dh)) / absorb;
%     else
%         % коли траса похила
%         path = length * exp(-absorb * h_0) *...
%             (1 - exp(-absorb * dh)) / (absorb * dh);
%     end
%}
elseif (params.type == 1) 
    % сферичний профіль атмосфери
%     angle = ones(size(length(:), 1), 1) .* angle;
%     
%     path = zeros(size(length(:), 1), 1);
    
%{
%     for i = 1:size(length(:), 1)
%         fun = @(t) exp(-absorb .* RealHeight(length(i) .* t,...
%             rad2deg(angle(i)), h_0, R_k));
%         
%         path(i) = length(i) * integral(fun, 0, 1);
%     end
%}
    
    path = length .* integral(@(t) exp(-absorb .*...
        RealHeight(length .* t, rad2deg(angle), h_0, R_k)),...
        0, 1, 'ArrayValued', true, 'RelTol', 0, 'AbsTol', params.tol);
end

end

