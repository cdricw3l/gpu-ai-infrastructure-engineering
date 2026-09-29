# Roadmap — HIP, GPU Architecture and Inference Engine Expertise

## General Goal

Build deep expertise in:

- systems programming in C;
- GPU programming with HIP;
- AMD GPU architecture;
- GPU profiling and optimization;
- Transformer internals;
- autoregressive inference;
- KV cache management;
- quantization;
- inference engine design;
- multi-GPU execution;
- heterogeneous execution across different GPU architectures.

The roadmap is intentionally divided into two major objectives.

---

# Objective 1 — Master Single-GPU Inference on the Radeon PRO W7900

## Purpose

Before adding more GPUs, fully understand how to exploit the Radeon PRO W7900 you already own.

The goal of this first stage is not simply to learn HIP syntax.

The goal is to become capable of answering questions such as:

> Why is this kernel slow?

> Is it compute-bound or memory-bound?

> Why does one block size perform better than another?

> How much of the theoretical memory bandwidth am I actually using?

> Where is the bottleneck in Transformer inference?

> Can I predict the performance of an operation before profiling it?

The W7900 should become your laboratory for learning GPU architecture, performance engineering, and inference systems.

---

# Learning Principles

Use approximately:

```text
70% implementation
20% theory and architecture
10% documentation and notes
```

For every operation:

```text
1. Understand the mathematics
2. Write a CPU implementation in C
3. Write a naive HIP implementation
4. Validate numerical correctness
5. Benchmark it
6. Profile it
7. Form a performance hypothesis
8. Modify the implementation
9. Measure again
10. Document the result
```

Never optimize code that has not first been verified for correctness.

---

# Stage 1 — HIP Fundamentals

## Estimated duration

Weeks 1–4.

## Goals

Understand the HIP execution model and basic GPU programming.

Learn:

```text
hipMalloc
hipFree
hipMemcpy
hipMemset
hipSetDevice
hipGetDevice
hipGetDeviceProperties
hipDeviceSynchronize
```

Kernel concepts:

```text
__global__
__device__

threadIdx
blockIdx
blockDim
gridDim

dim3
hipLaunchKernelGGL
```

## Exercises

Implement:

```text
01_vector_add
02_vector_scale
03_saxpy
04_matrix_add
05_reduction_sum
06_dot_product
07_histogram
```

Each exercise must contain:

```text
CPU version
HIP version
correctness validation
benchmark
```

## Exit criteria

Be able to explain clearly:

```text
thread
block
grid
wavefront
Compute Unit
SIMD
VRAM
register
cache
LDS
```

---

# Stage 2 — GPU Memory Architecture

## Estimated duration

Weeks 5–8.

## Goal

Understand how data moves through the GPU.

Study:

- global memory;
- VRAM bandwidth;
- memory latency;
- coalesced accesses;
- registers;
- LDS;
- caches;
- occupancy;
- divergence;
- synchronization;
- arithmetic intensity.

Create:

```text
bench_memory
```

Test sizes such as:

```text
1 KiB
4 KiB
64 KiB
1 MiB
16 MiB
256 MiB
1 GiB
```

Test several block sizes:

```text
32
64
128
256
512
```

Record:

```text
execution time
effective GB/s
block size
occupancy
```

---

# Stage 3 — Roofline Thinking

## Goal

Learn to estimate whether an operation is limited by memory or compute.

Use:

```text
Arithmetic Intensity = FLOPs / bytes transferred
```

Analyze:

```text
vector_add
SAXPY
reduction
RMSNorm
softmax
matmul
```

Before benchmarking, write down your expected bottleneck.

After benchmarking, compare the prediction with reality.

The objective is to develop performance intuition rather than simply collect numbers.

---

# Stage 4 — Profiling

## Estimated duration

Weeks 9–12.

Use:

```text
rocprofv3
```

Learn to inspect:

- kernel execution time;
- launch overhead;
- memory transfers;
- synchronization;
- streams;
- occupancy;
- relevant hardware counters.

## Main exercise

Create several reduction implementations:

```text
reduction_v1
reduction_v2
reduction_v3
reduction_v4
```

