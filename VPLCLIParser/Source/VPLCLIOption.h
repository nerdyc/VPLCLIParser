#import "VPLCLIMatcher.h"

@interface VPLCLIOption : VPLCLIMatcher

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithIdentifier:(NSString *)identifier
                required:(BOOL)required;

- (id)initWithIdentifier:(NSString *)identifier
                longName:(NSString *)longName
                    flag:(NSString *)flag
                required:(BOOL)required;

- (id)initWithIdentifier:(NSString *)identifier
                longName:(NSString *)longName
                    flag:(NSString *)flag
           minimumValues:(NSInteger)minimumValues
           maximumValues:(NSInteger)maximumValues
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

// ===== VALUES ========================================================================================================
#pragma mark - Values

@property (assign, readonly, VPLCLIAtomicity) NSInteger minimumValues;
@property (assign, readonly, VPLCLIAtomicity) NSInteger maximumValues;

@property (assign, readonly, VPLCLIAtomicity) BOOL acceptsValues;
@property (assign, readonly, VPLCLIAtomicity) BOOL requiresValues;



@end
