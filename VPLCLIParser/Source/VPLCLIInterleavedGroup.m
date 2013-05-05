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
  
  NSRange matchedRange = NSMakeRange(range.location, 0);
  NSRange remainingRange = range;
  while (remainingRange.length > 0)
  {
    VPLCLISegment * segment = nil;
    for (VPLCLIMatcher * matcher in self.options)
    {
      segment = [matcher matchArguments:arguments
                                inRange:remainingRange];
      if (segment != nil)
      {
        [segments addObject:segment];
        
        NSUInteger numberOfMatchedArguments = segment.matchedRange.length;
        remainingRange.location += numberOfMatchedArguments;
        remainingRange.length -= numberOfMatchedArguments;
        matchedRange.length += numberOfMatchedArguments;
        
        break;
      }
    }
    
    // stop matching if a segment wasn't matched
    if (segment == nil)
    {
      break;
    }
  }
  
  if ([segments count] > 0)
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
