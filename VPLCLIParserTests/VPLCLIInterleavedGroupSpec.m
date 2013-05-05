#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLISpecHelper.h"

SpecBegin(VPLCLIInterleavedGroupSpec)

describe(@"VPLCLIInterleavedGroup", ^{
  
  __block VPLCLIInterleavedGroup * group;
  
  beforeEach(^{
    VPLCLIOption * verboseOption = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                                   longName:@"verbose"
                                                                       flag:@"v"];
    
    VPLCLIOption * helpOption = [[VPLCLIOption alloc] initWithIdentifier:@"help"
                                                                longName:@"help"
                                                                    flag:@"h"];
    
    group = [VPLCLIInterleavedGroup interleavedGroupWithOptions:@[ verboseOption, helpOption ]];
  });
  
  afterEach(^{
    group = nil;
  });
  
  // ===== MATCHING ====================================================================================================
#pragma mark - Matching
  
  describe(@"- matchArguments:inRange:", ^{
    
    __block VPLCLISegment * segment;
    
    afterEach(^{
      segment = nil;
    });
    
    describe(@"when the arguments match the given order", ^{
      
      beforeEach(^{
        segment = [group matchArguments:@[ @"--verbose", @"-h", @"-o", @"-" ]];
      });
      
      it(@"returns a segment containing the matched options", ^{
        expect([segment valueOfSegmentIdentifiedBy:@"verbose"]).to.equal([NSNull null]);
        expect([segment valueOfSegmentIdentifiedBy:@"help"]).to.equal([NSNull null]);
      });
      
      it(@"only matches matchng arguments", ^{
        expect(segment.matchedRange.location).to.equal(0);
        expect(segment.matchedRange.length).to.equal(2);
      });
      
    });
    
    describe(@"when the arguments match an alternate order", ^{
      
      beforeEach(^{
        segment = [group matchArguments:@[ @"-h", @"--verbose", @"-o", @"-" ]];
      });
      
      it(@"returns a segment containing the matched options", ^{
        expect([segment valueOfSegmentIdentifiedBy:@"verbose"]).to.equal([NSNull null]);
        expect([segment valueOfSegmentIdentifiedBy:@"help"]).to.equal([NSNull null]);
      });
      
      it(@"only matches matchng arguments", ^{
        expect(segment.matchedRange.location).to.equal(0);
        expect(segment.matchedRange.length).to.equal(2);
      });
      
    });
    
    describe(@"when the match fails", ^{
      
      beforeEach(^{
        segment = [group matchArguments:@[@"-o", @"-", @"-h", @"--verbose"]];
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
      usageString = group.usageString;
    });
    
    afterEach(^{
      usageString = nil;
    });
    
    it(@"returns the options' usage strings joined together", ^{
      expect(usageString).to.equal(@"--verbose --help");
    });
    
  });
  
});

SpecEnd