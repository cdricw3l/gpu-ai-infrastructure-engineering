# System Administration Roadmap for GPU and AI Inference Infrastructure

## General Goal

Build strong Linux and systems administration expertise specifically for GPU computing, ROCm, AI inference, and future multi-GPU infrastructure.

The objective is not to become a generic system administrator.

The objective is to become capable of understanding and operating the complete stack:

```text id="a11xsy"
hardware
  ↓
firmware
  ↓
Linux kernel
  ↓
PCIe / NUMA
  ↓
ROCm
  ↓
GPU runtime
  ↓
inference engine
  ↓
monitoring
  ↓
performance analysis
```

This roadmap is designed to complement a GPU development roadmap focused on:

```text id="imny3r"
C
HIP
ROCm
GPU architecture
profiling
Transformers
inference
multi-GPU
```

---

# Core Professional Target

Develop the profile of a:

```text id="6qgv8g"
Linux / GPU Systems Engineer
specialized in
AI inference infrastructure
```

with strong knowledge of:

- Linux administration;
- Linux internals;
- CPU and memory topology;
- NUMA;
- PCIe;
- kernel modules;
- ROCm;
- GPU device management;
- observability;
- storage;
- networking;
- process isolation;
- containers;
- performance tuning;
- multi-GPU infrastructure.

---

# Learning Principle

Every system topic should be connected to the GPU project.

The learning cycle should be:

```text id="7ep9u6"
understand
→ inspect
→ modify
→ measure
→ document
```

Avoid learning system administration only through commands.

Always understand:

```text id="j02kd8"
what subsystem is being observed?
what kernel interface exposes it?
what changes when the configuration changes?
how does it affect GPU inference?
```

---

# Objective 1 — Master the Host System for the Existing W7900

Before adding additional GPUs, fully understand the machine hosting the W7900.

The goal is to be able to explain:

- how Linux sees the GPU;
- how the GPU is attached through PCIe;
- which NUMA node is associated with it;
- which kernel modules manage it;
- how ROCm accesses it;
- how processes interact with `/dev/kfd`;
- how CPU memory placement can affect GPU workloads;
- how storage and CPU bottlenecks can affect inference.

---

# Phase 1 — Linux System Foundations

## Estimated duration

Weeks 1–4.

## Learn

### Filesystem hierarchy

Understand:

```text id="7pvxp3"
/boot
/dev
/etc
/home
/proc
/sys
/tmp
/usr
/var
```

Pay particular attention to:

```text id="mqej3c"
/proc
/sys
/dev
```

because they expose a large part of the hardware and kernel state.

---

## Process management

Learn:

```text id="qknzgi"
ps
top
htop
pgrep
pkill
nice
renice
taskset
```

Understand:

```text id="5l3mbc"
PID
PPID
threads
process states
signals
priority
CPU affinity
```

---

## Basic system inspection

Become comfortable with:

```text id="9rh6ji"
uname
hostnamectl
lsmod
lscpu
lsblk
lspci
free
vmstat
dmesg
journalctl
```

The objective is to be able to inspect a machine without relying on a graphical interface.

---

# Phase 2 — Linux Kernel and Device Model

## Goal

Understand how Linux represents hardware.

Study:

```text id="jgg5fu"
kernel modules
device files
udev
sysfs
procfs
major/minor device numbers
```

Inspect:

```text id="vwysvm"
/sys/class
/sys/bus
/sys/devices
/dev/dri
/dev/kfd
```

Learn to answer:

> Which kernel module owns my GPU?

> Which PCI device corresponds to the W7900?

> Which device nodes are exposed to user space?

> Which permissions control GPU access?

---

# Phase 3 — GPU Driver Stack

Understand the complete software path:

```text id="15jkq6"
application
   ↓
HIP runtime
   ↓
ROCm libraries
   ↓
user-space driver stack
   ↓
amdgpu kernel driver
   ↓
GPU
```

Study:

