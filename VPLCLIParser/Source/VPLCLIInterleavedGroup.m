#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLIInterleavedGroup.h"
#import "VPLCLIGroup+Protected.h"
#import "VPLCLISegment.h"

@implementation VPLCLIInterleavedGroup

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

+ (instancetype)interleavedGroupWithOptions:(NSArray *)options
{
  return [(VPLCLIInterleavedGroup *)[self alloc] initWithOptions:options];
}

// ===== USAGE STRING ==================================================================================================
#pragma mark - Usage String

- (NSString *)usageString
{
  NSMutableString * usageString = [[NSMutableString alloc] init];
  for (VPLCLIMatcher * matcher in self.options)
  {
    NSString * matcherUsageString = matcher.usageString;
    if ([matcherUsageString length] > 0)
    {
      if ([usageString length] > 0)
      {
        [usageString appendString:@" "];
      }
      
      [usageString appendString:matcherUsageString];
    }
  }
  return usageString;
}

// ===== MATCH ARGUMENTS ===============================================================================================
#pragma mark - Match Arguments

- (VPLCLISegment *)matchArguments:(NSArray *)arguments
                          inRange:(NSRange)range
{
  NSMutableArray * segments = [[NSMutableArray alloc] init];
  
  NSMutableIndexSet * indexesOfUnmatchedOptions =
    [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, [self.options count])];
  
  NSIndexSet * indexesOfRequiredOptions =
    [self.options indexesOfObjectsPassingTest:^(VPLCLIMatcher * matcher, NSUInteger idx, BOOL *stop) {
      return matcher.required;
    }];
  
  NSMutableIndexSet * indexesOfUnmatchedRequiredOptions =
    [[NSMutableIndexSet alloc] initWithIndexSet:indexesOfRequiredOptions];
  
  
  NSRange matchedRange = NSMakeRange(range.location, 0);
  NSRange remainingRange = range;
  while (remainingRange.length > 0)
  {
    __block VPLCLISegment * matchedSegment = nil;
    [self.options enumerateObjectsAtIndexes:indexesOfUnmatchedOptions
                                    options:0
                                 usingBlock:^(VPLCLIMatcher * matcher, NSUInteger idx, BOOL *stop) {
                                   
                                   matchedSegment = [matcher matchArguments:arguments
                                                                    inRange:remainingRange];
                                   if (matchedSegment != nil)
                                   {
                                     [indexesOfUnmatchedOptions removeIndex:idx];
                                     if (matcher.required)
                                     {
                                       [indexesOfUnmatchedRequiredOptions removeIndex:idx];
                                     }
                                     *stop = YES;
                                   }
                                   
                                 }];
    
    if (matchedSegment != nil)
    {
      [segments addObject:matchedSegment];
      
      NSUInteger numberOfMatchedArguments = matchedSegment.matchedRange.length;
      remainingRange.location += numberOfMatchedArguments;
      remainingRange.length -= numberOfMatchedArguments;
      matchedRange.length += numberOfMatchedArguments;
    }
    else if ([indexesOfUnmatchedRequiredOptions count] == 0)
    {
      break;
    }
    else
    {
      return nil;
    }
  }
  
  if ([indexesOfUnmatchedRequiredOptions count] == 0)
  {
    return [[VPLCLISegment alloc] initWithIdentifier:self.identifier
                                    matchedArguments:[arguments subarrayWithRange:range]
                                        matchedRange:matchedRange
                                               value:nil
                                            segments:segments];
  }
  else
  {
    return nil;
  }
}

@end
