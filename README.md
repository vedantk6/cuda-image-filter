# CUDA-Accelerated Image Blur

## 🚀 Project Summary
This project implements Gaussian blur using CUDA C++ and compares it to a CPU OpenCV baseline. It demonstrates GPU parallelism, memory access optimization, and CUDA performance profiling.

## ⚙️ Tools Used
- CUDA C++
- OpenCV
- Nsight Systems / nvprof

## 🧪 Results
| Version | Time (s) | Speedup |
|---------|----------|---------|
| CPU     | 0.45     | 1.0x    |
| GPU     | 0.02     | 22.5x   |

## 📷 Output
![CPU Blur](images/output_cpu.jpg)
![GPU Blur](images/output_cuda.jpg)

## 🧠 Learnings
- GPU memory coalescing improves throughput
- Shared memory boosts performance
- Thread indexing must handle edge cases
