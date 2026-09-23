# Low Power VLSI Design Using Clock Gating

## Project Overview

This project presents a comparative study of a baseline synchronous VLSI design and a low-power design using clock gating.

The low-power implementation uses the FPGA-specific **BUFGCE** clock-control primitive to control clock delivery to the processing unit during inactive periods.

## Objectives

- Design a baseline synchronous processing unit.
- Develop a low-power clock-gated implementation.
- Verify functional equivalence between both designs.
- Perform synthesis and implementation using Vivado.
- Analyze timing and resource utilization.
- Measure power at different activity levels.
- Compare baseline and low-power implementations.

## Tools Used

- AMD/Xilinx Vivado 2025.2 ML Edition
- Verilog HDL
- Kintex-7 FPGA
- SAIF switching-activity analysis

## Hardware Target

**FPGA:** Kintex-7  
**Device:** `xc7k70tfbg676-1`  
**Clock Frequency:** 100 MHz  
**Clock Period:** 10 ns

## Design Modules

| Module | Description |
|---|---|
| `alu32.v` | 32-bit arithmetic and logic unit |
| `reg_bank.v` | 8 × 32-bit register bank |
| `processing_unit.v` | Main processing and control logic |
| `baseline_top.v` | Baseline synchronous implementation |
| `low_power_top.v` | BUFGCE-based low-power implementation |

## Verification

The baseline and low-power designs were compared cycle by cycle.

- Simulation cycles: **1000**
- Simulation time: **approximately 10.025 µs**
- Functional mismatches: **0**
- Verification status: **PASS**

## Implementation Results

| Metric | Baseline | Low-Power |
|---|---:|---:|
| Slice LUTs | 97 | 97 |
| Slice Registers | 48 | 48 |
| LUT as Logic | 97 | 97 |
| BUFGCTRL | 1 | 1 |

## Timing Results

| Metric | Value |
|---|---:|
| WNS | +8.545 ns |
| TNS | 0 ns |
| WHS | +0.231 ns |
| THS | 0 ns |
| Worst Pulse-Width Slack | +4.650 ns |
| Failing Endpoints | 0 |

## Power Comparison

| Duty Cycle | Baseline | Low-Power |
|---:|---:|---:|
| 10% | 0.083 W | 0.083 W |
| 25% | 0.083 W | 0.083 W |
| 50% | 0.084 W | 0.084 W |
| 75% | 0.085 W | 0.085 W |
| 100% | 0.086 W | 0.086 W |

The measured total-power values were equal at the displayed precision for all tested duty cycles. Therefore, this particular implementation did not demonstrate a measurable total-power reduction at the reported precision.

## Project Files

- RTL source files
- Functional simulation testbench
- Power-analysis testbenches
- Duty-cycle testbenches
- Clock constraint file
- Internship project report
- Complete Vivado project backup

## Internship Project

**Organization:** Vaidsys Technologies  
**Project:** Low Power VLSI Design Using Clock Gating  
**Student:** Hareesh Yarabati  
**Year:** 2026

## Author

**Hareesh Yarabati**
