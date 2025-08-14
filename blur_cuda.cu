#include <iostream>
#include <opencv2/opencv.hpp>

__global__ void blurKernel(unsigned char* input, unsigned char* output, int width, int height, int channels) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x >= width || y >= height) return;

    for (int c = 0; c < channels; ++c) {
        int pixVal = 0;
        int pixels = 0;

        for (int dy = -1; dy <= 1; ++dy) {
            for (int dx = -1; dx <= 1; ++dx) {
                int nx = x + dx;
                int ny = y + dy;

                if (nx >= 0 && ny >= 0 && nx < width && ny < height) {
                    pixVal += input[(ny * width + nx) * channels + c];
                    pixels++;
                }
            }
        }

        output[(y * width + x) * channels + c] = pixVal / pixels;
    }
}

int main() {
    cv::Mat input = cv::imread("input.jpg", cv::IMREAD_COLOR);
    if (input.empty()) {
        std::cerr << "Image not found!\n";
        return -1;
    }

    int imgSize = input.rows * input.cols * input.channels();

    unsigned char *d_input, *d_output;
    cudaMalloc(&d_input, imgSize);
    cudaMalloc(&d_output, imgSize);

    cudaMemcpy(d_input, input.data, imgSize, cudaMemcpyHostToDevice);

    dim3 block(16, 16);
    dim3 grid((input.cols + 15) / 16, (input.rows + 15) / 16);

    blurKernel<<<grid, block>>>(d_input, d_output, input.cols, input.rows, input.channels());

    cv::Mat output(input.size(), input.type());
    cudaMemcpy(output.data, d_output, imgSize, cudaMemcpyDeviceToHost);

    cv::imwrite("output_cuda.jpg", output);

    cudaFree(d_input);
    cudaFree(d_output);

    std::cout << "CUDA blur completed.\n";
    return 0;
}
