#import "VPLCLITypes.h"

@interface VPLCLISegment : NSObject

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithIdentifier:(NSString *)identifier
        matchedArguments:(NSArray *)matchedArguments
            matchedRange:(NSRange)matchedRange;

- (id)initWithIdentifier:(NSString *)identifier
        matchedArguments:(NSArray *)matchedArguments
            matchedRange:(NSRange)matchedRange
                   value:(id)value;

- (id)initWithIdentifier:(NSString *)identifier
        matchedArguments:(NSArray *)matchedArguments
            matchedRange:(NSRange)matchedRange
                   value:(id)value
                segments:(NSArray *)segments;

// ===== IDENTIFIER ====================================================================================================
#pragma mark - Identifier

@property (strong, readonly, VPLCLIAtomicity) NSString * identifier;

// ===== VALUE =========================================================================================================
#pragma mark - Value

@property (strong, readonly, VPLCLIAtomicity) id value;


// ===== SEGMENTS ======================================================================================================
#pragma mark - Segments

@property (strong, readonly, VPLCLIAtomicity) NSArray * segments;

- (id)valueOfSegmentIdentifiedBy:(NSString *)identifier;
- (NSDictionary *)dictionaryOfSegmentValues;

// ===== MATCHED ARGUMENTS =============================================================================================
#pragma mark - Matched Arguments

@property (strong, readonly, VPLCLIAtomicity) NSArray * matchedArguments;
@property (assign, readonly, VPLCLIAtomicity) NSRange matchedRange;

@end
