# Basys3 LED Lighting System

# Technical Description
Verilog implementation of a real-time lighting control system designed for the Basys3 FPGA board.  
This project demonstrates a complete hardware–based illumination controller that adjusts LED brightness according to the current time, integrates PWM dimming, and includes a fully animated LED sequence executed at a specific hour.  

# Architecture
The architecture combines several hardware modules, including a `debounced user-controlled clock`, a `seven-segment multiplexed display`, a parameterized `PWM generator`, and a custom `LED animation unit`. `Control logic` ties these components together to form a deterministic `real-time illumination system`.

# Objectives
The primary objective was to design a reliable and fully synthesizable FPGA lighting system capable of:  
* **Dynamically adjusting LED brightness based on predefined time intervals (18:00, 21:00, 00:00, 06:00).**  
* **Generating stable PWM signals for 16 LEDs with different intensity levels.**  
* **Executing a 16-LED traveling animation pattern at 03:00 using a hardware-driven finite-state sequence.**  
* **Ensuring robust input handling through debounced push-buttons for clock control.**  

# Skills
This project demonstrates proficiency in:  
**→ Real-time digital design and time-dependent control behavior.**   
**→ Finite State Machines and deterministic LED animation logic.**    
**→ Edge-sensitive event handling (button press detection, debouncing).**  
**→ Hardware-level PWM brightness regulation.**  
**→ FPGA-oriented design flow (synthesis, implementation, timing-clean RTL).**  
**→ Multiplexed seven-segment display control.**  
**→ Clean modular Verilog architecture.**  

# Testing
The final hardware implementation was tested and validated directly on the `Basys3 board`, demonstrating correct `LED brightness transitions`, stable `PWM behavior`, accurate `SSD time display`, and a `fully operational 16-LED animation sequence`.

# Key Technologies
`Verilog HDL`, `Basys3 FPGA Board`, `PWM Dimming`, `Digital Clock Logic`, `FSM`, `Real-Time Control Design`, `Hardware Synthesis`.
