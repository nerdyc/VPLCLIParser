#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLIMatcher.h"

@implementation VPLCLIMatcher

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)init
{
  return [self initWithIdentifier:nil];
}

- (id)initWithIdentifier:(NSString *)identifier
{
  self = [super init];
  if (self != nil)
  {
    _identifier = identifier;
  }
  return self;
}

// ===== USAGE STRING ==================================================================================================
#pragma mark - Usage String

- (NSString *)usageString
{
  VPL_ABSTRACT_METHOD;
  return nil;
}

// ===== MATCH ARGUMENTS ===============================================================================================
#pragma mark - Match Arguments

- (VPLCLISegment *)matchArguments:(NSArray *)arguments
                              inRange:(NSRange)range
{
  VPL_ABSTRACT_METHOD;
  return nil;
}

@end
