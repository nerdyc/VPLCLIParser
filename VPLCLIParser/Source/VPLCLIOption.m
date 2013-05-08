#import "VPLCLIOption.h"
#import "VPLCLISegment.h"

#define DEFAULT_MINIMUM_VALUES (0)
#define DEFAULT_MAXIMUM_VALUES (0)

@implementation VPLCLIOption

// ===== INITIALIZATION ================================================================================================
#pragma mark - Initialization

- (id)initWithIdentifier:(NSString *)identifier
                    name:(NSString *)name
                    flag:(NSString *)flag
           minimumValues:(NSInteger)minimumValues
           maximumValues:(NSInteger)maximumValues
                required:(BOOL)required
{
  if (maximumValues >= 0 && minimumValues > maximumValues)
  {
    [NSException raise:NSInternalInconsistencyException
                format:@"[%@ %@] minimumValues (%li) cannot be greater than maximumValues (%li)",
                       NSStringFromClass([self class]),
                       NSStringFromSelector(_cmd),
                       (long)minimumValues,
                       (long)maximumValues];
  }
  
  if (identifier == nil)
  {
    if (name != nil)
    {
      identifier = name;
    }
    else
    {
      identifier = flag;
    }
  }
  
  self = [super initWithIdentifier:identifier
                          required:required];
  if (self != nil)
  {
    _name = name;
    _flag = flag;
    _minimumValues = minimumValues;
    _maximumValues = maximumValues;
  }
  return self;
}

+ (instancetype)optionWithName:(NSString *)name
{
  return [self optionWithName:name
                         flag:nil
                requiresValue:NO
                   identifier:nil];
}

+ (instancetype)optionWithName:(NSString *)name
                          flag:(NSString *)flag
{
  return [self optionWithName:name
                         flag:flag
                requiresValue:NO
                   identifier:nil];
}

+ (instancetype)optionWithName:(NSString *)name
                          flag:(NSString *)flag
                 requiresValue:(BOOL)requiresValue
{
  return [self optionWithName:name
                         flag:flag
                requiresValue:requiresValue
                   identifier:nil];
}

+ (instancetype)optionWithName:(NSString *)name
                          flag:(NSString *)flag
                 requiresValue:(BOOL)requiresValue
                    identifier:(NSString *)identifier
{
  return [[self alloc] initWithIdentifier:identifier
                                     name:name
                                     flag:flag
                            minimumValues:(requiresValue ? 1 : 0)
                            maximumValues:(requiresValue ? 1 : 0)
                                 required:NO];
}

+ (instancetype)requiredOptionWithName:(NSString *)name
{
  return [self requiredOptionWithName:name
                                 flag:nil
                        requiresValue:NO
                           identifier:nil];
}

+ (instancetype)requiredOptionWithName:(NSString *)name
                                  flag:(NSString *)flag
{
  return [self requiredOptionWithName:name
                                 flag:flag
                        requiresValue:NO
                           identifier:nil];
}

+ (instancetype)requiredOptionWithName:(NSString *)name
                                  flag:(NSString *)flag
                         requiresValue:(BOOL)requiresValue
{
  return [self requiredOptionWithName:name
                                 flag:flag
                        requiresValue:requiresValue
                           identifier:nil];
}

+ (instancetype)requiredOptionWithName:(NSString *)name
                                  flag:(NSString *)flag
                         requiresValue:(BOOL)requiresValue
                            identifier:(NSString *)identifier
{
  return [[self alloc] initWithIdentifier:identifier
                                     name:name
                                     flag:flag
                            minimumValues:(requiresValue ? 1 : 0)
                            maximumValues:(requiresValue ? 1 : 0)
                                 required:YES];
}

// ===== VALUES ========================================================================================================
#pragma mark - Values

- (BOOL)acceptsValues
{
  return self.maximumValues != 0;
}

- (BOOL)requiresValues
{
  return self.minimumValues > 0;
}

- (BOOL)isValidNumberOfValues:(NSInteger)numberOfValues
{
  if (numberOfValues < 0) return NO;
  if (numberOfValues < self.minimumValues) return NO;
  
  return (self.maximumValues < 0) || (numberOfValues <= self.maximumValues);
}

// ===== USAGE STRING ==================================================================================================
#pragma mark - Usage String

