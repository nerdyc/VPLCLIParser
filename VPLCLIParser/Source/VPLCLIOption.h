#import "VPLCLIMatcher.h"

@interface VPLCLIOption : VPLCLIMatcher

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithIdentifier:(NSString *)identifier
                    name:(NSString *)name
                    flag:(NSString *)flag
           minimumValues:(NSInteger)minimumValues
           maximumValues:(NSInteger)maximumValues
                required:(BOOL)required;

// ----- OPTIONAL OPTIONS ----------------------------------------------------------------------------------------------
#pragma mark Optional Arguments

+ (instancetype)optionWithName:(NSString *)name;

+ (instancetype)optionWithName:(NSString *)name
                          flag:(NSString *)flag;

+ (instancetype)optionWithName:(NSString *)name
                          flag:(NSString *)flag
                 requiresValue:(BOOL)requiresValue;

+ (instancetype)optionWithName:(NSString *)name
                          flag:(NSString *)flag
                 requiresValue:(BOOL)requiresValue
                    identifier:(NSString *)identifier;

// ----- REQUIRED OPTIONS ----------------------------------------------------------------------------------------------
#pragma mark Required

+ (instancetype)requiredOptionWithName:(NSString *)name;

+ (instancetype)requiredOptionWithName:(NSString *)name
                                  flag:(NSString *)flag;

+ (instancetype)requiredOptionWithName:(NSString *)name
                                  flag:(NSString *)flag
                         requiresValue:(BOOL)requiresValue;

+ (instancetype)requiredOptionWithName:(NSString *)name
                                  flag:(NSString *)flag
                         requiresValue:(BOOL)requiresValue
                            identifier:(NSString *)identifier;


// ===== NAME ==========================================================================================================
#pragma mark - Name

@property (strong, readonly, VPLCLIAtomicity) NSString * name;

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
