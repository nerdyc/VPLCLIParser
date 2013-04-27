#import "VPLCLITypes.h"

@interface VPLCLIMatcher : NSObject

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithIdentifier:(NSString *)identifier;

// ===== IDENTIFIER ====================================================================================================
#pragma mark - Identifier

@property (strong, readonly, VPLCLIAtomicity) NSString * identifier;

// ===== MATCH ARGUMENTS ===============================================================================================
#pragma mark - Match Arguments

- (VPLCLISegment *)matchArguments:(NSArray *)arguments
                          inRange:(NSRange)range;

@end
