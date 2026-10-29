# Genetic Algorithm for Robot Path Planning

## Overview

This MATLAB project uses a genetic algorithm (GA) to find a path between a starting point and a destination while considering path length and collisions with obstacles.

The project allows different selection, crossover, and mutation algorithms to be tested and compared.

## Features

- **Selection:** Roulette Wheel, Rank-Based, and Tournament Selection
- **Crossover:** Uniform and K-Point Crossover
- **Mutation:** Gaussian Noise and Uniform Noise Mutation
- Fitness evaluation based on path length and obstacle collisions
- Elitism and configurable algorithm parameters
- Visualisation of the resulting path
- Modular structure for organising algorithm implementations

## Requirements

- MATLAB
- Image Processing Toolbox, if required by the MATLAB functions used, including `imbinarize`
- The map image `random_map.bmp`

## Project Structure

The project is intended to follow a structure similar to this:

```text
.
├── main.m
├── GetFitnessVector.m
├── random_map.bmp
├── SelectionAlgorithms/
│   ├── RouletteWheelSelection.m
│   ├── RankBasedSelection.m
│   └── TournamentSelection.m
├── CrossoverAlgorithms/
│   ├── UniformCrossover.m
│   └── KPointCrossover.m
└── MutationAlgorithms/
    ├── GaussianNoiseMutation.m
    └── UniformNoiseMutation.m
```

Make sure the filenames and folder names match your actual project.

## How to Run

1. Open the project in MATLAB.
2. Set MATLAB's current folder to the project directory.
3. Ensure `random_map.bmp` and all required MATLAB files are present.
4. Run `main.m`.
5. Follow the prompts to select the algorithms and run the genetic algorithm.

## Main Parameters

| Parameter | Purpose |
|---|---|
| `noOfPointsInSolution` | Number of points used to represent a candidate path |
| `iter` | Number of iterations or generations |
| `populationSize` | Number of candidate solutions |
| `collisionPenalty` | Penalty for collisions with obstacles |
| `eliteSize` | Number of top solutions retained |
| `mutationRate` | Controls mutation probability or intensity |
| `crossoverRate` | Controls how often crossover occurs |
| `mutationFreq` | Controls mutation frequency |

The exact behaviour of each parameter depends on its implementation in the code.

## Results

The algorithm evaluates candidate paths and displays a resulting solution. Results may vary because the genetic algorithm uses random initialisation and stochastic operators. The chosen algorithms and parameter values can also affect performance.

## Limitations

- Results depend on the random initial population and parameter settings.
- A fixed population size and iteration count may limit performance on some maps.
- The current waypoint-generation implementation may assume a square map.

