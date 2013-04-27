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
