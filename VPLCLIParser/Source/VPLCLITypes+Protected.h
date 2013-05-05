#import "VPLCLITypes.h"

#define VPL_UNIMPLEMENTED_METHOD [NSException raise:NSInternalInconsistencyException \
                                             format:@"[%@ %@] has not been implemented", \
                                                    NSStringFromClass([self class]), \
                                                    NSStringFromSelector(_cmd)]

#define VPL_ABSTRACT_METHOD [NSException raise:NSInternalInconsistencyException \
                                        format:@"[%@ %@] is abstract and must be implemented", \
                                               NSStringFromClass([self class]), \
                                               NSStringFromSelector(_cmd)]