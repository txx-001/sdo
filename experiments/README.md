# SDO Experimental Framework

This repository contains a comprehensive experimental framework for reproducing the results from the SDO (Sled Dog Optimizer) paper: "A novel sled dog-inspired optimizer for solving engineering problems".

## Overview

The framework implements the complete experimental setup described in Section 4 of the paper, including:

- **SDO algorithm** implementation based on the paper
- **Comparison algorithms**: PSO, GWO, WOA, SCA, SSA, HHO, TSA
- **CEC2017 benchmark functions** (F1-F30)
- **Multiple dimensions**: 30D, 50D, 100D testing
- **Statistical analysis** with mean, std, best, worst values
- **Convergence curve plotting** (similar to Fig. 11 in the paper)
- **Wilcoxon rank-sum test** for statistical significance
- **Publication-quality result generation**

## Directory Structure

```
experiments/
├── algorithms/
│   ├── SDO.m          # Sled Dog Optimizer (main algorithm)
│   ├── PSO.m          # Particle Swarm Optimization
│   ├── GWO.m          # Grey Wolf Optimizer
│   ├── WOA.m          # Whale Optimization Algorithm
│   ├── SCA.m          # Sine Cosine Algorithm
│   ├── SSA.m          # Salp Swarm Algorithm
│   ├── HHO.m          # Harris Hawks Optimization
│   └── TSA.m          # Tunicate Swarm Algorithm
├── utils/
│   ├── cec17_func.m           # CEC2017 benchmark functions
│   ├── statistical_analysis.m # Statistical analysis utilities
│   ├── plot_convergence.m     # Convergence plotting
│   ├── wilcoxon_test.m        # Wilcoxon rank-sum test
│   └── simple_ranksum.m       # Octave-compatible ranksum
├── results/           # Generated experimental results
└── run_experiments.m  # Main experimental runner
```

## Quick Start

### Prerequisites

- MATLAB R2016b or later, or GNU Octave 4.0+
- No additional toolboxes required (framework includes compatible implementations)

### Running the Demo

1. **Quick test** (2 algorithms, 2 functions, small parameters):
   ```matlab
   test_framework
   ```

2. **Comprehensive demo** (all algorithms, F1-F5, moderate parameters):
   ```matlab
   demo_experiments
   ```

3. **Full experiments** (reproduce paper results):
   ```matlab
   run_experiments
   ```

### Example Usage

```matlab
% Add paths
addpath('experiments/algorithms');
addpath('experiments/utils');

% Define parameters
pop_size = 50;
max_iter = 300;
dim = 30;
lb = -100;
ub = 100;

% Test SDO on CEC2017 F1
fobj = @(x) cec17_func(x, 1);
[best_pos, best_score, convergence] = SDO(pop_size, max_iter, lb, ub, dim, fobj);

fprintf('Best solution: %.6e\n', best_score);
```

## Experimental Configuration

### Paper Settings
- **Population size**: 50
- **Maximum iterations**: 300
- **Search space**: [-100, 100]
- **Independent runs**: 30
- **Dimensions**: 30D, 50D, 100D
- **Functions**: CEC2017 F1-F30

### Demo Settings (for quick testing)
- **Population size**: 30
- **Maximum iterations**: 100
- **Independent runs**: 5
- **Dimensions**: 30D
- **Functions**: F1-F5

## Features

### 1. Algorithm Implementations
All algorithms are implemented with consistent interfaces:
```matlab
[best_pos, best_score, convergence] = algorithm(pop_size, max_iter, lb, ub, dim, fobj)
```

### 2. Statistical Analysis
- Mean, standard deviation, best, worst values
- Algorithm ranking based on mean performance
- Comprehensive comparison tables

### 3. Convergence Analysis
- Individual convergence plots for each function
- Multi-function comparison plots
- Publication-quality figures (PNG, FIG formats)

