# Reproducing Figure 11: Qualitative Analysis of SDO

This repository contains a complete implementation of the Sled Dog-inspired Optimizer (SDO) algorithm with comprehensive tools for reproducing Figure 11 from the research paper, which shows the qualitative analysis of the SDO algorithm.

## Files Overview

### Core Algorithm Files
- **`SDO.m`**: Basic implementation of the Sled Dog-inspired Optimizer algorithm
- **`SDO_enhanced.m`**: Enhanced version with detailed parameter tracking and statistics collection
- **`benchmark_functions.m`**: Collection of 10 benchmark test functions for algorithm evaluation

### Analysis and Visualization Files
- **`qualitative_analysis_SDO.m`**: Main script to reproduce Figure 11 with comprehensive analysis
- **`plot_parameter_evolution.m`**: Function to visualize parameter evolution over iterations
- **`analyze_convergence.m`**: Function for detailed convergence analysis and statistics

### Documentation
- **`README_reproduction.md`**: This file with complete reproduction instructions

## Quick Start

To reproduce Figure 11, simply run the main analysis script in MATLAB:

```matlab
qualitative_analysis_SDO()
```

This will generate:
1. **Figure 11**: Multi-panel qualitative analysis plot
2. **Additional detailed plots**: Parameter evolution and convergence analysis
3. **Statistical summary**: Comprehensive performance metrics

## Detailed Instructions

### 1. System Requirements
- MATLAB R2018b or later
- No additional toolboxes required
- Approximately 5-10 minutes execution time

### 2. Algorithm Parameters
The default parameters used in the analysis:
- Population size: 30
- Maximum iterations: 500
- Problem dimension: 30
- Number of independent runs: 10
- Test functions: Sphere, Rastrigin, Ackley, Rosenbrock

### 3. Output Description

#### Figure 11 Components:
- **(a) Convergence Curves Comparison**: Shows convergence behavior across different benchmark functions with mean curves and standard deviation bands
- **(b) Parameter Evolution Over Iterations**: Displays how key SDO parameters (y, p1, w1, CF) change during optimization
- **(c) Population Diversity Dynamics**: Illustrates population spread and diversity maintenance
- **(d) Statistical Performance Comparison**: Bar chart comparing final performance across test functions

#### Additional Outputs:
- **Parameter Evolution Detailed**: 6-panel plot showing individual parameter trajectories
- **Convergence Analysis Detailed**: 4-panel analysis of convergence characteristics
- **Statistical Report**: Console output with comprehensive performance metrics

### 4. Customization Options

#### Modifying Test Functions:
```matlab
% In qualitative_analysis_SDO.m, modify these lines:
test_functions = [1, 2, 3, 5];  % Change function numbers (1-10)
function_names = {'Sphere', 'Rastrigin', 'Ackley', 'Rosenbrock'};
```

#### Adjusting Algorithm Parameters:
```matlab
% Modify these parameters in qualitative_analysis_SDO.m:
pop_size = 30;        % Population size
max_iter = 500;       % Maximum iterations
dim = 30;             % Problem dimension
num_runs = 10;        % Number of independent runs
```

#### Adding New Test Functions:
Add new cases to `benchmark_functions.m` following the existing pattern.

### 5. Understanding the SDO Algorithm

The SDO algorithm is inspired by sled dog behavior and includes:

#### Key Parameters:
- **y**: Control parameter for position adjustment (starts at 2, decreases over time)
- **c1, c2**: Cognitive and social parameters (fixed at 2)
- **w1**: Inertia weight (starts at 0.9, decreases over time)
- **p1**: Probability parameter for exploration/exploitation balance (dynamic)
- **CF**: Control factor (linearly decreases from 2 to 0)

#### Algorithm Phases:
1. **Exploration Phase** (when rand < p1): Dogs follow the leader with social learning
2. **Exploitation Phase** (when rand >= p1): Local search around current positions

#### Position Update Equations:
- Exploration: `new_position = current + c1*rand*(leader - current) + c2*rand*(neighbor - current)`
- Exploitation: `new_position = w1*current + CF*rand*(neighbor1 - neighbor2)`
- Adjustment: `new_position += y*sin(2π*rand)*(leader - current)`

### 6. Interpreting Results

#### Convergence Analysis:
- **Fast initial convergence**: Indicates good exploration capability
- **Steady improvement**: Shows balanced exploration-exploitation
- **Final convergence**: Demonstrates exploitation effectiveness

#### Parameter Evolution:
- **y decreases**: Reduces position adjustment magnitude over time
- **w1 decreases**: Reduces inertia for better exploitation
- **p1 oscillates**: Dynamic balance between exploration and exploitation
- **CF decreases**: Gradually shifts from exploration to exploitation

#### Population Dynamics:
- **High initial diversity**: Good exploration coverage
- **Gradual diversity reduction**: Natural convergence toward optimal regions
- **Maintained minimum diversity**: Prevents premature convergence

### 7. Troubleshooting

#### Common Issues:
1. **MATLAB path**: Ensure all .m files are in the current directory or MATLAB path
2. **Memory issues**: Reduce `num_runs` or `max_iter` for large-scale problems
3. **Slow execution**: Reduce problem dimension or number of test functions

#### Performance Tuning:
- Increase `num_runs` for more robust statistics (recommended: 30-50)
- Adjust `max_iter` based on problem complexity
- Modify population size based on problem dimension (typical: 10-50)

### 8. Expected Results

The analysis should demonstrate:
- **Superior performance** on unimodal functions (Sphere)
- **Competitive performance** on multimodal functions (Rastrigin, Ackley)
- **Robust convergence** across different problem types
- **Effective parameter adaptation** throughout optimization
- **Good balance** between exploration and exploitation

### 9. Extensions

This implementation can be extended for:
- **Real-world engineering problems**: Modify fitness function in benchmark_functions.m
- **Constraint handling**: Add constraint checking to SDO algorithms
- **Multi-objective optimization**: Extend to Pareto-front analysis
- **Hybrid algorithms**: Combine SDO with local search methods

## Citation

If you use this implementation in your research, please cite the original SDO paper and acknowledge this implementation.

## Contact

For questions or issues regarding this implementation, please refer to the repository issues or documentation.