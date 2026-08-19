/*
 * MetalChams for Critical Ops (iOS)
 * Enemy highlight wallhack via Metal shader source patching.
 *
 * Based on the shader-hooking technique by Scared1892:
 *   https://github.com/Scared1892/MetalChams-iOS
 */

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <objc/runtime.h>
#include <string>

static id (*orig_newLibraryWithSource)(id, SEL, NSString *, MTLCompileOptions *, NSError * __autoreleasing *);

static id hook_newLibraryWithSource(id self, SEL _cmd, NSString *source, MTLCompileOptions *options, NSError * __autoreleasing *error) {
    @try {
        const char *src = [source UTF8String];
        if (src && source.length > 50) {

            if (strstr(src, "_HighlightGradientHeight") != nullptr &&
                strstr(src, "return output;") != nullptr) {

                std::string cpp(src);
                size_t pos = cpp.find("return output;");
                if (pos != std::string::npos) {
                    cpp.insert(pos, "output.mtl_Position.z = output.mtl_Position.w;\n");
                    source = [NSString stringWithUTF8String:cpp.c_str()];
                }
            }
        }
    } @catch(NSException *e) {}
    return orig_newLibraryWithSource(self, _cmd, source, options, error);
}

static void hook_sel(Class cls, SEL sel, IMP new_imp, IMP *orig_ptr) {
    Method m = class_getInstanceMethod(cls, sel);
    if (!m) return;
    *orig_ptr = method_getImplementation(m);
    method_setImplementation(m, new_imp);
}

__attribute__((constructor))
static void init() {
    Class device = objc_getClass("_MTLDevice");
    if (!device) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            Class d = objc_getClass("_MTLDevice");
            if (d) {
                hook_sel(d, @selector(newLibraryWithSource:options:error:), (IMP)hook_newLibraryWithSource, (IMP *)&orig_newLibraryWithSource);
            }
        });
        return;
    }
    hook_sel(device, @selector(newLibraryWithSource:options:error:), (IMP)hook_newLibraryWithSource, (IMP *)&orig_newLibraryWithSource);
}
