#import "VPLCLIOption.h"
#import "VPLCLISegment.h"

@implementation VPLCLIOption

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithIdentifier:(NSString *)identifier
{
  return [self initWithIdentifier:identifier
                         longName:identifier
                             flag:nil];
}

- (id)initWithIdentifier:(NSString *)identifier
                longName:(NSString *)longName
                    flag:(NSString *)flag
{
  self = [super initWithIdentifier:identifier];
  if (self != nil)
  {
    _longName = longName;
    _flag = flag;
  }
  return self;
}

+ (instancetype)optionWithName:(NSString *)name
{
  return [[self alloc] initWithIdentifier:name
                                 longName:name
                                     flag:nil];
}

+ (instancetype)optionWithName:(NSString *)name
                          flag:(NSString *)flag
{
  return [[self alloc] initWithIdentifier:name
                                 longName:name
                                     flag:flag];
}


// ===== USAGE STRING ==================================================================================================
#pragma mark - Usage String

- (NSString *)usageString
{
  if (self.longName != nil)
  {
    return [NSString stringWithFormat:@"--%@", self.longName];
  }
  else if (self.flag != nil)
  {
    return [NSString stringWithFormat:@"-%@", self.flag];
  }
  else
  {
    return @"";
  }
}

// ===== MATCH ARGUMENTS ===============================================================================================
#pragma mark - Match Arguments

- (VPLCLISegment *)matchArguments:(NSArray *)arguments
                              inRange:(NSRange)range
{
  NSString * leadingArgument = arguments[range.location];
  if ([leadingArgument hasPrefix:@"--"])
  {
    NSString * longOptionName = [leadingArgument substringFromIndex:2];
    if ([longOptionName isEqualToString:self.longName])
    {
      return [[VPLCLISegment alloc] initWithIdentifier:self.identifier
                                      matchedArguments:@[ leadingArgument ]
                                          matchedRange:NSMakeRange(range.location, 1)
                                                 value:[NSNull null]];
    }
  }
  else if ([leadingArgument hasPrefix:@"-"])
  {
    NSString * shortOptionName = [leadingArgument substringFromIndex:1];
    if ([shortOptionName isEqualToString:self.flag])
      
    {
      return [[VPLCLISegment alloc] initWithIdentifier:self.identifier
                                      matchedArguments:@[ leadingArgument ]
                                          matchedRange:NSMakeRange(range.location, 1)
                                                 value:[NSNull null]];
    }
  }
  
  return nil;
}

@end