For example:

```text
V1 — naive reduction

V2 — improved memory access

V3 — LDS reduction

V4 — wavefront-level optimization
```

Maintain a table:

| Version | Time | Effective Bandwidth | Technique |
|---|---:|---:|---|
| V1 | | | Naive |
| V2 | | | Coalescing |
| V3 | | | LDS |
| V4 | | | Wavefront |

---

# Stage 5 — Transformer Building Blocks

## Estimated duration

Month 4.

Start connecting GPU programming with Transformer inference.

---

## RMSNorm

Implement:

```c
rmsnorm_cpu();
```

then:

```c
rmsnorm_gpu();
```

Measure:

```text
numerical error
CPU time
GPU time
effective bandwidth
```

---

## Softmax

Implement a stable CPU version.

Then implement the GPU version.

Understand:

```text
maximum reduction
        ↓
exp(x - max)
        ↓
sum reduction
        ↓
normalization
```

Create several implementations and compare them.

---

## Matrix Multiplication

Start with a naive CPU implementation.

Then write a simple GPU implementation.

Afterward compare it with:

```text
rocBLAS
hipBLASLt
```

Do not try to outperform vendor libraries initially.

Your goal is to understand why they are faster.

Measure:

```text
GFLOPS
TFLOPS
matrix dimensions
block size
occupancy
```

---

# Stage 6 — Build a Mini Transformer in C

## Estimated duration

Months 4–5.

Build a simple CPU Transformer pipeline:

```text
token
  ↓
embedding
  ↓
RMSNorm
  ↓
Q / K / V
  ↓
attention
  ↓
projection
  ↓
residual
  ↓
RMSNorm
  ↓
MLP
  ↓
residual
```

Start with:

```text
C
FP32
CPU
```

Keep the implementation simple and readable.

The CPU version becomes the correctness reference for all later GPU implementations.

---

# Stage 7 — Move the Transformer to HIP

Port components progressively:

```text
RMSNorm
→ HIP

Softmax
→ HIP

Matmul
→ hipBLASLt / rocBLAS

RoPE
→ HIP

Attention
→ HIP
```

Keep CPU and GPU implementations side by side.

For every operation, compare numerical outputs.

---

# Stage 8 — Deep Understanding of Attention

Study the complete path:

```text
Q × Kᵀ
   ↓
scale
   ↓
mask
   ↓
softmax
   ↓
× V
```

For each step calculate:

```text
FLOPs
bytes read
bytes written
temporary storage
arithmetic intensity
```

Then study:

- FlashAttention;
- grouped-query attention;
- multi-query attention;
- causal masking;
- paged attention.

Do not only learn how these techniques work.

Understand why they exist.

---

# Stage 9 — Prefill and Decode

Understand the difference between:

## Prefill

Processing the initial prompt.

Typically dominated by larger matrix operations.

## Decode

Token-by-token generation.

Often much more sensitive to:

```text
memory bandwidth
KV cache
latency
```

Create:

```text
bench_prefill
bench_decode
```

Measure:

```text
tokens/s
latency per token
VRAM consumption
memory bandwidth
```

---

# Stage 10 — KV Cache

Create a basic structure:

```c
struct kv_cache {
    void *k;
    void *v;

    size_t capacity;
    size_t used;

    int device;
};
```

Study:

- memory consumption;
- context-length scaling;
- memory placement;
- bandwidth impact;
- paging;
- possible eviction strategies.

Measure the effect of context length on:

```text
VRAM
tokens/s
latency
```

---

# Stage 11 — GPU Memory Tracking

Build your own allocation tracker.

For example:

```c
struct gpu_allocation {
    void *ptr;
    size_t size;
    int device;

    const char *file;
    int line;

    struct gpu_allocation *next;
};
```

Create wrappers such as:

```c
GPU_MALLOC(...)
GPU_FREE(...)
```

Track:

```text
GPU ID
pointer
size
source file
line
allocation age
object type
```

Future object types may include:

```text
Tensor
Weights
KV Cache
Temporary Buffer
Workspace
```

This subsystem will later become useful for the multi-GPU scheduler.

