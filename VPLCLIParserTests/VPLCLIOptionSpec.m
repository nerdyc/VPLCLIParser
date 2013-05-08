#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLISpecHelper.h"
#import "VPLCLIOption.h"
#import "VPLCLISegment.h"

SpecBegin(VPLCLIOptionSpec)

describe(@"VPLCLIOption", ^{
  
  __block VPLCLIOption * option;
  
  beforeEach(^{
    option = [[VPLCLIOption alloc] initWithIdentifier:@"verboseOutput"
                                             name:@"verbose"
                                                 flag:@"v"
                                             required:YES];
  });
  
  afterEach(^{
    option = nil;
  });
  
  // ===== MATCHING ====================================================================================================
#pragma mark - Matching
  
  describe(@"- matchArguments:inRange:", ^{
    
    __block VPLCLISegment * segment;
    
    afterEach(^{
      segment = nil;
    });
    
    describe(@"when the long name matches", ^{
      
      beforeEach(^{
        segment = [option matchArguments:@[@"--verbose"]];
      });
      
      it(@"returns a segment with the option's identifier", ^{
        expect(segment.identifier).to.equal(option.identifier);
        expect(segment.value).to.equal([NSNull null]);
      });
      
    });

    describe(@"when the short name matches", ^{
      
      beforeEach(^{
        segment = [option matchArguments:@[@"-v"]];
      });
      
      it(@"returns a segment with the option's identifier", ^{
        expect(segment.identifier).to.equal(option.identifier);
        expect(segment.value).to.equal([NSNull null]);
      });
      
    });
    
    describe(@"when neither the long or short name matches", ^{
      
      beforeEach(^{
        segment = [option matchArguments:@[@"-h"]];
      });
      
      it(@"returns nil", ^{
        expect(segment).to.beNil();
      });
      
    });
    
    describe(@"when the option accepts a single value", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"timeout"
                                                 name:@"timeout"
                                                     flag:@"t"
                                            minimumValues:0
                                            maximumValues:1
                                                 required:YES];
      });
      
      describe(@"and an argument like --long-name=VALUE is present", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[@"--timeout=60"]];
        });
        
        it(@"returns a segment with the option's identifier", ^{
          expect(segment.identifier).to.equal(option.identifier);
          expect(segment.value).to.equal(@"60");
        });
        
        it(@"matches only a single argument", ^{
          expect(segment.matchedRange.length).to.equal(1);
        });
        
      });
      
      describe(@"and arguments like --long-name VALUE is present", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[@"--timeout", @"60"]];
        });
        
        it(@"returns a segment with the option's identifier", ^{
          expect(segment.identifier).to.equal(option.identifier);
          expect(segment.value).to.equal(@"60");
        });
        
        it(@"matches both arguments", ^{
          expect(segment.matchedRange.length).to.equal(2);
        });
        
      });
      
      describe(@"and an argument like --long-name is present, but not followed by a value", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[@"--timeout", @"--verbose"]];
        });
        
        it(@"matches without a value", ^{
          expect(segment.identifier).to.equal(option.identifier);
          expect(segment.value).to.equal([NSNull null]);
        });
        
        it(@"matches only a single argument", ^{
          expect(segment.matchedRange.length).to.equal(1);
        });
        
      });
      
    });
    
    describe(@"when the option accepts multiple values", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"timeout"
                                                 name:@"timeout"
                                                     flag:@"t"
                                            minimumValues:0
                                            maximumValues:2
                                                 required:YES];
      });
      
      describe(@"and multiple values are provided", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[@"--timeout", @"60", @"30", @"15"]];
        });
        
        it(@"returns matches all the values", ^{
          expect(segment.identifier).to.equal(option.identifier);
          expect(segment.value).to.equal((@[ @"60", @"30" ]));
          expect(segment.matchedRange.length).to.equal(3);
        });
        
      });
      
      describe(@"and a single value is provided", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[@"--timeout", @"60", @"--delay", @"15"]];
        });
        
        it(@"returns matches a single value as an array", ^{
          expect(segment.identifier).to.equal(option.identifier);
          expect(segment.value).to.equal(@[ @"60" ]);
          expect(segment.matchedRange.length).to.equal(2);
          expect(segment.matchedArguments).to.equal((@[ @"--timeout", @"60" ]));
        });
        
      });
      
      describe(@"but no value is provided", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[@"--timeout", @"--delay", @"15"]];
        });
        
        it(@"returns matches a single argument, and has an NSNull value", ^{
          expect(segment.identifier).to.equal(option.identifier);
          expect(segment.value).to.equal([NSNull null]);
          expect(segment.matchedRange.length).to.equal(1);
          expect(segment.matchedArguments).to.equal((@[ @"--timeout" ]));
        });
        
      });
      
    });
    
    describe(@"when the option requires a single value", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"timeout"
                                                 name:@"timeout"
                                                     flag:@"t"
                                            minimumValues:1
                                            maximumValues:1
                                                 required:YES];
      });
      
      describe(@"and an argument like --long-name=VALUE is present", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[@"--timeout=60"]];
        });
        
        it(@"returns a segment with the option's identifier", ^{
          expect(segment.identifier).to.equal(option.identifier);
          expect(segment.value).to.equal(@"60");
        });
        
        it(@"matches only a single argument", ^{
          expect(segment.matchedRange.length).to.equal(1);
        });
        
      });
      
      describe(@"and arguments like --long-name VALUE is present", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[@"--timeout", @"60"]];
        });
        
        it(@"returns a segment with the option's identifier", ^{
          expect(segment.identifier).to.equal(option.identifier);
          expect(segment.value).to.equal(@"60");
        });
        
        it(@"matches both arguments", ^{
          expect(segment.matchedRange.length).to.equal(2);
        });
        
      });
      
      describe(@"and a value is not provided", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[@"--timeout", @"--verbose"]];
        });
        
        it(@"returns nil", ^{
          expect(segment).to.beNil();
        });
        
      });

    });
    
    describe(@"when the option requires multiple values", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"timeout"
                                                 name:@"timeout"
                                                     flag:@"t"
                                            minimumValues:2
                                            maximumValues:3
                                                 required:YES];
      });
      
      describe(@"and multiple values are provided", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[@"--timeout", @"60", @"30", @"15", @"7"]];
        });
        
        it(@"returns matches up to the maximum number of values", ^{
          expect(segment.identifier).to.equal(option.identifier);
          expect(segment.value).to.equal((@[ @"60", @"30", @"15" ]));
          expect(segment.matchedRange.length).to.equal(4);
          expect(segment.matchedArguments).to.equal((@[ @"--timeout", @"60", @"30", @"15" ]));
        });
        
      });
      
      describe(@"and fewer values than the minimum are provided", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[@"--timeout", @"60", @"--delay", @"15"]];
        });
        
        it(@"returns nil", ^{
          expect(segment).to.beNil();
        });
        
      });
      
      describe(@"but no value is provided", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[ @"--timeout" ]];
        });
        
        it(@"returns nil", ^{
          expect(segment).to.beNil();
        });
        
      });
      
    });
    
    describe(@"when the option accepts an arbitrary number of values", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"timeout"
                                                 name:@"timeout"
                                                     flag:@"t"
                                            minimumValues:2
                                            maximumValues:-1
                                                 required:YES];
      });
      
      describe(@"and multiple values are provided", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[@"--timeout", @"60", @"30", @"15", @"7", @"--delay", @"20"]];
        });
        
        it(@"returns matches all non-option values", ^{
          expect(segment.identifier).to.equal(option.identifier);
          expect(segment.value).to.equal((@[ @"60", @"30", @"15", @"7" ]));
          expect(segment.matchedRange.length).to.equal(5);
          expect(segment.matchedArguments).to.equal((@[ @"--timeout", @"60", @"30", @"15", @"7" ]));
        });
        
      });
      
      describe(@"but fewer values than the minimum are provided", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[@"--timeout", @"60", @"--delay", @"15"]];
        });
        
        it(@"returns nil", ^{
          expect(segment).to.beNil();
        });
        
      });
      
      describe(@"but no value is provided", ^{
        
        beforeEach(^{
          segment = [option matchArguments:@[ @"--timeout" ]];
        });
        
        it(@"returns nil", ^{
          expect(segment).to.beNil();
        });
        
      });
      
    });
    
  });

  // ===== USAGE STRING ================================================================================================
