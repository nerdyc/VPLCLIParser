#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLISwitchGroup.h"
#import "VPLCLIGroup+Protected.h"
#import "VPLCLISegment.h"

@implementation VPLCLISwitchGroup

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithCaseIdentifier:(NSString *)caseIdentifier
                       cases:(NSDictionary *)cases
{
  self = [super initWithIdentifier:nil
                           options:@[]];
  if (self != nil)
  {
    _caseIdentifier = caseIdentifier;
    _cases = cases;
  }
  return self;
}

// ===== USAGE STRING ==================================================================================================
#pragma mark - Usage String

- (NSString *)usageString
{
  NSMutableString * usageString = [[NSMutableString alloc] init];
  
  NSArray * orderedCaseNames = [[self.cases allKeys] sortedArrayUsingSelector:@selector(compare:)];
  for (NSString * caseName in orderedCaseNames)
  {
    VPLCLIMatcher * caseOptions = self.cases[caseName];
    if ([usageString length] > 0)
    {
      [usageString appendString:@" | "];
    }
    
    NSString * caseOptionsUsageString = caseOptions.usageString;
    if ([caseOptionsUsageString length] > 0)
    {
      [usageString appendString:caseName];

      [usageString appendString:@" "];
      [usageString appendString:caseOptionsUsageString];
    }
    else
    {
      [usageString appendString:caseName];
    }
  }
  
  return [NSString stringWithFormat:@"(%@)", usageString];
}

// ===== MATCHING ======================================================================================================
#pragma mark - Matching

- (VPLCLISegment *)matchArguments:(NSArray *)arguments
                          inRange:(NSRange)range
{
  NSString * firstArgument = arguments[range.location];
  VPLCLIMatcher * caseMatcher = self.cases[firstArgument];
  if (caseMatcher != nil)
  {
    VPLCLISegment * commandNameSegment = [[VPLCLISegment alloc] initWithIdentifier:self.caseIdentifier
                                                                  matchedArguments:@[ firstArgument ]
                                                                      matchedRange:NSMakeRange(range.location, 1)
                                                                             value:firstArgument
                                                                          segments:@[]];
    
    NSRange caseArgumentRange = range;
    caseArgumentRange.location += 1;
    caseArgumentRange.length -= 1;
  
    VPLCLISegment * commandOptionsSegment = [caseMatcher matchArguments:arguments
                                                         inRange:caseArgumentRange];
    if (commandOptionsSegment != nil)
    {
      NSRange matchedRange = NSMakeRange(range.location, commandOptionsSegment.matchedRange.length + 1);
      
      return [[VPLCLISegment alloc] initWithIdentifier:self.identifier
                                      matchedArguments:[arguments subarrayWithRange:matchedRange]
                                          matchedRange:matchedRange
                                                 value:nil
                                              segments:@[ commandNameSegment, commandOptionsSegment ]];
    }
    else
    {
      return nil;
    }
  }
  else
  {
    return nil;
  }
}

@end
