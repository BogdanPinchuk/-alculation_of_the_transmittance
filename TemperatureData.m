function dataHT = TemperatureData(height, lat, lon, time, tzone, N_point)
% Завантаження даних розподілу температури залежно від висоти і моделі атмосфери
% <https://docs.exponenta.ru/aerotbx/ug/atmosnrlmsise00.html>
% height - межа висоти атмосфери, [км]
% lat - (latitude) широта [°]
% lon - (longitude) довгота [°]
% time - дата
% tzone - часовий пояс
% Npoint - кількість точок для графіка

%% Завантаження даних

% Конвертація висоти із [км] в [м]
height = height .* 1000;

% Дата в UTC форматі
time = datetime(time, 'InputFormat', 'dd-MM-yyyy HH:mm:ss',...
    'TimeZone', tzone, 'Format','dd-MM-yyyy HH:mm:ss Z');

% День року
doy = day(time, 'dayofyear');

% Рік
y = year(time);

% Дата в UT форматі
time = datetime(time, 'TimeZone','UT',...
    'Format','dd-MM-yyyy HH:mm:ss Z');

% Тривалість
secs = seconds(duration(string(datetime(time, 'Format','HH:mm:ss')),...
    'Format','s'));

% Висоти
H = linspace(0, height, N_point)';

% Температури
[T, ~] = atmosnrlmsise00(H, lat, lon, y, doy, secs);

dataHT = {H ./ 1000, T(:, 2)};

end