### 4. Statistical Significance Testing
- Wilcoxon rank-sum test implementation
- Pairwise algorithm comparisons
- Win/Tie/Loss summary statistics

### 5. Result Management
- Automatic result saving (MAT, CSV, TXT formats)
- Detailed experimental reports
- Cross-dimensional analysis

## Output Files

The framework generates several types of output files:

### Plots
- `convergence_curves.png` - Multi-function convergence comparison
- `convergence_F*.png` - Individual function convergence curves
- `summary_convergence.png` - Cross-dimensional summary

### Data Files
- `results_*D.mat` - Complete experimental data
- `mean_results_*D.csv` - Mean performance results
- `comprehensive_results_*D.mat` - Detailed analysis data

### Reports
- `detailed_report_*D.txt` - Human-readable experimental summary
- `summary_stats_*D.csv` - Statistical summary in CSV format

## Reproducing Paper Results

To reproduce the exact results from Section 4 of the SDO paper:

1. **Modify parameters** in `run_experiments.m`:
   ```matlab
   pop_size = 50;
   max_iter = 300;
   num_runs = 30;
   dimensions = [30, 50, 100];
   test_functions = 1:30;  % Full CEC2017 suite
   ```

2. **Run experiments**:
   ```matlab
   run_experiments
   ```

3. **Results will be generated** in `experiments/results/` directory

## Algorithm Details

### SDO (Sled Dog Optimizer)
Implementation based on the paper's algorithm description:
- Leadership behavior
- Social behavior  
- Velocity updates
- Boundary handling

### Comparison Algorithms
Standard implementations of well-known metaheuristics:
- **PSO**: Particle Swarm Optimization with inertia weight
- **GWO**: Grey Wolf Optimizer with alpha, beta, delta hierarchy
- **WOA**: Whale Optimization Algorithm with spiral and encircling
- **SCA**: Sine Cosine Algorithm with trigonometric updates
- **SSA**: Salp Swarm Algorithm with leader-follower structure
- **HHO**: Harris Hawks Optimization with exploration/exploitation
- **TSA**: Tunicate Swarm Algorithm with jet propulsion model

## Compatibility

### MATLAB
- Tested on MATLAB R2016b and later
- Uses standard MATLAB functions
- Compatible with Optimization Toolbox (optional)

### GNU Octave
- Compatible with Octave 4.0+
- Includes custom implementations for missing functions
- No additional packages required

## Performance Notes

### Computational Complexity
- **Single run**: O(pop_size × max_iter × dim)
- **Full experiments**: ~2-4 hours on modern CPU (30 runs × 30 functions × 8 algorithms)
- **Demo experiments**: ~10-15 minutes

### Memory Requirements
- **Minimal**: ~100MB for demo experiments
- **Full scale**: ~1-2GB for complete paper reproduction

## Customization

### Adding New Algorithms
1. Create new file in `experiments/algorithms/`
2. Follow the standard interface:
   ```matlab
   function [best_pos, best_score, convergence] = NEW_ALGORITHM(pop_size, max_iter, lb, ub, dim, fobj)
   ```
3. Add to algorithm list in experimental scripts

### Adding New Functions
1. Implement in `cec17_func.m` or create separate function
2. Follow the standard interface:
   ```matlab
   function y = new_function(x)
   ```
3. Add to test function list

### Modifying Analysis
- Statistical measures: Edit `statistical_analysis.m`
- Plotting options: Modify `plot_convergence.m`
- Report format: Customize report generation functions

## Citation

If you use this experimental framework, please cite the original SDO paper:

```
[Paper citation will be added when published]
```

## License

This experimental framework is provided for research and educational purposes.

## Contact

For questions or issues regarding the experimental framework, please create an issue in the repository.

---

**Note**: This framework is designed to reproduce the experimental methodology described in the SDO paper. The implementations are based on the algorithmic descriptions provided in the respective papers and may vary from other implementations.