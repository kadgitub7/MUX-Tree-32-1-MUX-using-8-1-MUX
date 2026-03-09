# 32:1 MUX Tree (Using 8:1 MUX) | Verilog

A Verilog implementation of a **32:1 multiplexer (MUX) using a tree of 8:1 MUXes with enable**, developed and simulated in the Vivado IDE. This document explains what a **multiplexer** is, what a **MUX tree** is, how a **32:1 MUX** behaves, how to **realize it using 8:1 MUXes with enable and OR gating**, derives the **general Boolean equation**, summarizes the **circuit, waveform, and testbench results**, and provides steps to run the project in Vivado.

---

## Table of Contents

- [What Is a Multiplexer and MUX Tree?](#what-is-a-multiplexer-and-mux-tree)
- [32:1 MUX Truth Table and Behavior](#321-mux-truth-table-and-behavior)
- [Boolean Equation and 32:1 Realization](#boolean-equation-and-321-realization)
- [32:1 MUX Using 8:1 MUX Architecture](#321-mux-using-81-mux-architecture)
- [Learning Resources](#learning-resources)
- [Circuit Diagram](#circuit-diagram)
- [Waveform Diagram](#waveform-diagram)
- [Testbench Output](#testbench-output)
- [Running the Project in Vivado](#running-the-project-in-vivado)
- [Project Files](#project-files)

---

## What Is a Multiplexer and MUX Tree?

A **multiplexer (MUX)** is a combinational circuit that selects **one of several input signals** and forwards it to a **single output line**, based on the value of **selector inputs**.

In general:

- **n** = number of data inputs  
- **m** = number of select lines  
- They are related by: **n = 2<sup>m</sup>**

Examples:

| MUX Type  | Data Inputs | Select Lines |
|-----------|-------------|--------------|
| 2:1 MUX   | 2           | 1            |
| 4:1 MUX   | 4           | 2            |
| 8:1 MUX   | 8           | 3            |
| 16:1 MUX  | 16          | 4            |
| 32:1 MUX  | 32          | 5            |

### What Is a MUX Tree?

A **MUX tree** is a structured way of obtaining a **higher-order MUX using multiple lower-order MUXes**. When we connect lower-order MUXes in stages to build a higher-order function, the interconnection diagram forms a **tree-like structure**, hence the name **MUX tree**.

For this project, we build a **32:1 MUX** using **four 8:1 MUXes with enable inputs**, plus **simple decoding logic and OR gates**.

**Inputs and output for the 32:1 MUX:**

- **Inputs**
  - **I<sub>0</sub> … I<sub>31</sub>** — data inputs  
  - **S<sub>4</sub>**, **S<sub>3</sub>**, **S<sub>2</sub>**, **S<sub>1</sub>**, **S<sub>0</sub>** — select lines (5 bits total)
- **Output**
  - **Y** — selected data output

### How Many 8:1 MUXes Are Required?

We want to realize a **32:1 MUX** using **8:1 MUXes**.

- Target MUX: **32:1**  
- Building block: **8:1 MUX**

Compute the number of 8:1 MUXes by **repeated division**:

| Step | Division | Result |
|------|----------|--------|
| 1    | 32 ÷ 8   | 4      |
| 2    | 4 ÷ 8    | 0.5    |

The result **does not reach 1 cleanly**, so a pure tree of 8:1 MUXes is **not** sufficient on its own. Instead, we use:

- **Four 8:1 MUXes** (each handling 8 inputs), and  
- **Enable control plus OR gates** to select which 8:1 MUX block is active.

This is why the design uses:

- **S<sub>2</sub>, S<sub>1</sub>, S<sub>0</sub>** — to select one of 8 inputs **inside** each 8:1 MUX block.  
- **S<sub>4</sub>, S<sub>3</sub>** — to select **which 8:1 block** (x1, x2, x3, x4) is active via enable and OR logic.

---

## 32:1 MUX Truth Table and Behavior

For a **32:1 MUX**, the behavior is defined by the **5-bit select lines**:

- **Selector variables:** S<sub>4</sub>, S<sub>3</sub>, S<sub>2</sub>, S<sub>1</sub>, S<sub>0</sub> (5 bits)  
- **Inputs:** I<sub>0</sub> … I<sub>31</sub>  
- **Output:** Y  

Conceptually, the truth table has **32 rows**, one for each possible select value.

**Intuitive behavior:**

- The select lines **S<sub>4</sub> S<sub>3</sub> S<sub>2</sub> S<sub>1</sub> S<sub>0</sub>** form a 5-bit binary number from **0** to **31**.
- That number selects **which input appears on Y**:

| S<sub>4</sub>…S<sub>0</sub> (decimal) | Selected Input | Y        |
|:-------------------------------------:|----------------|----------|
| 0                                     | I<sub>0</sub>  | I<sub>0</sub>  |
| 1                                     | I<sub>1</sub>  | I<sub>1</sub>  |
| 2                                     | I<sub>2</sub>  | I<sub>2</sub>  |
| ...                                   | ...            | ...      |
| 31                                    | I<sub>31</sub> | I<sub>31</sub> |

In the **32:1 MUX realization using 8:1 MUXes with enable**:

- **S<sub>2</sub>, S<sub>1</sub>, S<sub>0</sub>** control the selection **within each 8:1 MUX**.
- **S<sub>4</sub>, S<sub>3</sub>** are decoded to generate **four enable signals**, each enabling exactly **one 8:1 MUX block** at a time:
  - When the enable of a block is **1**, that block’s output is allowed to drive the final OR gate.
  - When the enable is **0**, that block’s output is effectively disabled.

This assignment of select bits and enables yields the correct **32:1 MUX behavior**, as confirmed by simulation.

---

## Boolean Equation and 32:1 Realization

From the full truth table, the **Boolean expression** for **Y** in terms of **S<sub>4</sub>…S<sub>0</sub>** and **I<sub>0</sub>…I<sub>31</sub>** can be written as a **sum of minterms**:

\[
Y = \sum_{k=0}^{31} m_k
\]

where each minterm \(m_k\) is of the form:

\[
m_k = \left(\prod_{i=0}^{4} L_i^{(k)}\right) I_k
\]

Here:

- \(L_i^{(k)}\) is either **S<sub>i</sub>** or its complement **\(\overline{S_i}\)**, depending on the binary representation of \(k\).  
- The product term \(\prod_{i=0}^{4} L_i^{(k)}\) is **1** only when the select lines represent the binary number \(k\).  
- Then that term **selects input I<sub>k</sub>**.

In expanded form, the equation begins:

\[
\begin{aligned}
Y =\; & \overline{S_4}\,\overline{S_3}\,\overline{S_2}\,\overline{S_1}\,\overline{S_0}\,I_0
   + \overline{S_4}\,\overline{S_3}\,\overline{S_2}\,\overline{S_1}\,S_0\,I_1 \\
   & + \overline{S_4}\,\overline{S_3}\,\overline{S_2}\,S_1\,\overline{S_0}\,I_2
   + \cdots
   + S_4\,S_3\,S_2\,S_1\,S_0\,I_{31}
\end{aligned}
\]

Where:

- **Adjacency** (e.g., S<sub>4</sub>S<sub>3</sub>) denotes **AND**.  
- **"+"** denotes **OR**.  
- The overline **\(\overline{S}\)** (or prime **S′**) denotes logical complement (NOT).

The **MUX tree** composed of **8:1 MUXes with enable** implements exactly this function **without** manually writing all 32 product terms; the **select logic and enable decoding** substitute for the equivalent sum‑of‑products realization.

---

## 32:1 MUX Using 8:1 MUX Architecture

The **32:1 MUX** is built from **four 8:1 MUXes with enable signals**, plus **enable decoding** and **OR gates**.

### Stage 1 – Four 8:1 MUX Blocks (Internal Selection by S<sub>2</sub>, S<sub>1</sub>, S<sub>0</sub>)

We divide the 32 inputs into **four groups of eight**:

- Block **x1**: I<sub>0</sub> … I<sub>7</sub>  
- Block **x2**: I<sub>8</sub> … I<sub>15</sub>  
- Block **x3**: I<sub>16</sub> … I<sub>23</sub>  
- Block **x4**: I<sub>24</sub> … I<sub>31</sub>  

Each block is realized using an **8:1 MUX with an enable input (E)**:

| Block | Inputs                         | Select Lines          | Enable | Output |
|-------|--------------------------------|------------------------|--------|--------|
| x1    | I<sub>0</sub> … I<sub>7</sub>   | S<sub>2</sub>, S<sub>1</sub>, S<sub>0</sub> | E<sub>0</sub> | X<sub>0</sub> |
| x2    | I<sub>8</sub> … I<sub>15</sub> | S<sub>2</sub>, S<sub>1</sub>, S<sub>0</sub> | E<sub>1</sub> | X<sub>1</sub> |
| x3    | I<sub>16</sub> … I<sub>23</sub>| S<sub>2</sub>, S<sub>1</sub>, S<sub>0</sub> | E<sub>2</sub> | X<sub>2</sub> |
| x4    | I<sub>24</sub> … I<sub>31</sub>| S<sub>2</sub>, S<sub>1</sub>, S<sub>0</sub> | E<sub>3</sub> | X<sub>3</sub> |

Within each 8:1 MUX:

- **S<sub>2</sub> S<sub>1</sub> S<sub>0</sub>** select one of the eight inputs in that block.
- If **E = 1**, the selected input appears at the block output X<sub>k</sub>.  
- If **E = 0**, the block output is effectively **disabled** (forced to 0 in this design), so it will not affect the final OR.

### Stage 2 – Enable Decoding (Using S<sub>4</sub>, S<sub>3</sub>)

The upper select bits **S<sub>4</sub>** and **S<sub>3</sub>** determine **which block is active**. A simple **2‑to‑4 decoder** generates the enables:

- E<sub>0</sub> = \(\overline{S_4}\,\overline{S_3}\) → enables block x1 (I<sub>0</sub>…I<sub>7</sub>)  
- E<sub>1</sub> = \(\overline{S_4}\,S_3\) → enables block x2 (I<sub>8</sub>…I<sub>15</sub>)  
- E<sub>2</sub> = \(S_4\,\overline{S_3}\) → enables block x3 (I<sub>16</sub>…I<sub>23</sub>)  
- E<sub>3</sub> = \(S_4\,S_3\) → enables block x4 (I<sub>24</sub>…I<sub>31</sub>)  

Thus:

- **Exactly one** enable E<sub>k</sub> is **HIGH** for each combination of S<sub>4</sub>, S<sub>3</sub>.  
- Only the corresponding block x<sub>k</sub> can then contribute to the final output.

This matches the intuition given in the project description:

> “The circuit is more complicated because 32/8 = 4, 4/8 = 0.5, therefore enable must be used with OR gates to get the final output.  
> The 4 initial mux will have s0,s1,s2 as select lines, the s4,s3 select lines will be used to determine which blocks, x1, x2, x3, x4 will be used.”

### Stage 3 – Final OR Combination

The four block outputs are OR-ed to obtain the final output:

\[
Y = X_0 + X_1 + X_2 + X_3
\]

Because **only one enable** is active at any time:

- Exactly one of X<sub>0</sub>, X<sub>1</sub>, X<sub>2</sub>, X<sub>3</sub> may be non‑zero.  
- Therefore **Y** equals the output of the block whose enable is active, implementing the **32:1 MUX** behavior.

### Combined Behavior

Summarizing:

- **S<sub>2</sub> S<sub>1</sub> S<sub>0</sub>** select one of 8 inputs **within** the active 8:1 MUX.  
- **S<sub>4</sub> S<sub>3</sub>** select **which group of 8 inputs** is active.  

Together, the 5‑bit select vector **S<sub>4</sub> S<sub>3</sub> S<sub>2</sub> S<sub>1</sub> S<sub>0</sub>** selects **exactly one** of I<sub>0</sub>…I<sub>31</sub>.

---

## Learning Resources

| Resource | Description |
|----------|-------------|
| [Multiplexer Basics (YouTube)](https://www.youtube.com/results?search_query=multiplexer+basics) | Introductory explanation of multiplexers, select lines, and truth tables. |
| [8:1 and 16:1 MUX Trees (YouTube)](https://www.youtube.com/results?search_query=8+to+1+multiplexer+using+2+to+1+mux) | Shows how to build larger MUXes from smaller ones. |
| [32:1 MUX Using 8:1 MUX (YouTube)](https://www.youtube.com/results?search_query=32+to+1+multiplexer+using+8+to+1+mux) | Visual explanation of the enable‑based architecture using four 8:1 MUXes. |
| [Vivado RTL Simulation Tutorials (YouTube)](https://www.youtube.com/results?search_query=vivado+rtl+simulation+tutorial) | Guides on setting up Verilog projects and running testbenches in Vivado. |

---

## Circuit Diagram

The **structural** circuit for the 32:1 MUX tree using 8:1 MUXes can be viewed as:

1. **Logical (Boolean) view** — a sum of 32 minterms, where each minterm corresponds to a unique select value and multiplies the corresponding input I<sub>k</sub>.

2. **Block/MUX-tree view** — where:
   - **Four 8:1 MUXes** form the primary selection blocks (using S<sub>2</sub>, S<sub>1</sub>, S<sub>0</sub>).  
   - A **2‑to‑4 decoder** driven by (S<sub>4</sub>, S<sub>3</sub>) generates enables E<sub>0</sub>…E<sub>3</sub> for the four 8:1 blocks.  
   - A **4‑input OR gate** combines the four block outputs into Y.

Key structural components:

- Four 8:1 MUX blocks, each with inputs, 3‑bit select, and one enable input.  
- A small decoder for E<sub>0</sub>…E<sub>3</sub>.  
- OR gate (or equivalent logic) combining X<sub>0</sub>…X<sub>3</sub> to Y.  
- Five select lines S<sub>4</sub>…S<sub>0</sub> feeding either block selects or decoder.

Schematic layout (conceptually):

- **Left side:** inputs grouped as (I<sub>0</sub>…I<sub>7</sub>), (I<sub>8</sub>…I<sub>15</sub>), (I<sub>16</sub>…I<sub>23</sub>), (I<sub>24</sub>…I<sub>31</sub>).  
- **Middle:** four 8:1 MUXes (x1–x4) with shared select lines S<sub>2</sub>, S<sub>1</sub>, S<sub>0</sub> and individual enables.  
- **Top/side:** 2‑to‑4 decoder driven by S<sub>4</sub>, S<sub>3</sub> generating E<sub>0</sub>…E<sub>3</sub>.  
- **Right side:** OR gate combining X<sub>0</sub>…X<sub>3</sub> into the single output **Y**.

![32:1 Multiplexer Circuit](imageAssets/32x1MUXCircuit.png)

---

## Waveform Diagram

The **behavioral simulation waveform** illustrates:

- **Inputs over time:**  
  - Select lines S<sub>4</sub>, S<sub>3</sub>, S<sub>2</sub>, S<sub>1</sub>, S<sub>0</sub>  
  - Data inputs I<sub>0</sub>…I<sub>31</sub>  
- **Output:** Y

Typical simulation approach:

- Apply a **test pattern** to the inputs I<sub>0</sub>…I<sub>31</sub>.  
- Sweep the select vector **SEL = S<sub>4</sub>S<sub>3</sub>S<sub>2</sub>S<sub>1</sub>S<sub>0</sub>** through all 32 combinations (00000 to 11111).  
- For each combination, verify that **Y** equals the correctly selected input.

In this project, the waveform demonstrates that as **SEL** increments from `00000` to `11111`, the output **Y** follows the intended pattern based on the input assignments in the testbench.

![32:1 Multiplexer Waveform](imageAssets/32x1MUXWaveform.png)

---

## Testbench Output

A representative simulation log from the **32:1 MUX testbench** is:

```text
SEL=00000  Y=0
SEL=00001  Y=1
SEL=00010  Y=0
SEL=00011  Y=1
SEL=00100  Y=0
SEL=00101  Y=1
SEL=00110  Y=0
SEL=00111  Y=1
SEL=01000  Y=1
SEL=01001  Y=0
SEL=01010  Y=1
SEL=01011  Y=0
SEL=01100  Y=1
SEL=01101  Y=0
SEL=01110  Y=1
SEL=01111  Y=0
SEL=10000  Y=0
SEL=10001  Y=0
SEL=10010  Y=1
SEL=10011  Y=1
SEL=10100  Y=0
SEL=10101  Y=0
SEL=10110  Y=1
SEL=10111  Y=1
SEL=11000  Y=1
SEL=11001  Y=1
SEL=11010  Y=0
SEL=11011  Y=0
SEL=11100  Y=1
SEL=11101  Y=1
SEL=11110  Y=0
SEL=11111  Y=0
```

Interpretation:

- Each **SEL** value is a distinct 5‑bit selection code.  
- For a given **SEL**, the testbench assigns the data inputs so that **exactly one condition on the inputs** is intended, and then verifies that **Y** matches the required value (0 or 1) for that case.  
- The pattern of 0s and 1s for Y is chosen to exercise different input groups and to verify:
  - Correct **internal 8:1 selection** via S<sub>2</sub>…S<sub>0</sub>.  
  - Correct **block enable selection** via S<sub>4</sub>, S<sub>3</sub>.  
  - Proper **OR combination** of the four block outputs.

The log confirms that for all 32 select combinations, **Y** behaves exactly as specified by the design.

---

## Running the Project in Vivado

Follow these steps to open and simulate the **32:1 MUX tree using 8:1 MUX** design in **Vivado**.

### Prerequisites

- **Xilinx Vivado** installed (any recent edition that supports RTL simulation).

### 1. Launch Vivado

1. Open Vivado from the Start Menu (Windows) or your application launcher.  
2. Select the main **Vivado** IDE.

### 2. Create a New RTL Project

1. Click **Create Project** (or **File → Project → New**).  
2. Click **Next** on the welcome page.  
3. Choose **RTL Project**.  
4. Uncheck **Do not specify sources at this time** if you plan to add Verilog files immediately.  
5. Click **Next** to go to source file selection.

### 3. Add Design and Simulation Sources

Add the Verilog files for this project:

1. In **Add Sources**, add:
   - **Design sources:**
     - `eightOneMultiplexer.v` — 8:1 MUX building block with enable (e.g., ports: I0…I7, S2…S0, E, Y).  
     - `thirtyTwoMUX.v` — 32:1 MUX top-level design using four 8:1 MUXes, decoding logic, and OR gates (ports: I0…I31, S0…S4, Y).
   - **Simulation sources:**
     - `thirtyTwoMUX_tb.v` — testbench that drives I0…I31 and SEL (S4…S0) through all 32 combinations and records Y.

2. Under **Simulation Sources**, right-click `thirtyTwoMUX_tb.v` and choose **Set as Top**.  
3. Click **Next**, choose a **target device** (any supported device is fine for simulation), then **Next** and **Finish**.

### 4. Run Behavioral Simulation

1. In the **Flow Navigator**, under **Simulation**, click **Run Behavioral Simulation**.  
2. Vivado will elaborate the design and open the **Simulation** view with the waveform.  
3. Add the signals **SEL (S4…S0)**, **I0…I31**, and **Y** to the waveform.  
4. Run the simulation and confirm that for every **SEL** value, the output **Y** matches the expected result (as shown in the testbench log).

### 5. (Optional) Modify and Re-run

- You can edit `thirtyTwoMUX.v` or `thirtyTwoMUX_tb.v`, save the files, and then run **Run Behavioral Simulation** again to update the waveform and log.

### 6. (Optional) Synthesis, Implementation, and Bitstream

To map the design to FPGA hardware:

1. In **Sources**, right-click the design module `thirtyTwoMUX` and **Set as Top** for synthesis.  
2. Run **Synthesis** and **Implementation** from the Flow Navigator.  
3. Create a constraints file (`.xdc`) assigning FPGA pins for:
   - Data inputs: I0…I31  
   - Select inputs: S0…S4  
   - Output: Y  
4. Run **Generate Bitstream** to produce the configuration file for your FPGA board.

---

## Project Files

| File                | Description |
|---------------------|-------------|
| `eightOneMultiplexer.v` | RTL for the **8:1 multiplexer with enable**. Used as the building block for each 8‑input block (x1–x4). |
| `thirtyTwoMUX.v`    | RTL for the **32:1 multiplexer**, realized using four 8:1 MUXes, enable decoding from S<sub>4</sub>, S<sub>3</sub>, and a final OR combination to produce Y. |
| `thirtyTwoMUX_tb.v` | Testbench that applies patterns to I0…I31 and cycles SEL (S4…S0) through all 32 combinations, logging the corresponding output Y. |

---

*Author: **Kadhir Ponnambalam***
