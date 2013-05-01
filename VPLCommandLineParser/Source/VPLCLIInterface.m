#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLIInterface.h"
#import "VPLCLIMatcher.h"
#import "VPLCLIGroup.h"

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

@end
