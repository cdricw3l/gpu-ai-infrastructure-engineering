# Reading List — GPU Systems, ROCm, Linux Performance and AI Inference

## Goal

Build a focused technical library for developing deep expertise in:

- C systems programming;
- Linux performance engineering;
- GPU architecture;
- HIP / ROCm;
- parallel computing;
- Transformer internals;
- inference engine design;
- multi-GPU systems;
- AI infrastructure.

The objective is not to read as many books as possible.

The objective is to read the books that directly support the development path:

```text
Linux systems
      ↓
performance engineering
      ↓
GPU architecture
      ↓
HIP / ROCm
      ↓
Transformers
      ↓
inference engines
      ↓
multi-GPU systems
```

---

# Priority 1 — Essential Books

These books should form the core of the learning path.

---

## 1. Programming Massively Parallel Processors

**Authors**

David B. Kirk  
Wen-mei W. Hwu  
Izzat El Hajj

## Why Read It

This should be one of the main GPU books.

It develops the mental model required to understand massively parallel execution.

Main topics include:

- GPU execution models;
- threads and blocks;
- memory hierarchy;
- tiling;
- reductions;
- stencil computations;
- synchronization;
- memory access optimization;
- parallel algorithms;
- performance analysis.

Although many examples are based on CUDA, the concepts transfer directly to HIP.

The syntax is secondary.

The important part is understanding the architecture and algorithms.

## How to Use It

For every major chapter:

1. understand the algorithm;
2. implement a CPU version in C;
3. implement the naive HIP version;
4. benchmark it;
5. profile it;
6. implement the optimized version;
7. compare the results.

## Priority

**Critical**

Read deeply.

---

# 2. Systems Performance

**Author**

Brendan Gregg

**Recommended edition**

Second Edition.

## Why Read It

This book connects applications, operating systems, kernels, CPUs, memory, storage, and performance analysis.

It is particularly important for the target profile:

```text
Linux Systems Engineer
+
GPU Performance Engineer
```

Important topics include:

- performance methodology;
- CPUs;
- scheduling;
- memory;
- storage;
- networking;
- profiling;
- tracing;
- latency analysis;
- observability;
- system bottlenecks.

## Project Relevance

It will help answer questions such as:

> Is the GPU actually the bottleneck?

> Is the inference process waiting on the CPU?

> Is memory pressure affecting latency?

> Is model loading limited by storage?

> Is a system-level bottleneck being mistaken for a GPU problem?

## Priority

**Critical**

Read almost completely.

---

# 3. Computer Systems: A Programmer's Perspective

**Authors**

Randal E. Bryant  
David R. O'Hallaron

## Why Read It

This book is an excellent bridge between C programming, computer architecture, and operating systems.

Important topics include:

- machine representation;
- assembly;
- linking;
- caches;
- memory hierarchy;
- virtual memory;
- processes;
- signals;
- concurrency;
- synchronization;
- system-level optimization.

## Project Relevance

It provides the background needed to understand:

```text
C program
   ↓
compiler
   ↓
machine code
   ↓
CPU
   ↓
cache
   ↓
memory
   ↓
operating system
```

That knowledge becomes extremely useful when working on the CPU side of an inference engine.

## Priority

**Critical**

Read deeply.

---

# 4. Build a Large Language Model (From Scratch)

**Author**

Sebastian Raschka

## Why Read It

This book provides a practical introduction to constructing a GPT-style language model from first principles.

Important topics include:

- tokenization;
- embeddings;
- attention;
- Transformer blocks;
- training;
- autoregressive generation;
- model architecture.

## Project Relevance

The goal should not be to remain dependent on the Python implementation.

Instead:

```text
understand in Python
        ↓
rewrite the operation in C
        ↓
implement it in HIP
```

For example:

```text
RMSNorm
Softmax
RoPE
Attention
MLP
KV cache
```

## Priority

**Critical**

Read while beginning the Transformer implementation.

---

# 5. Performance Analysis and Tuning on Modern CPUs

**Author**

Denis Bakhvalov

## Why Read It

This book is particularly useful for developing low-level performance intuition.

Important topics include:

- CPU pipelines;
- branch prediction;
- cache behavior;
- memory access;
- profiling;
- performance counters;
- optimization methodology.

## Project Relevance

A GPU inference engine still relies heavily on CPU-side work:

