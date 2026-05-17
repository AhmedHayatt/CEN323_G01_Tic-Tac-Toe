# 🎮 Tic-Tac-Toe in 8086 Assembly

![Assembly](https://img.shields.io/badge/Language-8086_Assembly-blue.svg)
![Emulator](https://img.shields.io/badge/Emulator-emu8086-lightgrey.svg)

## 📝 Description
A fully functional, human-centric Tic-Tac-Toe game built entirely in 8086 Assembly Language. This project pushes the boundaries of standard DOS text-mode by implementing custom UI rendering, dynamic session scoring, and a strictly modular codebase.

## ✨ Features
* **Custom UI/UX:** Clean, intuitive game grid rendered using Extended ASCII characters with a customized high-contrast color palette (DOS INT 10h). 
* **Dedicated Victory Screen:** Features a custom, centered win screen that displays the winner's name alongside an ASCII Smiley Face (☺).
* **Multi-Round Scoring:** Tracks Player 1 and Player 2 scores across multiple rounds using a dedicated Score Board menu.
* **Advanced Assembly Concepts:** Fully implements Nested Loops (for grid rendering) and Stack-based parameter passing with Local Variables (for score calculations).
* **Modular Architecture:** Clean separation of logic, utilizing a dedicated `macros.inc` library to keep the main execution file clean and manageable.

## 🛠️ Prerequisites
To run this game, you will need:
* **emu8086** (Microprocessor Emulator)
* Windows OS (or Linux/Mac running Wine)

## 🚀 How to Run

1. Clone this repository to your local machine:
   ```bash
   git clone [https://github.com/AhmedHayatt/TIC-TAC-TOE.git](https://github.com/AhmedHayatt/TIC-TAC-TOE.git)
2. Important Setup: Place the macros.inc file directly into your C:\emu8086\inc\ directory.
3. Open PROJECT.asm in the emu8086 emulator.
4. Click Compile, then Emulate.
5. Click Run to start the game!
   
📂 File Structure

1. PROJECT.asm — The main execution file containing the game loop, UI procedures, INT 10h video memory rendering, and state management.
2. macros.inc — A dedicated library of reusable macros for board updating, empty cell validation, and line/win checking.
   
👥 Contribution

Hina Jabeen (01-135232-029) UI/UX Design & Rendering Engine
Hamna Mateen (01-135232-022) Macro Architecture
Ahmed Hayat (01-135232-005) Game Logic & State Management
