Implementation of the IEEE simplified two-diode photovoltaic (PV) module model in MATLAB for I–V curve simulation under varying irradiance and temperature.

# Simplified Two-Diode PV Model (MATLAB)

This repository contains MATLAB implementations of the **novel simplified two-diode photovoltaic (PV) module model** proposed by:

> B. Chitti Babu and Suresh Gurjar, *"A Novel Simplified Two-Diode Model of Photovoltaic (PV) Module"*  
> IEEE Journal of Photovoltaics, Vol. 4, No. 4, July 2014.  

The model eliminates series and shunt resistances, reducing computational complexity while still accurately reproducing **I–V characteristics** of PV modules using only datasheet parameters.

---

## Background

PV modules are typically modeled using either a **single-diode** or **two-diode** approach.  
- Single-diode models are simple but often inaccurate near the maximum power point (MPP).  
- Two-diode models improve accuracy but usually require series resistance (Rs) and shunt resistance (Rsh), making computation heavier.  

The **simplified two-diode model** balances **accuracy and efficiency** by:
- Neglecting Rs and Rsh,  
- Using only four datasheet parameters:  
  - Short-circuit current (Isc)  
  - Open-circuit voltage (Voc)  
  - Current temperature coefficient (KI)  
  - Voltage temperature coefficient (KV)  

The model is validated against commercial PV module datasheets (Kyocera KC200GT, BP MSX-60, Renosola JC260S) with <0.1% error at MPP.

---

## Mathematical Model

The simplified current–voltage equation is:

\[
I = I_{pv} - I_{01}\left(\exp\left(\frac{qV}{N_s k T A_1}\right) - 1\right) - I_{02}\left(\exp\left(\frac{qV}{N_s k T A_2}\right) - 1\right)
\]

Where:  
- \(I_{pv}\) = photocurrent, dependent on irradiance and temperature  
- \(I_{01}, I_{02}\) = diode saturation currents  
- \(A_1, A_2\) = diode ideality factors  
- \(N_s\) = number of cells in series  
- \(q\) = electron charge  
- \(k\) = Boltzmann constant  
- \(T\) = cell temperature  

Supporting equations (from datasheet values):

\[
I_{pv} = (I_{sc} + K_I \Delta T)\cdot \frac{G}{G_{STC}}
\]

\[
I_{01} = \frac{(I_{sc} + K_I \Delta T)}{\exp\left(\frac{(V_{oc} + K_V \Delta T)q}{N_s k T A_1}\right)-1}
\]

\[
I_{02} \approx \left(\frac{T}{298}\right)^{3.77} \cdot I_{01}
\]

---

## Example Outputs

I–V curves vs irradiance
Shows how current increases nearly linearly with irradiance while Voc shifts slightly.

I–V curves vs temperature
Demonstrates reduction in Voc and slight increase in Isc with higher temperatures.

---

## Validation

The simulation results closely match manufacturer datasheets for:

Kyocera KC200GT
BP Solar MSX-60
Renosola JC260S
Error at maximum power point (MPP) was found to be <0.1% compared to datasheet values (as reported in the IEEE paper).

---

## References

B. Chitti Babu and Suresh Gurjar, "A Novel Simplified Two-Diode Model of Photovoltaic (PV) Module", IEEE Journal of Photovoltaics, 2014.

Manufacturer datasheets: Kyocera KC200GT, BP MSX-60, Renosola JC260S.

---

## Notes

The scripts in SimplifiedModel/ are faithful to the IEEE paper.

The FullTwoDiodeModel/ folder contains extended models with Rs and Rsh, not part of the paper, but useful for comparison.

If you wish to automatically compute 𝐴1 and 𝐴2, see estimate_A1A2.m (to be added).

---

## License

This project is released under the MIT License. Feel free to use and modify with attribution.



