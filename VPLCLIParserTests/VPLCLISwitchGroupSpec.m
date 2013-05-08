#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLISpecHelper.h"

SpecBegin(VPLCLISwitchGroupSpec)

describe(@"VPLCLISwitchGroupSpec", ^{
  
  __block VPLCLISwitchGroup * switchGroup;
  
  beforeEach(^{
    VPLCLIOption * verboseOption = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                                   name:@"verbose"
                                                                       flag:@"v"
                                                                   required:YES];
    
    VPLCLIInterleavedGroup * helpOptions = [VPLCLIInterleavedGroup interleavedGroupWithOptions:@[ verboseOption ]];
    
    
    VPLCLIOption * asyncOption = [[VPLCLIOption alloc] initWithIdentifier:@"asynchronous"
                                                                 name:@"async"
                                                                     flag:nil
                                                                 required:YES];
    VPLCLIInterleavedGroup * execOptions = [VPLCLIInterleavedGroup interleavedGroupWithOptions:@[ asyncOption ]];
    
    switchGroup = [[VPLCLISwitchGroup alloc] initWithCaseIdentifier:@"commandName"
                                                              cases:@{
                                                                     @"help": helpOptions,
                                                                     @"exec": execOptions
                                                                   }];
  });
  
  afterEach(^{
    switchGroup = nil;
  });

  // ===== MATCHING ====================================================================================================
#pragma mark - Matching
  
  describe(@"- matchArguments:inRange:", ^{
    
    __block VPLCLISegment * segment;
    
    afterEach(^{
      segment = nil;
    });
    
    describe(@"when one case matches", ^{
      
      beforeEach(^{
        segment = [switchGroup matchArguments:@[ @"help", @"--verbose" ]];
      });
      
      it(@"returns a segment containing the matched options", ^{
        expect([segment valueOfSegmentIdentifiedBy:@"commandName"]).to.equal(@"help");
        expect([segment valueOfSegmentIdentifiedBy:@"verbose"]).to.equal([NSNull null]);
      });
      
      it(@"only matches matching arguments", ^{
        expect(segment.matchedRange.location).to.equal(0);
        expect(segment.matchedRange.length).to.equal(2);
      });
      
    });
    
    describe(@"when another case matches", ^{
      
      beforeEach(^{
        segment = [switchGroup matchArguments:@[ @"exec", @"--async" ]];
      });
      
      it(@"returns a segment containing the matched options", ^{
        expect([segment valueOfSegmentIdentifiedBy:@"commandName"]).to.equal(@"exec");
        expect([segment valueOfSegmentIdentifiedBy:@"asynchronous"]).to.equal([NSNull null]);
      });
      
      it(@"only matches matching arguments", ^{
        expect(segment.matchedRange.location).to.equal(0);
        expect(segment.matchedRange.length).to.equal(2);
      });
      
    });
    
    describe(@"when the match fails", ^{
      
      beforeEach(^{
        segment = [switchGroup matchArguments:@[@"run", @"--verbose"]];
      });
      
      it(@"returns nil", ^{
        expect(segment).to.beNil();
      });
      
    });
    
  });
  
  // ===== USAGE STRING ================================================================================================
#pragma mark - Usage String
  
  describe(@"- usageString", ^{
    
    __block NSString * usageString;
    
    beforeEach(^{
      usageString = switchGroup.usageString;
    });
    
    afterEach(^{
      usageString = nil;
    });
    
    it(@"returns the commands joined by by bars and wrapped with parentheses", ^{
      expect(usageString).to.equal(@"(exec --async | help --verbose)");
    });
    
  });
  
});

SpecEnd