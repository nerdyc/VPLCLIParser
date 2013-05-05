#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLIMatcher+SpecHelper.h"

@implementation VPLCLIMatcher (SpecHelper)

- (VPLCLISegment *)matchArguments:(NSArray *)arguments
{
  return [self matchArguments:arguments
                      inRange:NSMakeRange(0, [arguments count])];
}

@end
