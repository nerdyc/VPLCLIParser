#import "VPLCLISpecHelper.h"

SpecBegin(VPLCLISequenceSpec)

describe(@"VPLCLISequenceSpec", ^{
  
  __block VPLCLISequence * sequence;
  
  beforeEach(^{
    VPLCLIOption * verboseOption = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                                   longName:@"verbose"
                                                                       flag:@"v"];
    
    VPLCLIOption * helpOption = [[VPLCLIOption alloc] initWithIdentifier:@"help"
                                                                longName:@"help"
                                                                    flag:@"h"];
    
    sequence = [VPLCLISequence sequenceWithOptions:@[ verboseOption, helpOption ]];
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
    
    describe(@"when the match fails", ^{
      
      beforeEach(^{
        segment = [sequence matchArguments:@[@"-h", @"--verbose"]];
      });
      
      it(@"returns nil", ^{
        expect(segment).to.beNil();
      });
      
    });
    
  });

});
SpecEnd