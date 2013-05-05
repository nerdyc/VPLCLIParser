#import "VPLCLIGroup.h"

@interface VPLCLIGroup (ProtectedMethods)

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithOptions:(NSArray *)options;

- (id)initWithIdentifier:(NSString *)identifier
                 options:(NSArray *)options;

@end