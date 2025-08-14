// blur_cpu.cpp
#include <opencv2/opencv.hpp>
#include <chrono>
#include <iostream>

int main() {
    cv::Mat input = cv::imread("images/input.jpg");
    if (input.empty()) {
        std::cout << "Failed to load image.\n";
        return -1;
    }

    cv::Mat output;
    auto start = std::chrono::high_resolution_clock::now();
    cv::GaussianBlur(input, output, cv::Size(5, 5), 0);
    auto end = std::chrono::high_resolution_clock::now();

    std::chrono::duration<double> elapsed = end - start;
    std::cout << "CPU blur took " << elapsed.count() << " seconds\n";

    cv::imwrite("images/output_cpu.jpg", output);
    return 0;
}