- (NSString *)usageString
{
  NSMutableString * optionString = [[NSMutableString alloc] init];
  if (self.required == NO)
  {
    [optionString appendString:@"["];
  }
  
  if (self.name != nil)
  {
    [optionString appendString:@"--"];
    [optionString appendString:self.name];
  }
  else if (self.flag != nil)
  {
    [optionString appendString:@"-"];
    [optionString appendString:self.flag];
  }
  
  if (self.minimumValues == 0 && self.maximumValues == 1)
  {
    [optionString appendString:@"[=VALUE]"];
  }
  else if (self.minimumValues == 1 && self.maximumValues == 1)
  {
    [optionString appendString:@"=VALUE"];
  }
  else
  {
    for (NSUInteger valueIdx = 0; valueIdx < self.minimumValues; valueIdx++)
    {
      [optionString appendString:@" VALUE"];
    }
    
    if (self.maximumValues > self.minimumValues)
    {
      for (NSUInteger valueIdx = self.minimumValues; valueIdx < self.maximumValues; valueIdx++)
      {
        [optionString appendString:@" [VALUE"];
      }

      for (NSUInteger valueIdx = self.minimumValues; valueIdx < self.maximumValues; valueIdx++)
      {
        [optionString appendString:@"]"];
      }
    }
    else if (self.maximumValues < 0)
    {
      if (self.minimumValues == 0)
      {
        [optionString appendString:@" [VALUE ...]"];
      }
      else
      {
        [optionString appendString:@" ..."];
      }
    }
  }
  
  if (self.required == NO)
  {
    [optionString appendString:@"]"];
  }
  
  return optionString;
}

// ===== MATCH ARGUMENTS ===============================================================================================
#pragma mark - Match Arguments

- (VPLCLISegment *)matchArguments:(NSArray *)arguments
                          inRange:(NSRange)range
{
  // Process the first argument, matching the name and any inline value (--option=VALUE)
  NSString * initialArgument = arguments[range.location];
  NSString * inlineValue = nil;
  if ([initialArgument hasPrefix:@"--"])
  {
    NSRange nameRange = NSMakeRange(2, [self.name length]);
    NSUInteger indexAfterName = NSMaxRange(nameRange);
    
    if ([initialArgument length] < indexAfterName)
    {
      // the argument is not long enough to match our name
      return nil;
    }
    else if (NSOrderedSame != [initialArgument compare:self.name
                                               options:0
                                                 range:nameRange])
    {
      // the argument name doesn't begin with our long option name
      return nil;
    }
    
    // process any inline value...
    if ([initialArgument length] > indexAfterName)
    {
      if (NSOrderedSame == [initialArgument compare:@"="
                                            options:0
                                              range:NSMakeRange(indexAfterName, 1)])
      {
        // an inline value has been provided
        NSUInteger indexOfValue = indexAfterName+1;
        if ([initialArgument length] > indexOfValue)
        {
          inlineValue = [initialArgument substringFromIndex:indexOfValue];
        }
        else
        {
          // the argument ends after the '='
          inlineValue = @"";
        }
      }
      else
      {
        // the argument name doesn't match (our name is a prefix of the argument's name)
        return nil;
      }
    }
  }
  else if ([initialArgument hasPrefix:@"-"])
  {
    if (NSOrderedSame != [initialArgument compare:self.flag
                                          options:0
                                            range:NSMakeRange(1, [initialArgument length] -1)])
    {
      return nil;
    }
  }
  else
  {
    return nil;
  }
  
  // if an inline value was provided, then we only match a single argument and value
  if (inlineValue != nil)
  {
    if ([self isValidNumberOfValues:1])
    {
      return [[VPLCLISegment alloc] initWithIdentifier:self.identifier
                                      matchedArguments:@[ initialArgument ]
                                          matchedRange:NSMakeRange(range.location, 1)
                                                 value:inlineValue];
    }
    else
    {
      // option requires more than 1 value, which can't be supported by an inline value
      return nil;
    }
  }
  
  // 0 or more values are after the initial argument. We advance as far as we can before hitting the maximum (if one
  // exists).
  NSUInteger numberOfValues = 0;
  NSUInteger maxNumberOfValues = (self.maximumValues < 0 ? NSIntegerMax : self.maximumValues);
  NSUInteger nextArgumentIndex = range.location + 1;
  
  while (nextArgumentIndex < NSMaxRange(range)
         && numberOfValues < maxNumberOfValues)
  {
    NSString * argument = arguments[nextArgumentIndex];
    if ([argument hasPrefix:@"-"]) break;
    
    nextArgumentIndex++;
    numberOfValues++;
  }
  
  if (numberOfValues < self.minimumValues)
  {
    // not enough values
    return nil;
  }
  
  // collect the values and return a segment. If no values matched, then the value is NSNull. If it is possible for an
  // option to have more than one value, we return an array. Otherwise we just return the single value.
  id value;
  if (numberOfValues == 0)
  {
    value = [NSNull null];
  }
  else if (numberOfValues == 1 && self.maximumValues == 1)
  {
    value = arguments[range.location + 1];
  }
  else
  {
    NSRange rangeOfValues = NSMakeRange(range.location + 1, numberOfValues);
    value = [arguments subarrayWithRange:rangeOfValues];
  }
  
  NSRange matchedRange = NSMakeRange(range.location, numberOfValues + 1);
  NSArray * matchedArguments = [arguments subarrayWithRange:matchedRange];
  
  return [[VPLCLISegment alloc] initWithIdentifier:self.identifier
                                  matchedArguments:matchedArguments
                                      matchedRange:matchedRange
                                             value:value];
}

@end