```text id="h0gh4c"
amdgpu
kfd
DRM
/dev/dri
/dev/kfd
```

Inspect loaded modules:

```bash id="h3uqf0"
lsmod | grep amdgpu
```

Inspect GPU-related kernel logs:

```bash id="rh9pqb"
dmesg | grep -i amdgpu
```

and:

```bash id="6ab7ye"
journalctl -k
```

---

# Phase 4 — PCIe Fundamentals

## Goal

Understand exactly how the GPU is connected to the system.

Learn:

```text id="jbd14q"
PCIe generations
lanes
x16
x8
x4
root complex
PCIe switches
link speed
link width
BAR
Resizable BAR
IOMMU
```

Use:

```bash id="hftn3f"
lspci -tv
```

and:

```bash id="5fd9qi"
lspci -vv
```

Identify the W7900.

Record:

```text id="kzq61u"
PCI address
link speed
link width
NUMA node
IOMMU group
BAR sizes
```

---

# Phase 5 — NUMA

NUMA knowledge becomes critical for multi-GPU systems.

Learn:

```text id="6c058f"
NUMA node
local memory
remote memory
CPU socket
memory controller
CPU affinity
memory affinity
```

Use:

```bash id="xx8fu9"
numactl --hardware
```

and:

```bash id="owm8fd"
lscpu -e
```

Inspect:

```text id="a2veae"
/sys/devices/system/node/
```

Determine which NUMA node is closest to the W7900.

---

# Phase 6 — CPU Affinity

Experiment with:

```bash id="me1wv7"
taskset
```

and:

```bash id="x0vru6"
numactl
```

Compare inference performance with:

```text id="qnsr3k"
default CPU placement
CPU pinned to local NUMA node
CPU pinned to remote NUMA node
```

Measure:

```text id="czn316"
tokens/s
CPU usage
latency
memory bandwidth
```

Document the differences.

---

# Phase 7 — System Memory

Understand:

```text id="aai3hc"
virtual memory
physical memory
page cache
anonymous memory
mmap
swap
page faults
huge pages
```

Learn:

```bash id="fuc2yn"
free -h
vmstat
cat /proc/meminfo
```

Inspect process memory with:

```bash id="3mu6sv"
pmap
```

and:

```text id="hq9px2"
/proc/<pid>/smaps
```

---

# Phase 8 — mmap and Model Loading

Because inference engines often load large model files, study:

```text id="z9wyl6"
open
read
mmap
munmap
page faults
page cache
```

Write a small C program that compares:

```text id="mx3hlf"
read()
vs
mmap()
```

for loading large files.

Measure:

```text id="fo5vpb"
startup time
RAM usage
page faults
filesystem cache behavior
```

This directly connects C systems programming to model loading.

---

# Phase 9 — Huge Pages

Learn the difference between:

```text id="i20xaz"
4 KiB pages
2 MiB huge pages
1 GiB huge pages
Transparent Huge Pages
```

Inspect:

```bash id="90fcrq"
cat /sys/kernel/mm/transparent_hugepage/enabled
```

and:

```bash id="dh90vm"
grep Huge /proc/meminfo
```

Test whether huge pages affect your CPU-side model loading or memory management.

Do not assume they improve performance.

Measure.

---

# Phase 10 — Swap Behavior

Understand:

```text id="ghny64"
swap
swappiness
memory pressure
OOM killer
```

Inspect:

```bash id="n73s5u"
swapon --show
```

and:

```bash id="xsw91r"
sysctl vm.swappiness
```

Understand why swap activity during inference can destroy latency.

Create memory pressure tests and observe:

```text id="v69h5v"
latency
page faults
swap activity
system responsiveness
```

---

# Phase 11 — Storage

Large models make storage important.

Learn:

```text id="9dk3px"
SATA
NVMe
PCIe NVMe
IOPS
sequential throughput
random throughput
queue depth
filesystem cache
```

Use:

```text id="8vpc20"
lsblk
nvme
iostat
```

