#import "VPLCLITypes.h"

@class VPLCLIGroup;

@interface VPLCLIInterface : NSObject

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithProcessName:(NSString *)processName;

- (id)initWithProcessName:(NSString *)processName
                  options:(VPLCLIGroup *)options;

// ===== PROCESS NAME ==================================================================================================
#pragma mark - Process Name

@property (strong, readwrite, VPLCLIAtomicity) NSString * processName;

// ===== OPTIONS =======================================================================================================
#pragma mark - Options

@property (strong, readonly, VPLCLIAtomicity) VPLCLIGroup * options;

// ===== USAGE STRING ==================================================================================================
#pragma mark - Usage String

@property (strong, readonly, VPLCLIAtomicity) NSString * usageString;

@end