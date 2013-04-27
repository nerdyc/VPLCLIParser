#import "VPLCLIMatcher.h"

@interface VPLCLIOption : VPLCLIMatcher

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithIdentifier:(NSString *)identifier
                longName:(NSString *)longName
                    flag:(NSString *)flag;

// ===== LONG NAME =====================================================================================================
#pragma mark - Long Name

@property (strong, readonly, VPLCLIAtomicity) NSString * longName;

// ===== FLAG ==========================================================================================================
#pragma mark - Flag

@property (strong, readonly, VPLCLIAtomicity) NSString * flag;

@end
