# 🔒 VHDL SHA-512 Algorithm Implementation

This repository contains the **SHA-512 Hash Algorithm Implementation** in VHDL, optimized for use in digital systems and embedded applications. It provides both a loop-unrolled and an unoptimized version, allowing for a comparison in terms of performance and resource usage. SHA-512 is a secure cryptographic hashing algorithm widely used in data integrity and security applications.

## 📁 Repository Structure

The repository is organized into two main directories, each implementing a distinct version of the SHA-512 algorithm:

- **`loop_unrolled`** - Contains the loop-unrolled SHA-512 implementation, optimized for performance. This version reduces the number of iterations by unrolling loops, which can significantly improve speed at the cost of increased resource usage.
- **`unoptimized`** - Contains the standard SHA-512 implementation without loop unrolling, following a more straightforward design that is resource-efficient but slower in performance.

### Key Files in Each Directory

- **`CONSTANTS.vhd`** - Defines constants and parameter values for the algorithm, making it easier to adjust hash size, initial values, and configuration.
- **`sha512_core.vhd`** - Implements the SHA-512 hashing core, handling the main transformation operations of the algorithm.
- **`sha512_tb.vhd`** - A testbench for verifying the SHA-512 core’s functionality, including exhaustive test cases to ensure correct hash computation.

## ✨ Key Features

- **Dual Implementations**: Both optimized (loop-unrolled) and unoptimized versions to meet different performance and resource needs.
- **Parameterization**: Easily configurable constants for adapting hash settings.
- **Comprehensive Testbench**: Each implementation includes a testbench with various input scenarios to validate the correctness of hash outputs.

## 🚀 Getting Started

### Prerequisites

1. **VHDL Simulator**: Ensure you have a VHDL simulator installed, such as ModelSim, Vivado, or GHDL, to compile and run the files.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/raidenkhan/VHDL_SHA_512
   cd VHDL_SHA_512
