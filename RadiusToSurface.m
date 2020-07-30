function [radius] = RadiusToSurface(latitude)
% Розрахунок радіуса від центра до поверхні Землі
% radius - радіс поверхні на заданій широті
% latitude - широта [°]

% Радіус на полюсах, км
R_min = 6356.777;
% Радіус на екваторі, км
R_max = 6378.160;
% Середній радіус землі R_z = 6371.032 км

% Переводимо градуси в радіани
latitude = deg2rad(latitude);

radius = sqrt((R_min .* sin(latitude)) .^ 2 +...
    (R_max .* cos(latitude)) .^ 2);

end