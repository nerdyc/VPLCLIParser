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

// ===== USAGE STRING ==================================================================================================
#pragma mark - Usage String

- (NSString *)usageString
{
  NSMutableArray * usageStrings = [[NSMutableArray alloc] initWithCapacity:[self.options count]];

  for (VPLCLIMatcher * matcher in self.options)
  {
    NSString * matcherUsageString = matcher.usageString;
    if ([matcherUsageString length] > 0)
    {
      [usageStrings addObject:matcherUsageString];
    }
  }
  
  return [NSString stringWithFormat:@"(%@)", [usageStrings componentsJoinedByString:@" | "]];
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
