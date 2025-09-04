% Constants
k = 1.380649e-23;             % Boltzmann constant (J/K)
q = 1.602176634e-19;          % Electron charge (C)
G_STC = 1000;                 % Standard test condition irradiance (W/m^2)
T_STC = 25 + 273.15;          % Standard test temperature (K)

% PV Module Specifications
Isc = 3.8;                    % Short-circuit current (A) at STC
Voc = 21.1;                   % Open-circuit voltage (V) at STC
Ipv = 3.8;                    % Photocurrent (A) at STC
Ns = 60;                      % Number of cells in series

% Diode Model Parameters
A1 = 1.6;                     % Ideality factor for diode 1
A2 = 2.2;                     % Ideality factor for diode 2
KI = 0.0032;                  % Current temperature coefficient (A/°C)
KV = -0.123;                  % Voltage temperature coefficient (V/°C)

% Given Saturation Currents
I01 = 2.46e-6;                % Saturation current for diode 1 (A)
I02 = 6.392e-6;               % Saturation current for diode 2 (A)

% Temperature Condition
T_Celsius = 25;               % Operating temperature in Celsius
T = T_Celsius + 273.15;       % Operating temperature in Kelvin
DeltaT = T - T_STC;           % Temperature difference from STC

% Irradiance Levels
irradiance_levels = [1000, 800, 600, 400, 200]; % Irradiance levels in W/m^2
colors = ['r', 'g', 'b', 'c', 'm'];             % Colors for each irradiance plot

% Voltage Sweep
Vpv = linspace(0, Voc, 100);  % Voltage range from 0 to open-circuit voltage

% Plot the I-V Curves for Different Irradiance Levels
figure;
hold on;

for i = 1:length(irradiance_levels)
    % Set irradiance level
    G = irradiance_levels(i);

    % Adjusted Photocurrent based on KI and irradiance G
    Ipv_adj = (Isc + KI * DeltaT) * (G / G_STC);

    % Adjusted Saturation Current I01 based on KV and temperature change
    I01_adj = (Isc + KI * DeltaT) / (exp((Voc + KV * DeltaT) * q / (Ns * k * T * A1)) - 1);

    % Thermal voltage for the PV module
    Vt = (Ns * k * T) / q;  

    % Initialize current array for the specific irradiance
    Ipv_curve = zeros(size(Vpv));

    % Calculate I-V Curve
    for j = 1:length(Vpv)
        V = Vpv(j);
        
        % Calculate current I based on the two-diode model
        I = Ipv_adj - I01_adj * (exp(V / (A1 * Vt)) - 1) - I02 * (exp(V / (A2 * Vt)) - 1);
        
        % Ensure current does not drop below zero
        if I < 0
            I = 0;
        end
        
        % Store computed current value
        Ipv_curve(j) = I;
    end

    % Plot the I-V curve for the current irradiance level
    plot(Vpv, Ipv_curve, 'Color', colors(i), 'LineWidth', 1.5, 'DisplayName', ['G = ' num2str(G) ' W/m²']);
end

% Finalize the plot
title('Two-Diode Model I-V curve for Different Irradiance Levels for MSX-60');
xlabel('Voltage (V)');
ylabel('Current (A)');
xlim([0 Voc]);
ylim([0 Isc + 0.5]);
grid on;
legend('show');
hold off;

% Display completion
disp('I-V characteristics computed for the two-diode model at different irradiance levels.');
