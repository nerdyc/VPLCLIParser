#import <SenTestingKit/SenTestingKit.h>
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"


#define VPL_SPEC_ERROR(__MESSAGE__, __ERROR__) [NSException raise:NSInternalInconsistencyException \
                                                           format:@"%@: %@; reason: %@", \
                                                                  (__MESSAGE__), \
                                                                  [(__ERROR__) localizedDescription], \
                                                                  [(__ERROR__) localizedFailureReason]]

#import "VPLCLIParser.h"

#import "VPLCLIMatcher+SpecHelper.h"