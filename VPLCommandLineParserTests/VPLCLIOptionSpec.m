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
                                             longName:@"verbose"
                                                 flag:@"v"];
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

    describe(@"when the match fails", ^{
      
      beforeEach(^{
        segment = [option matchArguments:@[@"-h"]];
      });
      
      it(@"returns nil", ^{
        expect(segment).to.beNil();
      });
      
    });
    
  });

});

SpecEnd
