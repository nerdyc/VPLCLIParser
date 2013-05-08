#import "VPLCLISpecHelper.h"

SpecBegin(VPLCLISequenceSpec)

describe(@"VPLCLISequenceSpec", ^{
  
  __block VPLCLISequence * sequence;
  
  beforeEach(^{
    VPLCLIOption * verboseOption = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                                   name:@"verbose"
                                                                       flag:@"v"
                                                                   required:YES];
    
    VPLCLIOption * helpOption = [[VPLCLIOption alloc] initWithIdentifier:@"help"
                                                                name:@"help"
                                                                    flag:@"h"
                                                                required:YES];
    
    
    VPLCLIOption * unrequiredOption = [[VPLCLIOption alloc] initWithIdentifier:@"skip"
                                                                      name:@"skip"
                                                                          flag:nil
                                                                      required:NO];
    
    sequence = [VPLCLISequence sequenceWithOptions:@[ verboseOption, unrequiredOption, helpOption ]];
  });
  
  afterEach(^{
    sequence = nil;
  });
  
  // ===== MATCHING ====================================================================================================
  #pragma mark - Matching

  describe(@"- matchArguments:inRange:", ^{
    
    __block VPLCLISegment * segment;
    
    afterEach(^{
      segment = nil;
    });
    
    describe(@"when the arguments match", ^{
      
      beforeEach(^{
        segment = [sequence matchArguments:@[ @"--verbose", @"--skip", @"-h", @"-o", @"-" ]];
      });
      
      it(@"returns a segment containing the matched options", ^{
        expect([segment valueOfSegmentIdentifiedBy:@"verbose"]).to.equal([NSNull null]);
        expect([segment valueOfSegmentIdentifiedBy:@"help"]).to.equal([NSNull null]);
      });
      
      it(@"only matches matchng arguments", ^{
        expect(segment.matchedRange.location).to.equal(0);
        expect(segment.matchedRange.length).to.equal(3);
      });
      
    });
    
    describe(@"when an unrequired option is missing", ^{
      
      beforeEach(^{
        segment = [sequence matchArguments:@[ @"--verbose", @"-h", @"-o", @"-" ]];
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
    
    describe(@"when the arguments are out of order", ^{
      
      beforeEach(^{
        segment = [sequence matchArguments:@[@"-h", @"--verbose", @"--skip"]];
      });
      
      it(@"returns nil", ^{
        expect(segment).to.beNil();
      });
      
    });
    
    describe(@"when a required argument is not present", ^{
      
      beforeEach(^{
        segment = [sequence matchArguments:@[ @"--verbose", @"--skip" ]];
      });
      
      it(@"returns nil", ^{
        expect(segment).to.beNil();
      });
      
    });
    
    describe(@"when an unknown option is encountered", ^{
      
      beforeEach(^{
        segment = [sequence matchArguments:@[@"--verbose", @"--skip", @"-o", @"-h"]];
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
      usageString = sequence.usageString;
    });
    
    afterEach(^{
      usageString = nil;
    });
    
    it(@"joins all options' usage strings in order", ^{
      expect(usageString).to.equal(@"--verbose [--skip] --help");
    });
    
  });

});

SpecEnd