# Connect 4 Minimax Engine

A Connect 4 game implementation featuring an AI opponent powered by the Minimax algorithm with Alpha-Beta pruning. The project consists of a Java Swing graphical user interface and a Lisp-based AI engine that communicate through a custom inter-process communication (IPC) layer.

## Overview

This project implements a complete Connect 4 game where players can compete against an AI opponent. The AI uses advanced game tree search algorithms to make optimal decisions, with configurable difficulty levels that adjust the search depth.

## Architecture

The project is split into two main components:

- **Java Frontend** (`src/mains/Juego.java`): A Swing-based GUI that handles user interaction, game state management, and visual representation of the game board
- **Lisp Backend** (`ia.lsp`): The AI engine implementing Minimax with Alpha-Beta pruning, heuristic evaluation, and decision-making logic

### Communication Layer

The Java frontend and Lisp backend communicate through text files:
- `estado.txt`: Contains the current game board state in Lisp-readable format
- `dif.txt`: Contains the selected difficulty level
- `salida.txt`: Contains the AI's move decision (column number)

## Features

- **Minimax Algorithm with Alpha-Beta Pruning**: Efficient game tree search that prunes branches to reduce computation time
- **Heuristic Evaluation**: Evaluates all possible winning patterns (horizontal, vertical, and diagonal) to assess board positions
- **Configurable Difficulty Levels**: Three difficulty levels (Beginner, Intermediate, Professional) that adjust the search depth
- **Real-time Decision Making**: AI responds to player moves in real-time
- **Win Detection**: Checks for wins in all four directions (horizontal, vertical, and both diagonals)
- **Tie Detection**: Recognizes when the board is full and no player has won
- **Game Statistics**: Tracks wins for both players across multiple games

## Requirements

- Java Development Kit (JDK) for compiling and running the Java frontend
- A Lisp interpreter (MULISP) for running the AI engine
- Image files: `vacia.jpg`, `verde.jpg`, `naranja.jpg` (for game piece visualization)

## Building and Running

### Using NetBeans

1. Open the project in NetBeans IDE
2. Build the project (Clean and Build)
3. Run the project from the IDE

### From Command Line

1. Compile the Java source files:
   ```bash
   javac -d build/classes src/mains/Juego.java src/librerias/ImagePanel.java
   ```

2. Create a JAR file (optional):
   ```bash
   jar cvf ConectaCuatro.jar -C build/classes .
   ```

3. Run the game:
   ```bash
   java -cp build/classes mains.Juego
   ```

**Note**: The game requires the Lisp interpreter (MULISP) to be available in the system PATH, as it executes `cmd /c mulisp ia` to run the AI engine.

## Project Structure

```
connect4-minimax-engine/
├── src/
│   ├── mains/
│   │   └── Juego.java          # Main game class with GUI
│   └── librerias/
│       └── ImagePanel.java      # Custom panel for image display
├── ia.lsp                       # Lisp AI engine with Minimax algorithm
├── build.xml                    # NetBeans build configuration
├── naranja.jpg                  # Orange piece image (Player 2)
├── verde.jpg                    # Green piece image (Player 1)
├── vacia.jpg                    # Empty cell image
└── README.md                    # This file
```

## How It Works

1. **Game Initialization**: The player selects a difficulty level, which determines the AI's search depth
2. **Player Move**: The player clicks on a column to drop their piece (green)
3. **State Update**: The Java frontend writes the current board state to `estado.txt`
4. **AI Processing**: The Lisp engine reads the game state, evaluates possible moves using Minimax with Alpha-Beta pruning, and writes its decision to `salida.txt`
5. **AI Move**: The Java frontend reads the AI's decision and places the orange piece
6. **Win Detection**: After each move, the game checks for a winner or tie condition

## AI Algorithm Details

The Lisp backend implements:
- **Minimax Algorithm**: Recursively explores the game tree to find optimal moves
- **Alpha-Beta Pruning**: Cuts off branches that cannot improve the current best move
- **Heuristic Function**: Evaluates board positions by analyzing all possible 4-in-a-row patterns, assigning scores based on:
  - Number of pieces in a pattern
  - Whether patterns are blocked or open
  - Strategic value of different configurations
- **Depth-Limited Search**: Search depth is limited based on difficulty level to balance performance and intelligence

## Authors

Juan Pablo Fonseca, Alejandro Hernandez, Daniel Cabrera