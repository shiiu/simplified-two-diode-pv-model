% Parameters
Iph = 5;                      % Photocurrent (A) - Short-circuit current
Is1 = 1e-10;                  % Saturation current of diode 1 (A)
Is2 = 1e-10;                  % Saturation current of diode 2 (A)
n1 = 1.3;                     % Ideality factor of diode 1
n2 = 1.5;                     % Ideality factor of diode 2
q = 1.60217663e-19;           % Charge of electron (C)
k = 1.38064852e-23;           % Boltzmann constant (J/K)
Rs = 0.001;                   % Series resistance (ohms)
Rsh = 1e5;                    % Shunt resistance (ohms)

% Define temperatures for the I-V curves (in Kelvin)
temperatures = [280, 300, 320]; % Temperature array (in K)

% Voltage range for I-V curve
V = linspace(0, 1, 100); % Voltage from 0 to 0.8 V

% Colors for each temperature curve
colors = ['r', 'g', 'b'];

% Initialize the plot
figure;
hold on;

% Loop over each temperature
for t = 1:length(temperatures)
    T = temperatures(t);      % Current temperature
    Vt1 = n1 * k * T / q;     % Thermal voltage for diode 1 at current temperature
    Vt2 = n2 * k * T / q;     % Thermal voltage for diode 2 at current temperature

    % Initialize current array for this temperature
    I = zeros(size(V));

    % Calculate I-V characteristic using the double diode model
    for i = 1:length(V)
        % Define the current equation for double diode model with Rs and Rsh
        fun = @(I) I - Iph + Is1 * (exp((V(i) + I * Rs) / Vt1) - 1) + ...
                   Is2 * (exp((V(i) + I * Rs) / Vt2) - 1) + ...
                   (V(i) + I * Rs) / Rsh;

        % Initial guess for current
        if V(i) == 0
            I(i) = Iph; % For short-circuit condition
        else
            I(i) = fzero(fun, Iph - 0.1); % Adjust initial guess for non-zero V
        end
    end

    % Plot I-V curve for the current temperature
    plot(V, I, 'Color', colors(t), 'LineWidth', 2, 'DisplayName', ['T = ' num2str(T) 'K']);
end

% Customize the plot
xlabel('Voltage (V)');
ylabel('Current (A)');
title('I-V Characteristics of PV Model (Double Diode Model) at Different Temperatures');
legend('show');
xlim([0, 1.5]);
ylim([0, Iph * 1.1]); % Adjusted to see the curve clearly
grid on;
hold off;
disp('I-V Characteristics of PV Model (Double Diode Model) at Different Temperatures');