---

# Stage 12 — Quantization

Start with:

```text
FP32
FP16
BF16
INT8
```

Only then move toward:

```text
INT4
```

Understand:

```text
scale
zero point
group size
quantization error
```

Implement a simple quantizer and dequantizer.

Measure:

```text
memory savings
numerical error
throughput
latency
```

---

# Stage 13 — Build a Personal GPU Library

A possible project structure:

```text
engine/
├── include/
│   ├── tensor.h
│   ├── model.h
│   ├── gpu.h
│   └── backend.h
│
├── src/
│   ├── tensor.c
│   ├── model.c
│   ├── memory.c
│   └── tokenizer.c
│
├── hip/
│   ├── vector.hip.cpp
│   ├── reduction.hip.cpp
│   ├── rmsnorm.hip.cpp
│   ├── softmax.hip.cpp
│   ├── rope.hip.cpp
│   ├── attention.hip.cpp
│   └── quant.hip.cpp
│
├── benchmarks/
│   ├── bench_memory.c
│   ├── bench_rmsnorm.c
│   ├── bench_softmax.c
│   ├── bench_attention.c
│   └── bench_gemm.c
│
└── tests/
```

Keep the main engine mostly in C.

Keep HIP-specific code isolated in the GPU backend.

---

# Stage 14 — Streams and Asynchronous Execution

Learn:

```text
hipStreamCreate
hipStreamSynchronize
hipEventCreate
hipEventRecord
```

Use at least:

```text
compute stream
transfer stream
```

Experiment with overlapping:

```text
memory transfer
+
GPU computation
```

Understand dependencies and synchronization costs.

---

# Objective 1 Final Project

By the end of the single-GPU phase, the W7900 should run your own minimal autoregressive inference engine.

The engine should support at least:

```text
model loading
tensor management
embedding
RMSNorm
RoPE
attention
MLP
KV cache
autoregressive decode
basic quantization
profiling
memory tracking
```

You should also have a benchmark suite for:

```text
memory bandwidth
reduction
RMSNorm
softmax
GEMM
RoPE
attention
prefill
decode
```

---

# Objective 1 Success Criteria

Before buying additional GPUs, you should be able to:

1. write and debug HIP kernels without relying on tutorials;
2. explain W7900 memory behavior;
3. identify whether a kernel is compute-bound or memory-bound;
4. use profiling data to locate bottlenecks;
5. implement core Transformer operators;
6. run a minimal autoregressive Transformer;
7. understand KV cache behavior;
8. measure tokens/s and latency;
9. explain why an optimization improves or hurts performance;
10. compare your kernels against ROCm libraries.

Only after reaching this point should multi-GPU become the main focus.

---

# Objective 2 — Multi-GPU and Heterogeneous Inference

## Purpose

Extend the single-GPU inference engine into a runtime capable of exploiting multiple GPUs efficiently.

A possible future configuration is:

```text
Radeon PRO W7900 48 GB
        +
Radeon AI PRO R9700 32 GB
        +
Radeon AI PRO R9700 32 GB
```

The objective is not to pretend that the three GPUs form one large GPU.

The objective is to build a runtime that explicitly understands that the GPUs have different:

- architectures;
- memory capacities;
- compute capabilities;
- memory bandwidth;
- preferred kernels;
- communication costs.

---

# Stage 15 — Basic Multi-GPU HIP

Start with only two GPUs.

Learn:

```text
hipGetDeviceCount
hipSetDevice
per-device allocation
per-device streams
peer transfers
```

Create:

```text
GPU0
GPU1
```

Allocate buffers independently.

Transfer data between devices.

Benchmark transfers in both directions.

---

# Stage 16 — PCIe Benchmarking

Create:

```text
bench_pcie
```

Measure transfers for several buffer sizes.

For example:

```text
1 MiB
16 MiB
64 MiB
256 MiB
1 GiB
```

Measure:

```text
GPU0 → GPU1
GPU1 → GPU0
```

Later extend to all GPU pairs.

The objective is to build a measured communication model.

---

# Stage 17 — Basic Model Parallelism

Start with a static split.

