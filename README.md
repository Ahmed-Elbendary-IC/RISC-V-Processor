# 🖥️ Simple RISC-V Processor

A simple **single-cycle RISC-V processor** implemented using **Verilog HDL** and verified through simulation using **ModelSim**.

---

## 📌 Project Overview

This project implements a basic RISC-V processor based on the **RV32I instruction format**.

The processor is designed as a simple single-cycle datapath and includes the main components required to fetch, decode, execute, access memory, and write results back to the register file.

A dedicated Verilog testbench was also developed to verify the processor using multiple instruction cases and to monitor both the final results and internal processor signals.

---

## 🏗️ Processor Architecture

The processor consists of the following main modules:

| Module | Description |
|---|---|
| `top_risc_v` | Top-level module connecting all processor components |
| `pc_32` | Program Counter |
| `mem_instr` | Instruction Memory |
| `reg_file` | Register File |
| `alu` | Arithmetic Logic Unit |
| `sign_ext` | Immediate Sign Extension Unit |
| `control_unit` | Main Control Unit and ALU Control |
| `mem_data` | Data Memory |

### Main Datapath

```text
              ┌─────────────────┐
              │ Program Counter │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Instruction     │
              │ Memory          │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Control Unit    │
              └────────┬────────┘
                       │
          ┌────────────┴────────────┐
          │                         │
          ▼                         ▼
   ┌──────────────┐         ┌──────────────┐
   │ Register File│         │ Sign Extend  │
   └──────┬───────┘         └──────┬───────┘
          │                         │
          └────────────┬────────────┘
                       ▼
                  ┌─────────┐
                  │   ALU   │
                  └────┬────┘
                       │
              ┌────────┴────────┐
              │                 │
              ▼                 ▼
       ┌────────────┐     ┌────────────┐
       │ Data Memory│     │ Write Back │
       └────────────┘     └────────────┘
```

---

## ⚙️ Supported Instructions

The processor includes support for the following instructions:

### Immediate Instructions

- `ADDI`

### R-Type Instructions

- `ADD`
- `SUB`
- `AND`
- `OR`
- `XOR`
- `SLT`

### Memory Instructions

- `LW`
- `SW`

### Branch

- `BEQ` control logic is included in the processor.

---

## 🧩 ALU Operations

The ALU supports the following operations:

| ALU Control | Operation |
|---|---|
| `000` | ADD |
| `001` | SUB |
| `010` | AND |
| `011` | OR |
| `100` | XOR |
| `101` | SLT |

The ALU also generates a `zero` signal used by the branch decision logic.

---

## 🗂️ Project Structure

```text
RISC-V-Processor/
│
├── rtl/
│   ├── top_risc_v.v
│   ├── pc_32.v
│   ├── mem_instr.v
│   ├── reg_file.v
│   ├── mem_data.v
│   ├── alu.v
│   ├── sign_ext.v
│   └── control_unit.v
│
├── tb/
│   └── tb_top_risc_v.v
│
├── documentation/
│   └── RISC-V_Verification_Documentation.pdf
│
├── screenshots/
│   ├── blockdigram.png
│   ├── transcript.png
│   ├── waveform_full.png
│   └── waveform_transcript.png
│
└── README.md
```

---

## 🧪 Verification

A dedicated Verilog testbench was developed to verify the processor.

The testbench:

- Generates the clock signal.
- Applies reset to the processor.
- Executes the instruction sequence stored in instruction memory.
- Monitors internal processor signals.
- Checks expected register values.
- Reports `PASS` or `FAIL` for individual verification cases.
- Allows different instruction operations to be checked during simulation.

### Example Verification Sequence

The instruction memory contains a sequence including:

```text
ADDI x1, x0, 5
ADDI x2, x0, 3

ADD  x3, x1, x2
SUB  x4, x1, x2
AND  x5, x1, x2
OR   x6, x1, x2
XOR  x7, x1, x2
SLT  x8, x1, x2

ADDI x5, x0, -1

SW   x1, 4(x0)
LW   x6, 4(x0)
```

### Expected Results

For the arithmetic and logical instructions:

```text
x1 = 5
x2 = 3

ADD  → x3 = 8
SUB  → x4 = 2
AND  → x5 = 1
OR   → x6 = 7
XOR  → x7 = 6
SLT  → x8 = 0
```

---

## 🔍 Bug Detection During Verification

One of the purposes of the testbench was not only to verify correct cases, but also to detect incorrect behavior.

During the verification process, the `XOR` instruction was intentionally observed through a test case where the expected result was:

```text
Expected = 6
```

while the simulation initially produced:

```text
Actual = 0
```

The testbench therefore reported:

```text
FAIL: expected = 6, actual = 0
```

This demonstrates that the verification environment was able to detect an incorrect ALU result instead of simply assuming that the design was correct.

The failure was then used as a debugging case to investigate the ALU/control path and verify the processor implementation.

> **Note:** The `FAIL` result shown in the verification output represents a detected test case during debugging and is intentionally documented as part of the verification process.

---

## 📊 Simulation Results

The processor was simulated using **ModelSim**.

### Waveform

The waveform was used to observe the internal processor signals, including:

- Clock and reset
- Program Counter
- Instruction
- Control signals
- Register File outputs
- Immediate value
- ALU inputs
- ALU result
- Zero flag
- Data memory signals

![RISC-V Waveform](screenshots/waveform_full.png)

### Detailed Waveform / Transcript

![RISC-V Waveform and Transcript](screenshots/waveform_transcript.png)

### Simulation Transcript

The simulation transcript shows the processor state at different simulation times and displays the verification results.

![Simulation Transcript](screenshots/transcript.png)

### Processor Block Diagram

![RISC-V Processor Block Diagram](screenshots/blockdigram.png)

---

## 🔍 Internal Signals Monitored

The following internal signals were monitored during simulation:

```text
w_pc_out
w_pc_plus_4
w_pc_in_next
w_instr

w_rd1_src_a
w_rd2
w_src_b
w_imm_ext

w_alu_result
w_zero

w_branch
w_result_src
w_en_mem_write
w_alu_src
w_en_reg_write
w_alu_control
```

Register values were also monitored:

```text
x1
x2
x3
x4
x5
x6
x7
x8
```

These signals make it possible to observe the processor operation at different stages of instruction execution.

---

## 🛠️ Tools Used

- **Verilog HDL**
- **ModelSim**
- **GitHub**

---

## 📚 Documentation

A detailed project report is available here:

📄 [RISC-V Verification Documentation](documentation/RISC-V_Verification_Documentation.pdf)

The documentation includes:

- Processor architecture
- Module descriptions
- Testbench design
- Verification methodology
- Simulation results
- Waveform analysis
- Detected issues and debugging
- Verification results

---

## 🎯 Project Objectives

The main objectives of this project are:

1. Implement a basic RISC-V processor using Verilog HDL.
2. Connect the processor datapath and control unit.
3. Implement arithmetic and logical operations.
4. Implement load and store memory operations.
5. Develop a reusable verification testbench.
6. Monitor internal processor signals using ModelSim waveforms.
7. Detect incorrect behavior through expected-versus-actual comparisons.
8. Document the verification and debugging process.

---

## 👨‍💻 Author

**Ahmed Elbendary Ramadan Elbendary**

**RISC-V Processor Design & Verification Project**
