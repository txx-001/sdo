# SDO - Sled Dog-inspired Optimizer

This repository contains a complete implementation of the Sled Dog-inspired Optimizer (SDO) algorithm with tools to reproduce Figure 11 from the research paper.

## Quick Start

To reproduce Figure 11 (qualitative analysis), run:

```matlab
% Full analysis (recommended)
qualitative_analysis_SDO()

% Quick demonstration
demo_figure_11()
```

## Files Overview

- **`SDO.m`** - Basic SDO algorithm
- **`SDO_enhanced.m`** - Enhanced version with tracking
- **`qualitative_analysis_SDO.m`** - Main Figure 11 reproduction script
- **`benchmark_functions.m`** - Test functions (Sphere, Rastrigin, etc.)
- **`README_reproduction.md`** - Complete documentation

## Generated Outputs

The scripts generate comprehensive analysis including:
- Convergence curves comparison
- Parameter evolution analysis (y, c1, c2, w1, p1, CF)
- Population diversity dynamics
- Statistical performance comparison

See `README_reproduction.md` for detailed usage instructions and customization options.