Benchmark storage with appropriate tools.

Record:

```text id="rdz2ye"
sequential read speed
random read speed
model load time
```

---

# Phase 12 — Filesystems

Understand basic characteristics of:

```text id="o5q5uk"
ext4
XFS
Btrfs
```

Focus on:

```text id="dnoeav"
reliability
large files
metadata behavior
snapshots
performance
```

Do not optimize filesystem choice prematurely.

The goal is to understand operational tradeoffs.

---

# Phase 13 — System Logging

Become comfortable with:

```text id="5bcofr"
journalctl
dmesg
systemd journal
kernel logs
service logs
```

Create a habit of correlating GPU problems with kernel logs.

Example diagnostic workflow:

```text id="1438cq"
application failure
      ↓
ROCm error
      ↓
journalctl
      ↓
kernel message
      ↓
PCIe / amdgpu investigation
```

---

# Phase 14 — systemd

Learn:

```text id="k9tdeh"
systemctl
service units
targets
dependencies
environment variables
restart policies
resource limits
```

Create a systemd service for your future inference engine.

Example:

```text id="b6bsbf"
inference-engine.service
```

It should eventually manage:

```text id="h35g92"
startup
restart
logs
permissions
environment
ROCm variables
```

---

# Phase 15 — Resource Limits

Study:

```text id="2khe9e"
ulimit
RLIMIT
locked memory
open file descriptors
process limits
```

Inspect:

```bash id="9nb5sj"
ulimit -a
```

Understand how process resource limits can affect GPU applications.

---

# Phase 16 — Permissions and Security

Understand:

```text id="4wawrl"
users
groups
permissions
ACLs
udev rules
```

Investigate permissions for:

```text id="3knrb8"
/dev/kfd
/dev/dri/*
```

Create a dedicated user for the inference service.

Avoid running the inference engine as root.

---

# Phase 17 — GPU Monitoring

Build monitoring around the W7900.

Track:

```text id="cy65su"
GPU utilization
VRAM usage
temperature
power
clock frequencies
fan speed
```

Combine GPU metrics with:

```text id="xmw6e1"
CPU usage
RAM
disk
network
```

Create a simple logging script.

Example output:

```text id="31swry"
timestamp
gpu_util
vram_used
gpu_power
gpu_temp
cpu_usage
ram_used
tokens_per_second
```

---

# Phase 18 — Performance Correlation

Correlate application performance with system metrics.

For every inference benchmark record:

```text id="4otcrd"
tokens/s
latency/token

GPU utilization
GPU power
VRAM

CPU utilization
RAM

disk activity

PCIe behavior
```

The goal is to understand whether the application is limited by:

```text id="2p3o80"
GPU compute
GPU memory
CPU
RAM
PCIe
storage
```

---

# Phase 19 — perf and Low-Level CPU Profiling

Learn:

```bash id="hooi81"
perf stat
perf record
perf report
```

Use CPU profiling for:

```text id="r6ujjd"
tokenization
model loading
tensor preparation
scheduler code
memory management
```

Your GPU engine can still have significant CPU bottlenecks.

---

# Phase 20 — strace

Use:

```bash id="4ze83p"
strace
```

to inspect:

```text id="c9gf57"
file access
memory mapping
device access
threads
synchronization
```

This is especially useful for understanding:

```text id="v2xosp"
model loading
ROCm device initialization
configuration files
system calls
```

---

# Phase 21 — Valgrind and Sanitizers

Continue using Valgrind for CPU-side code.

Also learn:

```text id="4ttang"
AddressSanitizer
UndefinedBehaviorSanitizer
```

Use them for:

```text id="m7f127"
memory leaks
use-after-free
buffer overflows
undefined behavior
```

Keep GPU allocation tracking separate.

---

# Phase 22 — Networking Fundamentals

Before distributed inference, learn:

```text id="5c1naz"
TCP/IP
routing
DNS
ports
MTU
latency
bandwidth
```

Use:

