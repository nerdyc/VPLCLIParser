#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLIChoiceGroup.h"
#import "VPLCLIGroup+Protected.h"

@implementation VPLCLIChoiceGroup

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

+ (instancetype)choiceGroupWithOptions:(NSArray *)options
{
  return [(VPLCLIChoiceGroup *)[self alloc] initWithOptions:options];
}

// ===== MATCHING ======================================================================================================
#pragma mark - Matching

- (VPLCLISegment *)matchArguments:(NSArray *)arguments
                          inRange:(NSRange)range
{
  for (VPLCLIMatcher * matcher in self.options)
  {
    VPLCLISegment * segment = [matcher matchArguments:arguments
                                              inRange:range];
    if (segment != nil)
    {
      return segment;
    }
  }
  
  return nil;
}

@end