#pragma mark - Usage String
  
  describe(@"- usageString", ^{
    
    __block NSString * usageString;
    
    afterEach(^{
      usageString = nil;
    });
    
    describe(@"when a name is provided", ^{
      
      beforeEach(^{
        usageString = option.usageString;
      });
      
      it(@"returns the long name prefixed with '--'", ^{
        expect(usageString).to.equal(@"--verbose");
      });

    });
    
    describe(@"when only a flag is provided", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                 name:nil
                                                     flag:@"v"
                                                 required:YES];
        usageString = option.usageString;
      });
      
      it(@"returns the flag name prefixed with '-'", ^{
        expect(usageString).to.equal(@"-v");
      });
      
    });
    
    describe(@"when the option is optional", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                 name:@"verbose"
                                                     flag:@"v"
                                                 required:NO];
        usageString = option.usageString;
      });
      
      it(@"surrounds the option in square brackets", ^{
        expect(usageString).to.equal(@"[--verbose]");
      });
      
    });
    
    describe(@"when the option accepts a single, optional value", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                 name:@"verbose"
                                                     flag:@"v"
                                            minimumValues:0
                                            maximumValues:1
                                                 required:YES];
        usageString = option.usageString;
      });
      
      it(@"appends the value after an equals sign, surrounded by square brackets", ^{
        expect(usageString).to.equal(@"--verbose[=VALUE]");
      });
      
    });
    
    describe(@"when the option accepts multiple bounded values", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                 name:@"verbose"
                                                     flag:@"v"
                                            minimumValues:0
                                            maximumValues:3
                                                 required:YES];
        usageString = option.usageString;
      });
      
      it(@"appends the values after the option surrounded by square brackets", ^{
        expect(usageString).to.equal(@"--verbose [VALUE [VALUE [VALUE]]]");
      });
      
    });
    
    describe(@"when the option accepts an unlimited number of values", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                 name:@"verbose"
                                                     flag:@"v"
                                            minimumValues:0
                                            maximumValues:-1
                                                 required:YES];
        usageString = option.usageString;
      });
      
      it(@"shows an ellipses after an initial value", ^{
        expect(usageString).to.equal(@"--verbose [VALUE ...]");
      });
      
    });
    
    describe(@"when the option requires a single value", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                 name:@"verbose"
                                                     flag:@"v"
                                            minimumValues:1
                                            maximumValues:1
                                                 required:YES];
        usageString = option.usageString;
      });
      
      it(@"appends the value after an equals sign", ^{
        expect(usageString).to.equal(@"--verbose=VALUE");
      });
      
    });
    
    describe(@"when the option requires multiple values", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                 name:@"verbose"
                                                     flag:@"v"
                                            minimumValues:2
                                            maximumValues:2
                                                 required:YES];
        usageString = option.usageString;
      });
      
      it(@"appends the values after the option name", ^{
        expect(usageString).to.equal(@"--verbose VALUE VALUE");
      });
      
    });
    
    describe(@"when the option requires a range of values", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                 name:@"verbose"
                                                     flag:@"v"
                                            minimumValues:2
                                            maximumValues:3
                                                 required:YES];
        usageString = option.usageString;
      });
      
      it(@"appends the values after the option name, with optional values in brackets", ^{
        expect(usageString).to.equal(@"--verbose VALUE VALUE [VALUE]");
      });
      
    });

    describe(@"when the option requires an unbounded number values", ^{
      
      beforeEach(^{
        option = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                 name:@"verbose"
                                                     flag:@"v"
                                            minimumValues:2
                                            maximumValues:-1
                                                 required:YES];
        usageString = option.usageString;
      });
      
      it(@"appends the minimum values after the option name, followed by an ellipsis", ^{
        expect(usageString).to.equal(@"--verbose VALUE VALUE ...");
      });
      
    });

  });
  
});

SpecEnd
