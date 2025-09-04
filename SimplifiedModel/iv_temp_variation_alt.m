% Constants
k = 1.380649e-23;             % Boltzmann constant (J/K)
q = 1.602176634e-19;          % Electron charge (C)
G_STC = 1000;                 % Standard test condition irradiance (W/m^2)
T_STC = 25 + 273.15;          % Standard test temperature (K)

% PV Module Specifications
Isc = 9.1;                    % Short-circuit current (A) at STC
Voc = 37.7;                   % Open-circuit voltage (V) at STC
Ns = 60;                      % Number of cells in series

% Diode Model Parameters
A1 = 1.7;                     % Ideality factor for diode 1
A2 = 2.8;                     % Ideality factor for diode 2
KI = 0.0003;                  % Current temperature coefficient (A/°C)
KV = -0.31;                   % Voltage temperature coefficient (V/°C)

% Given Saturation Currents
I01 = 1.15e-5;                % Saturation current for diode 1 (A)
I02 = 2.994e-5;               % Saturation current for diode 2 (A)

% Temperature Levels (Celsius)
temperature_levels = [25, 50, 75];

% Irradiance
G = 1000; % Irradiance in W/m^2

% Initialize figure
figure;
hold on;

% Loop over each temperature level to plot I-V curves
for T_Celsius = temperature_levels
    % Convert temperature to Kelvin and calculate DeltaT
    T = T_Celsius + 273.15;       % Operating temperature in Kelvin
    DeltaT = T - T_STC;           % Temperature difference from STC

    % Calculate adjusted open-circuit voltage Voc for the current temperature
    Voc_T = Voc + KV * DeltaT;

    % Calculate adjusted Photocurrent Ipv
    Ipv = (Isc + KI * DeltaT) * (G / G_STC);

    % Adjust Saturation Current I01 based on KV and temperature change
    I01_adj = (Isc + KI * DeltaT) / (exp((Voc_T) * q / (Ns * k * T * A1)) - 1);

    % Thermal voltage for the PV module
    Vt = (Ns * k * T) / q;

    % Voltage Sweep up to adjusted Voc for the current temperature
    Vpv = linspace(0, Voc_T, 100); % Voltage range from 0 to temperature-adjusted open-circuit voltage
    Ipv_curve = zeros(size(Vpv));  % Initialize current array

    % Calculate I-V Curve
    for j = 1:length(Vpv)
        V = Vpv(j);
        
        % Calculate current I based on the two-diode model
        I = Ipv - I01_adj * (exp(V / (A1 * Vt)) - 1) - I02 * (exp(V / (A2 * Vt)) - 1);
        
        % Ensure current does not drop below zero
        if I < 0
            I = 0;
        end
        
        % Store computed current value
        Ipv_curve(j) = I;
    end
    
    % Plot the I-V Curve for each temperature level
    plot(Vpv, Ipv_curve, 'DisplayName', ['T = ', num2str(T_Celsius), '°C'], 'LineWidth', 1.5);
end

% Add plot details
title('I-V Curves of Renesola JC260S PV module for Different Temperatures (G = 1000 W/m^2)');
xlabel('Voltage (V)');
ylabel('Current (A)');
xlim([0 Voc]);
ylim([0 Isc + 1]);
legend show;
grid on;
hold off;

% Display completion message
disp('I-V characteristics computed for the two-diode model across different temperatures.');