```text id="vsjiy0"
ip
ss
ping
traceroute
```

and network benchmark tools.

Understand the difference between:

```text id="pmdecy"
latency-sensitive traffic
bandwidth-sensitive traffic
```

---

# Phase 23 — Remote Administration

Learn secure remote operation using:

```text id="34iyz1"
SSH
SSH keys
agent forwarding
port forwarding
scp
rsync
```

Create a workflow where the GPU machine can be operated remotely without graphical access.

---

# Phase 24 — Service Exposure

When the inference engine becomes usable, expose it through a small API.

Learn:

```text id="z7dxku"
listening sockets
localhost
firewall
reverse proxy
TLS
```

The goal is not web development.

The goal is safe service operation.

---

# Phase 25 — Firewall

Understand:

```text id="xpbw7f"
nftables
firewalld
```

Only expose required services.

For example:

```text id="lt2o74"
SSH
inference API
monitoring
```

---

# Objective 1 System Administration Final Project

Operate the W7900 machine as a dedicated inference server.

The system should have:

```text id="0epvwf"
stable Linux installation
ROCm
GPU monitoring
systemd-managed inference service
dedicated service user
structured logs
CPU affinity configuration
NUMA documentation
PCIe documentation
storage benchmarks
memory benchmarks
GPU benchmarks
backup strategy
```

Create a machine profile:

```text id="ddvghs"
hardware.md
```

containing:

```text id="atjqhm"
CPU
RAM
NUMA topology
motherboard
PCIe topology
W7900 slot
NVMe topology
network interface
power supply
kernel version
ROCm version
```

---

# Objective 2 — Prepare for Multi-GPU Administration

Once additional GPUs are installed, system administration becomes much more important.

The host system must now be treated as a GPU platform rather than a desktop.

---

# Phase 26 — Multi-GPU PCIe Topology

For each GPU record:

```text id="6el9wl"
PCI address
slot
link width
link speed
NUMA node
IOMMU group
root complex
```

Build a topology map.

Example:

```text id="y7wlsh"
CPU / NUMA 0
├── W7900
└── R9700 #0

CPU / NUMA 1
└── R9700 #1
```

The exact topology must be discovered from the machine.

Never assume it.

---

# Phase 27 — NUMA-Aware GPU Scheduling

Correlate GPUs with CPU NUMA nodes.

Test:

```text id="uug3xd"
GPU workload
+
local CPU threads
```

against:

```text id="aw64hn"
GPU workload
+
remote CPU threads
```

Measure:

```text id="dc7ad3"
latency
CPU overhead
PCIe transfer performance
tokens/s
```

---

# Phase 28 — IOMMU

Understand:

```text id="y9r35d"
IOMMU
DMA
IOMMU groups
device isolation
```

Inspect:

```text id="rfbynz"
/sys/kernel/iommu_groups/
```

Understand its relevance to:

```text id="vn26kf"
virtualization
device passthrough
DMA protection
GPU topology
```

---

# Phase 29 — PCIe Contention

With multiple GPUs, benchmark:

```text id="d8d7x8"
GPU0 → GPU1
GPU0 → GPU2
GPU1 → GPU2
```

Then run simultaneous transfers.

Measure whether links share bottlenecks.

Example:

```text id="sse11d"
single transfer bandwidth
vs
two simultaneous transfers
```

This is essential for interpreting multi-GPU inference performance.

---

# Phase 30 — Power and Thermals

Three high-end GPUs can place very large demands on:

```text id="mmnplp"
power supply
motherboard
airflow
room cooling
```

Monitor:

```text id="kyif0o"
GPU temperature
junction temperature
power
clock frequency
throttling
```

Also inspect CPU and motherboard temperatures.

Document thermal behavior during sustained inference.

---

# Phase 31 — Stability Testing

Create long-running tests.

Examples:

```text id="x7q5co"
1 hour
6 hours
24 hours
```

Monitor:

