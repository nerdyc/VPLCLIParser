#import "VPLCLIMatcher.h"

@interface VPLCLIOption : VPLCLIMatcher

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithIdentifier:(NSString *)identifier
                longName:(NSString *)longName
                    flag:(NSString *)flag
                required:(BOOL)required;

+ (instancetype)optionWithName:(NSString *)name;

+ (instancetype)optionWithName:(NSString *)name
                          flag:(NSString *)flag;

+ (instancetype)optionWithName:(NSString *)name
                          flag:(NSString *)flag
                      required:(BOOL)required;

// ===== LONG NAME =====================================================================================================
#pragma mark - Long Name

@property (strong, readonly, VPLCLIAtomicity) NSString * longName;

// ===== FLAG ==========================================================================================================
#pragma mark - Flag

@property (strong, readonly, VPLCLIAtomicity) NSString * flag;

@end
