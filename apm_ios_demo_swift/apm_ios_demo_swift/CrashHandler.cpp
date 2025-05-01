#include "CrashHandler.hpp"
#include <stdexcept>

using namespace std;

void triggerCppCrash() {
    // 方法 1：直接调用 abort() 终止程序
    throw std::runtime_error("Simulated C++ Exception");

    // 方法 2：访问空指针（未定义行为，可能导致崩溃）
    // int* ptr = nullptr;
    // *ptr = 42;

    // 方法 3：除以零（触发未定义行为）
    // int a = 1 / 0;
}
