#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLIInterface.h"
#import "VPLCLIMatcher.h"
#import "VPLCLIGroup.h"
#import "VPLCLIInterleavedGroup.h"
#import "VPLCLISegment.h"

@implementation VPLCLIInterface

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)init
{
  return [self initWithProcessName:[[NSProcessInfo processInfo] processName]
                           options:nil];
}

- (id)initWithProcessName:(NSString *)processName
{
  return [self initWithProcessName:processName
                           options:nil];
}

- (id)initWithProcessName:(NSString *)processName
                  options:(VPLCLIGroup *)options
{
  self = [super init];
  if (self != nil)
  {
    _processName = processName;
    _options = options;
  }
  return self;
}

// ===== INTERFACE DEFINITION ==========================================================================================
#pragma mark - Interface Definition

+ (instancetype)interfaceWithOptions:(NSArray *)options
{
  VPLCLIInterleavedGroup * interleavedOptions = [VPLCLIInterleavedGroup interleavedGroupWithOptions:options];
  
  return [[self alloc] initWithProcessName:[[NSProcessInfo processInfo] processName]
                                   options:interleavedOptions];
}

// ===== USAGE STRING ==================================================================================================
#pragma mark - Usage String

- (NSString *)usageString
{
  NSMutableString * usageString = [[NSMutableString alloc] initWithString:self.processName];
  
  VPLCLIMatcher * options = self.options;
  if (options != nil)
  {
    [usageString appendString:@" "];
    [usageString appendString:options.usageString];
  }
  
  return usageString;
}

- (NSString *)helpText
{
  NSMutableString * helpText = [[NSMutableString alloc] init];
  if (self.processTitle != nil)
  {
    [helpText appendString:self.processTitle];
    [helpText appendString:@"\n"];
  }
  else
  {
    [helpText appendString:self.processName];
    [helpText appendString:@"\n"];
  }
  
  if (self.processCopyright)
  {
    [helpText appendString:self.processCopyright];
    [helpText appendString:@"\n"];
  }
  
  if (self.processDescription)
  {
    [helpText appendString:self.processDescription];
    [helpText appendString:@"\n"];
  }

  [helpText appendString:@"\n"];
  [helpText appendString:@"Usage: "];
  [helpText appendString:self.usageString];

  return helpText;
}

// ===== PARSING =======================================================================================================
#pragma mark - Parsing

- (NSDictionary *)dictionaryFromProcessArguments
{
  NSArray * processArguments = [[NSProcessInfo processInfo] arguments];
  
  return [self dictionaryFromArguments:[processArguments subarrayWithRange:NSMakeRange(1, [processArguments count]-1)]];
}

- (NSDictionary *)dictionaryFromArguments:(NSArray *)commandLineArguments
{
  VPLCLISegment * segment = [self.options matchArguments:commandLineArguments
                                                 inRange:NSMakeRange(0, [commandLineArguments count])];
  if (segment != nil)
  {
    return [segment dictionaryOfSegmentValues];
  }
  else
  {
    return nil;
  }
}


@end