For example:

```text
GPU0

layers 0 → 15

        ↓

GPU1

layers 16 → 31
```

Measure:

```text
GPU0 compute time
transfer time
GPU1 compute time
end-to-end latency
```

Determine when the second GPU helps and when PCIe overhead makes performance worse.

---

# Stage 18 — Three-GPU Topology

After two-GPU execution works correctly, add the third GPU.

Build a topology matrix automatically.

Example:

```text
              GPU0      GPU1      GPU2

GPU0            -        ...       ...
GPU1           ...        -        ...
GPU2           ...       ...        -
```

Never assume link performance.

Measure it.

---

# Stage 19 — Heterogeneous GPU Description

Build a device structure such as:

```c
struct gpu_device {
    int id;

    char name[256];

    int architecture;

    size_t total_vram;
    size_t free_vram;

    double measured_memory_bandwidth;
    double measured_fp16;
    double measured_int8;
    double measured_attention;

    hipStream_t compute_stream;
    hipStream_t transfer_stream;
};
```

Later add:

```text
peer-to-peer bandwidth
PCIe latency
current VRAM usage
current load
kernel performance database
```

---

# Stage 20 — Per-GPU Benchmark Database

Benchmark every GPU independently.

For each card measure:

```text
memory bandwidth
FP32
FP16
BF16
INT8
RMSNorm
Softmax
GEMM
Attention
Prefill
Decode
```

The scheduler should use measured data rather than theoretical specifications.

---

# Stage 21 — Static Scheduler

Start with simple placement logic.

Example:

```c
int choose_gpu(
    struct inference_context *ctx,
    struct operation *op);
```

Initial decision factors:

```text
available VRAM
tensor size
operation type
measured performance
```

Do not attempt dynamic optimization immediately.

---

# Stage 22 — Cost Model

Evolve toward:

```text
cost =
    compute_time
  + transfer_time
  + synchronization_time
  + memory_pressure
```

For example:

```c
double placement_cost(
    const struct operation *op,
    const struct gpu_device *gpu);
```

The scheduler selects the device with the lowest predicted execution cost.

---

# Stage 23 — Architecture-Aware Kernel Selection

The runtime should know the target GPU architecture.

Conceptually:

```c
switch (gpu->architecture) {

case GFX1100:
    execute_rdna3_kernel(...);
    break;

case GFX1201:
    execute_rdna4_kernel(...);
    break;
}
```

Do not assume that one universal kernel is optimal.

Different architectures may require different implementations.

---

# Stage 24 — Layer Placement

Experiment with distributing Transformer layers.

For example:

```text
W7900

layers 0 → 20

R9700 #0

layers 21 → 45

R9700 #1

layers 46 → 70
```

The split should eventually be based on:

```text
measured compute speed
available VRAM
communication cost
kernel type
KV cache requirements
```

---

# Stage 25 — Reduce PCIe Traffic

A major design principle:

> Move computation toward data whenever possible.

Avoid patterns such as:

```text
R9700
  ↓
W7900
  ↓
R9700
  ↓
W7900
```

for small operations.

Prefer keeping groups of layers and their associated temporary data on the same device.

---

# Stage 26 — Compute Islands

Treat each GPU as a compute island.

Example:

```text
R9700 #0

layers 20 → 39
local KV
local temporary buffers
local workspace
```

then perform a larger transfer to:

```text
R9700 #1

layers 40 → 59
local KV
local temporary buffers
local workspace
```

Target:

```text
fewer transfers
larger transfers
better overlap
less synchronization
```

---

# Stage 27 — Pipeline Parallelism

For multiple requests:

```text
request A

GPU0 → GPU1 → GPU2

request B

       GPU0 → GPU1 → GPU2

request C

              GPU0 → GPU1 → GPU2
```

Measure:

```text
latency
throughput
total tokens/s
GPU utilization
pipeline bubbles
```

The objective is to keep all GPUs productive.

---

# Stage 28 — Distributed KV Cache

Experiment with several strategies.

For example:

```text
KV local to the GPU running attention
```

or:

```text
hot KV
→ local GPU

cold KV
→ another GPU or memory tier
```

