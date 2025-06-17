# 📡 Satellite Orbit Simulator

**Author:** David Cerezo Trashorras  
**Course:** MAE – MATLAB and its Applications in Engineering  

---

## 📑 Project Overview

This project is an interactive MATLAB-based simulator designed to visualize and analyze satellite constellations (LEO, GEO, etc.), their ground coverage, and communication link budgets. All of this is done with their respective TLE segments used to simulate the orbits Users can:

- Simulate real-world constellations (GPS, GALILEO, GLONASS, Starlink, etc.)
- Load custom satellites using Two-Line Element (TLE) data
- Place custom ground stations anywhere on Earth
- Visualize orbits, ground tracks, and antenna coverage cones in 3D
- Evaluate link budgets and SNR margins dynamically over time
- Use an intuitive GUI with no coding required

This tool demonstrates the integration of orbital mechanics, satellite communications theory, and MATLAB’s Aerospace Toolbox in an educational and engineering context.

---

## 📂 Project Structure
SatelliteOrbitSimulator:

- tle_files/ # Folder with predefined TLE files
- SatelliteApp.mlapp # Main GUI App (App Designer)
- orbitPropagator.m # Core orbit propagation and visualization script
- computeLinkBudget.m # Static link budget calculator
- computeSNRTimeSeries.m # Dynamic SNR time series calculator
- Satellite Orbit Simulator - Final project - David Cerezo.pdf # Full project report

## 🚀 Installation

1. **Requirements:**  
   - MATLAB R2024b or newer  
   - Aerospace Toolbox  
   - App Designer
  
2. **IMPORTANT**
   - The TLE files folder is used for the preset constellations, it has to be in the same folder as the app.
  
## Running
Call the SatelliteApp.mlapp on your command terminal in matlab and you are ready to go.

## Future additions
In the future I will add the different types of antennas as well as their radiation lobe view in 3D. Athmospheric scintillation and Rain/cloud attenuations.