```text
tokenization
model loading
scheduler
memory management
tensor metadata
request handling
GPU command submission
```

A poorly designed CPU side can reduce overall GPU performance.

## Priority

**Very High**

Read after or alongside `Systems Performance`.

---

# Priority 2 — Architecture and Deep Systems Knowledge

These books provide deeper understanding after the first core material.

---

# 6. Computer Architecture: A Quantitative Approach

**Authors**

John L. Hennessy  
David A. Patterson

## Why Read It

This book develops deeper architectural reasoning.

Important areas include:

- instruction-level parallelism;
- memory hierarchies;
- multicore systems;
- accelerators;
- parallel architectures;
- performance measurement;
- architectural tradeoffs.

## Project Relevance

It will help develop the ability to reason about hardware rather than treating the GPU as a black box.

This becomes especially important when comparing:

```text
RDNA 3
vs
RDNA 4
```

or analyzing why different architectures favor different kernels.

## Priority

**High**

Read selectively at first.

Return to it repeatedly as knowledge increases.

---

# 7. The Linux Programming Interface

**Author**

Michael Kerrisk

## Why Read It

This is one of the most complete references for Linux system programming.

Topics include:

- system calls;
- files;
- processes;
- threads;
- memory mapping;
- signals;
- IPC;
- virtual memory;
- synchronization;
- `/proc`;
- POSIX APIs.

## How to Use It

Do not necessarily read it from beginning to end.

Use it as a technical reference.

Particularly relevant chapters include:

```text
memory mapping
virtual memory
threads
process management
file I/O
signals
IPC
/proc
```

## Project Relevance

Useful for implementing:

```text
model loader
mmap-based model access
thread pools
memory management
service infrastructure
```

## Priority

**High as a reference**

**Medium as a full read**

---

# 8. Efficient Processing of Deep Neural Networks

**Authors**

Vivienne Sze  
Yu-Hsin Chen  
Tien-Ju Yang  
Joel S. Emer

## Why Read It

This book connects neural networks to hardware efficiency.

Important topics include:

- data movement;
- memory cost;
- accelerator design;
- computational efficiency;
- neural-network workload characteristics;
- hardware/software co-design.

## Project Relevance

One of the most important ideas in GPU inference is:

> Moving data can be more expensive than computing on it.

That principle becomes critical for:

```text
attention
KV cache
quantization
multi-GPU
PCIe transfers
kernel fusion
```

## Priority

**High**

Read after basic GPU and Transformer knowledge.

---

# Priority 3 — Reference Material

These resources should be consulted while implementing the project.

---

# AMD ROCm Documentation

https://rocm.docs.amd.com/en/latest/index.html

For HIP and ROCm specifically, prefer official documentation over printed books.

ROCm evolves quickly.

Important documentation areas include:

```text
HIP runtime
HIP language
rocBLAS
hipBLASLt
rocprofv3
ROCm profiler
GPU architecture support
memory management
multi-GPU
peer-to-peer transfers
```

Maintain documentation bookmarks for:

```text
HIP API
ROCm API
rocprofv3
rocBLAS
hipBLASLt
```

## Priority

**Continuous reference**

---

# AMD GPU Architecture Documentation

Study available technical documentation related to:

```text
RDNA
RDNA 3
RDNA 4
Compute Units
wavefronts
LDS
registers
cache hierarchy
matrix operations
memory subsystem
```

The goal is to understand the actual hardware used by:

```text
W7900
gfx1100
```

and later:

```text
R9700
gfx1201
```

## Priority

**Continuous reference**

---

# Recommended Reading Order

A practical reading sequence:

```text
1. Computer Systems: A Programmer's Perspective
        +
2. Systems Performance

        ↓

3. Performance Analysis and Tuning on Modern CPUs

        ↓

4. Programming Massively Parallel Processors

        ↓

5. HIP / ROCm documentation

        ↓

6. Build a Large Language Model From Scratch

        ↓

7. Implement a small Transformer in C

        ↓

8. Implement Transformer kernels in HIP

        ↓

9. Computer Architecture: A Quantitative Approach

        ↓

10. Efficient Processing of Deep Neural Networks
```

Keep:

```text
The Linux Programming Interface
```

available throughout the entire project as a reference.

---

# Reading Strategy

Do not read passively.

For every important concept:

```text
read
 ↓
implement