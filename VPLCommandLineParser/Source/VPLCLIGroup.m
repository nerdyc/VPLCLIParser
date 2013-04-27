#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLIGroup+Protected.h"

@implementation VPLCLIGroup

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)init
{
  return [self initWithOptions:@[]];
}

- (id)initWithOptions:(NSArray *)options
{
  return [self initWithIdentifier:nil
                          options:options];
}

- (id)initWithIdentifier:(NSString *)identifier
                 options:(NSArray *)options
{
  self = [super initWithIdentifier:identifier];
  if (self != nil)
  {
    _options = options;
  }
  return self;
}

@end
