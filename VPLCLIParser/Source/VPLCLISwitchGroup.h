#import "VPLCLIGroup.h"

@interface VPLCLISwitchGroup : VPLCLIGroup

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithCaseIdentifier:(NSString *)caseIdentifier
                       cases:(NSDictionary *)cases;


// ===== CASE IDENTIFIER ===============================================================================================
#pragma mark - Case Identifier

@property (strong, readonly, VPLCLIAtomicity) NSString * caseIdentifier;

// ===== CASES =========================================================================================================
#pragma mark - Cases

@property (strong, readonly, VPLCLIAtomicity) NSDictionary * cases;

@end
