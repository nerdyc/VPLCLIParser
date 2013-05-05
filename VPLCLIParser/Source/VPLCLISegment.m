#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLISegment.h"

@implementation VPLCLISegment

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)init
{
  return [self initWithIdentifier:nil
                 matchedArguments:@[]
                     matchedRange:NSMakeRange(0, 0)
                            value:nil
                         segments:@[]];
}

- (id)initWithIdentifier:(NSString *)identifier
        matchedArguments:(NSArray *)matchedArguments
            matchedRange:(NSRange)matchedRange
{
  return [self initWithIdentifier:identifier
                 matchedArguments:matchedArguments
                     matchedRange:matchedRange
                            value:nil
                         segments:@[]];
}

- (id)initWithIdentifier:(NSString *)identifier
        matchedArguments:(NSArray *)matchedArguments
            matchedRange:(NSRange)matchedRange
                   value:(id)value
{
  return [self initWithIdentifier:identifier
                 matchedArguments:matchedArguments
                     matchedRange:matchedRange
                            value:value
                         segments:@[]];
}

- (id)initWithIdentifier:(NSString *)identifier
        matchedArguments:(NSArray *)matchedArguments
            matchedRange:(NSRange)matchedRange
                   value:(id)value
                segments:(NSArray *)segments
{
  self = [super init];
  if (self != nil)
  {
    _identifier = identifier;
    _matchedArguments = matchedArguments;
    _matchedRange = matchedRange;
    _value = value;
    _segments = (segments ? segments : @[]);
  }
  return self;
}

// ===== VALUE =========================================================================================================
#pragma mark - Value

- (id)valueOfSegmentIdentifiedBy:(NSString *)identifier
{
  if ([self.identifier isEqualToString:identifier])
  {
    return self.value;
  }
  else
  {
    for (VPLCLISegment * segment in self.segments)
    {
      id value = [segment valueOfSegmentIdentifiedBy:identifier];
      if (value != nil)
      {
        return value;
      }
    }
    
    return nil;
  }
}

// ===== SEGMENTS ======================================================================================================
#pragma mark - Segments

- (NSDictionary *)dictionaryOfSegmentValues
{
  NSArray * segments = self.segments;
  if ([segments count] == 0) return @{};
  
  NSMutableDictionary * segmentValues = [[NSMutableDictionary alloc] initWithCapacity:[segments count]];
  for (VPLCLISegment * segment in segments)
  {
    if (segment.identifier != nil)
    {
      id segmentValue = segment.value;
      if (segmentValue == nil)
      {
        if ([segment.segments count] > 0)
        {
          segmentValue = [segment dictionaryOfSegmentValues];
        }
      }
      
      if (segmentValue == nil) segmentValue = [NSNull null];
      segmentValues[segment.identifier] = segmentValue;
    }
    else if ([segment.segments count] > 0)
    {
      [segmentValues addEntriesFromDictionary:[segment dictionaryOfSegmentValues]];
    }
  }
  return segmentValues;
}


@end
