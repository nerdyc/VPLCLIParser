#import "VPLCLISequence.h"
#import "VPLCLIGroup+Protected.h"
#import "VPLCLISegment.h"

@implementation VPLCLISequence

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

+ (instancetype)sequenceWithOptions:(NSArray *)options
{
  return [[VPLCLISequence alloc] initWithOptions:options];
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
  for (VPLCLIMatcher * matcher in self.options)
  {
    VPLCLISegment * segment = [matcher matchArguments:arguments
                                                    inRange:remainingRange];
    if (segment != nil)
    {
      [segments addObject:segment];
      
      NSUInteger numberOfMatchedArguments = segment.matchedRange.length;
      remainingRange.location += numberOfMatchedArguments;
      remainingRange.length -= numberOfMatchedArguments;
      matchedRange.length += numberOfMatchedArguments;
    }
    else
    {
      return nil;
    }
  }
  
  return [[VPLCLISegment alloc] initWithIdentifier:self.identifier
                                  matchedArguments:[arguments subarrayWithRange:range]
                                      matchedRange:matchedRange
                                             value:nil
                                          segments:segments];
}

@end
