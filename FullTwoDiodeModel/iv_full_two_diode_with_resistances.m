% Parameters
Iph = 5;              % Photocurrent (A) - Short-circuit current
Is1 = 1e-10;          % Saturation current of diode 1 (A)
Is2 = 1e-10;          % Saturation current of diode 2 (A)
n1 = 1.3;             % Ideality factor of diode 1
n2 = 1.5;             % Ideality factor of diode 2
q = 1.60217663e-19;   % Charge of electron (C)
k = 1.38064852e-23;   % Boltzmann constant (J/K)
T = 300;              % Temperature (K)
Rs = 0.001;           % Series resistance (ohms)
Rsh = 1e5;            % Shunt resistance (ohms)

% Thermal voltages for each diode
Vt1 = n1 * k * T / q;
Vt2 = n2 * k * T / q;

% Voltage range for I-V curve
V = linspace(0, 1.5 , 100); % Voltage from 0 to 0.8 V

% Initialize current array
I = zeros(size(V));

% Calculate I-V characteristic using the double diode model
for i = 1:length(V)
    % Define the current equation for double diode model with Rs and Rsh
    fun = @(I) I - Iph + Is1 * (exp((V(i) + I * Rs) / Vt1) - 1) + ...
               Is2 * (exp((V(i) + I * Rs) / Vt2) - 1) + ...
               (V(i) + I * Rs) / Rsh; % Fixed parentheses here
    
    % Initial guess for current
    if V(i) == 0
        I(i) = Iph; % For short-circuit condition
    else
        I(i) = fzero(fun, Iph - 0.1); % Adjust initial guess for non-zero V
    end
end

% Plot
figure;
plot(V, I, 'r', 'LineWidth', 2);
xlabel('Voltage (V)');
ylabel('Current (A)');
title('I-V Characteristic of PV Model (Double Diode Model)');
xlim([0, 1]);
ylim([0, Iph * 1.1]); % Adjusted to see the curve clearly
grid on;
disp('I-V Characteristic of PV Model (Double Diode Model)');