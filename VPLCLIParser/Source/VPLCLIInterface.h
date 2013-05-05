#import "VPLCLITypes.h"

@class VPLCLIGroup;

@interface VPLCLIInterface : NSObject

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithProcessName:(NSString *)processName;

- (id)initWithProcessName:(NSString *)processName
                  options:(VPLCLIGroup *)options;

// ===== INTERFACE DEFINITION ==========================================================================================
#pragma mark - Interface Definition

+ (instancetype)interfaceWithOptions:(NSArray *)options;

// ===== PROCESS NAME ==================================================================================================
#pragma mark - Process Name

@property (strong, readwrite, VPLCLIAtomicity) NSString * processName;

// ===== OPTIONS =======================================================================================================
#pragma mark - Options

@property (strong, readonly, VPLCLIAtomicity) VPLCLIGroup * options;

// ===== USAGE STRING ==================================================================================================
#pragma mark - Usage String

@property (strong, readonly, VPLCLIAtomicity) NSString * usageString;

// ===== PARSING =======================================================================================================
#pragma mark - Parsing

- (NSDictionary *)dictionaryFromProcessArguments;
- (NSDictionary *)dictionaryFromArguments:(NSArray *)commandLineArguments;

@end