```text id="8wtfqz"
GPU errors
driver resets
memory growth
temperature
power
tokens/s drift
system logs
```

A production GPU system must remain stable under sustained load.

---

# Phase 32 — GPU Failure Recovery

Study what happens when:

```text id="q8ps5s"
a GPU process crashes
ROCm fails
a kernel hangs
a GPU resets
the inference service crashes
```

Create recovery procedures.

Document:

```text id="vhvfmu"
diagnosis
restart
service recovery
log locations
reboot criteria
```

---

# Phase 33 — cgroups

Learn:

```text id="xzl1mj"
cgroups v2
CPU limits
memory limits
process grouping
```

Use cgroups to isolate:

```text id="gvvl04"
inference service
monitoring
benchmark jobs
development workloads
```

---

# Phase 34 — Containers

Only after the host is well understood, study containers.

Learn:

```text id="5rnwpk"
namespaces
cgroups
container images
bind mounts
device access
```

Then experiment with:

```text id="tw9tz0"
Docker
or
Podman
```

The objective is to containerize the inference service without losing GPU access.

---

# Phase 35 — ROCm Inside Containers

Understand how GPU devices are exposed into containers.

Validate:

```text id="6m79ci"
/dev/kfd
/dev/dri
ROCm libraries
permissions
```

Measure whether containerization changes performance.

---

# Phase 36 — Reproducible Environments

Create versioned environment documentation.

Track:

```text id="kiu1fs"
Linux distribution
kernel version
ROCm version
compiler version
runtime libraries
model version
engine commit
```

Create:

```text id="3zuqon"
environment.md
```

and ideally scripts for reproducible installation.

---

# Phase 37 — Configuration Management

Once manual administration is understood, automate it.

Start with shell scripts.

Later consider:

```text id="84rpje"
Ansible
```

Automate:

```text id="inju1d"
ROCm setup
service installation
user creation
permissions
monitoring
configuration files
```

Do not automate a system you do not yet understand manually.

---

# Phase 38 — Monitoring Stack

Build a small observability system.

Possible metrics:

```text id="9d8a9j"
CPU
RAM
disk
network

GPU utilization
GPU memory
power
temperature

inference latency
tokens/s
queue depth
KV cache
```

Possible architecture:

```text id="sl7gmx"
GPU machine
   ↓
metrics exporter
   ↓
time-series database
   ↓
dashboard
```

The exact tools are secondary.

Understanding the metrics is more important.

---

# Phase 39 — Alerting

Create alerts for meaningful failures.

Examples:

```text id="ku6l6x"
GPU temperature too high
VRAM exhaustion
disk almost full
service down
kernel GPU error
abnormal latency
```

Avoid alerting on every small fluctuation.

---

# Phase 40 — Backup and Recovery

Back up:

```text id="6o133s"
configuration
source code
benchmark results
system documentation
service files
scripts
```

Models can often be downloaded again.

Your configuration and measurements are more valuable.

---

# Phase 41 — Infrastructure Documentation

Maintain:

```text id="3rn5z3"
docs/
├── hardware.md
├── pcie_topology.md
├── numa.md
├── rocm.md
├── storage.md
├── networking.md
├── monitoring.md
├── recovery.md
└── benchmarks.md
```

Documentation should become part of the engineering process.

---

# Phase 42 — Connect System Metrics to the Inference Scheduler

This is where system administration and GPU development merge.

Expose system information to the inference engine.

For example:

```text id="91l9if"
GPU VRAM
GPU utilization
PCIe bandwidth
NUMA node
CPU load
memory pressure
temperature
```

The scheduler can eventually use these signals.

Conceptually:

```text id="86ytlb"
scheduler decision =
GPU performance
+
PCIe cost
+
NUMA locality
+
VRAM pressure
+
system load
```

---

# Phase 43 — Topology-Aware Runtime

The final runtime should understand:

```text id="fno2dl"
CPU topology
NUMA topology
GPU topology
PCIe topology
memory pressure
device performance
```

Example:

