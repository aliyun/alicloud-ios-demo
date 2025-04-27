#ifndef CrashHandler_hpp
#define CrashHandler_hpp

// 使用条件编译处理 extern "C"
#ifdef __cplusplus
extern "C" {
#endif

// 声明 C 风格的函数
void triggerCppCrash();

#ifdef __cplusplus
}
#endif

#endif /* CrashHandler_h */
