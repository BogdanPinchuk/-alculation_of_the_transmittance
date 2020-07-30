function [radius] = RadiusCurvature(latitude)
% Розрахунок радіуса кривизни Землі на заданій широті,
% radius - радіс поверхні на заданій широті
% latitude - широта [°]

% Радіус на полюсах, км
R_min = 6356.777;
% Радіус на екваторі, км
R_max = 6378.160;
% Середній радіус землі R_z = 6371.032 км

% Переводимо градуси в радіани
latitude = deg2rad(latitude);

radius = ((R_min .* cos(latitude)) .^ 2 +...
    (R_max .* sin(latitude)) .^ 2) .^ 1.5 ./ (R_min .* R_max);

end