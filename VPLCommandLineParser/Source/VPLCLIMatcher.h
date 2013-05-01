#import "VPLCLITypes.h"

@class VPLCLISegment;

@interface VPLCLIMatcher : NSObject

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithIdentifier:(NSString *)identifier;

// ===== IDENTIFIER ====================================================================================================
#pragma mark - Identifier

@property (strong, readonly, VPLCLIAtomicity) NSString * identifier;

// ===== USAGE STRING ==================================================================================================
#pragma mark - Usage String

@property (strong, readonly, VPLCLIAtomicity) NSString * usageString;

// ===== MATCH ARGUMENTS ===============================================================================================
#pragma mark - Match Arguments

- (VPLCLISegment *)matchArguments:(NSArray *)arguments
                          inRange:(NSRange)range;

@end