```text id="lxvzf5"
              Runtime
                 │
      ┌──────────┼──────────┐
      │          │          │
     CPU        PCIe       GPU
   topology    topology    metrics
      │          │          │
      └──────────┼──────────┘
                 │
             Scheduler
```

This is the point where systems administration directly improves inference performance.

---

# Weekly Practice Structure

Recommended weekly split:

```text id="pezlxu"
40% Linux / system administration
30% GPU / ROCm systems
20% benchmarking and profiling
10% documentation
```

While working on the inference engine, gradually shift toward:

```text id="u9ltd3"
30% system administration
40% GPU / inference
20% performance analysis
10% documentation
```

---

# Practical Lab Ideas

Build small labs around real problems.

## Lab 1

Map the W7900 from:

```text id="2yrjwc"
lspci
→ sysfs
→ /dev/dri
→ /dev/kfd
→ ROCm
```

---

## Lab 2

Measure inference with different CPU affinities.

---

## Lab 3

Measure model loading from cold and warm filesystem cache.

---

## Lab 4

Generate memory pressure and observe inference latency.

---

## Lab 5

Compare local and remote NUMA memory.

---

## Lab 6

Benchmark PCIe transfers.

---

## Lab 7

Run the inference engine as a systemd service.

---

## Lab 8

Crash the service and verify automatic recovery.

---

## Lab 9

Monitor GPU temperature, power, and tokens/s together.

---

## Lab 10

Containerize the engine and compare performance against native execution.

---

# Milestones

## After 1 month

You should understand:

```text id="gt06kb"
Linux processes
system logs
kernel modules
device files
/proc
/sys
```

---

## After 2 months

You should understand:

```text id="0db2ag"
PCIe
NUMA
CPU affinity
memory placement
```

---

## After 3 months

You should be able to diagnose:

```text id="uqn23u"
ROCm initialization problems
GPU permissions
driver errors
CPU bottlenecks
memory pressure
```

---

## After 4 months

You should operate the W7900 as a stable inference server.

---

## After 6 months

You should understand enough Linux and hardware topology to add multiple GPUs intelligently.

---

## After 9 months

You should be comfortable with:

```text id="g68nzp"
multi-GPU topology
NUMA placement
PCIe contention
monitoring
containers
service isolation
```

---

## After 12 months

You should be capable of operating and debugging a multi-GPU inference machine from:

```text id="hnkd98"
kernel
→ hardware
→ ROCm
→ runtime
→ application
```

rather than treating each layer independently.

---

# Final Project

Build and operate a complete AI inference host.

The system should contain:

```text id="dng6k3"
Linux
│
├── tuned host configuration
│
├── ROCm
│
├── GPU monitoring
│
├── system monitoring
│
├── inference engine
│
├── systemd service
│
├── benchmark suite
│
├── topology discovery
│
├── NUMA-aware execution
│
├── PCIe measurements
│
├── logs
│
└── recovery procedures
```

Later extend it to:

```text id="bjxnzg"
W7900
+
R9700
+
R9700
```

with the host system exposing topology and performance information to the heterogeneous inference scheduler.

---

# Long-Term Skill Target

The target is not:

> I know Linux administration.

It is:

> I can understand, operate, measure, debug, and optimize the complete Linux-to-GPU stack of an AI inference system.

The desired professional profile becomes:

```text id="86wt89"
Linux Systems
+
C
+
ROCm / HIP
+
GPU Architecture
+
Performance Engineering
+
Transformer Inference
+
Multi-GPU Infrastructure
```

That combination is the core specialization.

---

# Guiding Principle

Always ask:

```text id="edzkyz"
Where is the bottleneck?

CPU?
RAM?
NUMA?
PCIe?
GPU?
VRAM?
storage?
kernel?
driver?
application?
```

Then:

```text id="y2otx5"
observe
→ measure
→ isolate
→ test
→ document
→ optimize
```

This is the systems mindset that should support the entire GPU inference project.