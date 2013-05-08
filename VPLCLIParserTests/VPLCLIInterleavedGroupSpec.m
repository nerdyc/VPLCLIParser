#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLISpecHelper.h"

SpecBegin(VPLCLIInterleavedGroupSpec)

describe(@"VPLCLIInterleavedGroup", ^{
  
  __block VPLCLIInterleavedGroup * group;
  
  beforeEach(^{
    VPLCLIOption * verboseOption = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                                   name:@"verbose"
                                                                       flag:@"v"
                                                                   required:YES];
    
    VPLCLIOption * helpOption = [[VPLCLIOption alloc] initWithIdentifier:@"help"
                                                                name:@"help"
                                                                    flag:@"h"
                                                                required:YES];
    
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
    
    describe(@"when a required argument is missing", ^{
      
      beforeEach(^{
        segment = [group matchArguments:@[  @"--verbose" ]];
      });
      
      it(@"returns nil", ^{
        expect(segment).to.beNil();
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
    
    describe(@"when an option is not required", ^{
      
      beforeEach(^{
        group = [VPLCLIInterleavedGroup interleavedGroupWithOptions:@[
                 
                     [VPLCLIOption optionWithName:@"alpha"],
                     [VPLCLIOption optionWithName:@"beta"],
                     [VPLCLIOption optionWithName:@"gamma" flag:@"g" required:NO],
                 
                 ]];
      });
      
      it(@"matches when present", ^{
        segment = [group matchArguments:@[ @"--beta", @"--gamma", @"--alpha" ]];
        expect(segment).notTo.beNil();
        expect([segment dictionaryOfSegmentValues]).to.equal((@{  @"alpha": [NSNull null],
                                                                  @"beta": [NSNull null],
                                                                  @"gamma": [NSNull null]
                                                             }));
      });

      it(@"matches when not present", ^{
        segment = [group matchArguments:@[ @"--beta", @"--alpha" ]];
        expect(segment).notTo.beNil();
        expect([segment dictionaryOfSegmentValues]).to.equal((@{  @"alpha": [NSNull null],
                                                                  @"beta": [NSNull null]
                                                              }));
      });
      
      it(@"still fails when a required option is not present",  ^{
        segment = [group matchArguments:@[ @"--gamma", @"--alpha" ]];
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