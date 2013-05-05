#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR 
#define VPLCLIAtomicity nonatomic
#else
#define VPLCLIAtomicity atomic
#endif