Eventually investigate paged KV-cache designs.

The main question is whether memory savings compensate for transfer costs.

---

# Stage 29 — Dynamic Scheduler

The scheduler should eventually observe:

```text
free VRAM
GPU utilization
queue depth
kernel latency
transfer bandwidth
KV cache pressure
batch size
context length
```

and dynamically choose where to run operations.

The objective is no longer static device assignment.

The objective becomes runtime optimization.

---

# Stage 30 — Mixture-of-Experts Experiments

MoE models are particularly interesting for heterogeneous systems.

Possible architecture:

```text
                    Router
                      │
          ┌───────────┼───────────┐
          │           │           │
        W7900      R9700 #0    R9700 #1
          │           │           │
       Experts      Experts      Experts
```

The scheduler could place frequently used experts on faster GPUs and less frequently used experts on devices with more available memory.

---

# Objective 2 Final Project

Build a heterogeneous inference runtime:

```text
             Heterogeneous Inference Runtime
                         │
              ┌──────────┴──────────┐
              │                     │
        Model Scheduler       Memory Manager
              │                     │
      ┌───────┼───────┐       ┌─────┼─────┐
      │       │       │       │     │     │
   gfx1100 gfx1201 gfx1201   VRAM   KV   PCIe
      │       │       │
    W7900   R9700   R9700
```

The runtime should progressively be able to:

- discover available GPUs;
- identify their architecture;
- benchmark each device;
- benchmark GPU-to-GPU links;
- track VRAM usage;
- place tensors;
- place model layers;
- choose architecture-specific kernels;
- manage KV cache;
- minimize communication;
- overlap compute and transfers;
- execute multiple GPUs simultaneously;
- adapt scheduling decisions at runtime.

---

# Recommended Daily Routine

For approximately two hours per day:

```text
20 min
architecture / documentation

70 min
implementation

20 min
benchmarking / profiling

10 min
technical notes
```

---

# Engineering Journal

Maintain:

```text
gpu_notes.md
```

For every optimization, record:

```text
Hypothesis
Benchmark
Profiler evidence
Result
Explanation
Remaining questions
```

Example:

```markdown
## RMSNorm — Experiment

### Hypothesis

256 threads should improve effective memory bandwidth.

### Results

| Threads | Time |
|---:|---:|
| 128 | 42 µs |
| 256 | 31 µs |
| 512 | 35 µs |

### Conclusion

256 threads currently provide the best performance.

### Open Question

Why does performance decrease at 512 threads?
```

The journal is part of the learning process.

---

# Milestones

## Month 1

You can:

- write HIP kernels;
- allocate and manage VRAM;
- understand threads, blocks, and grids;
- build simple GPU benchmarks.

## Month 2

You can:

- reason about memory access;
- understand coalescing and LDS;
- distinguish compute-bound from memory-bound workloads;
- use profiling tools.

## Month 3

You can implement and optimize:

```text
reduction
RMSNorm
softmax
```

## Month 4

You understand and can implement the main Transformer primitives.

## Month 5

You have a small autoregressive inference engine with:

```text
embedding
attention
RoPE
RMSNorm
MLP
KV cache
```

## Month 6

You have a credible single-GPU inference engine running on the W7900.

Only then does Objective 2 become the main focus.

---

# 12-Month Target

The desired skill level is not:

> I know HIP.

It is:

> I can inspect a GPU kernel, understand its memory behavior, estimate its bottleneck, confirm the hypothesis with profiling, modify the implementation, measure the effect, and explain why performance changed.

At that point, multi-GPU scheduling becomes a natural extension of skills you already understand deeply.

---

# Long-Term Professional Target

Develop the profile of a:

```text
GPU / AI Systems Engineer
with strong expertise in:
C
HIP / ROCm
GPU architecture
profiling
Transformer inference
kernel optimization
multi-GPU runtime design
```

The key principle throughout the entire roadmap is:

```text
understand
→ measure
→ explain
→ optimize
```

rather than:

```text
copy an optimization
→ observe that it is fast
```

The first approach builds expertise.

The second only builds code.