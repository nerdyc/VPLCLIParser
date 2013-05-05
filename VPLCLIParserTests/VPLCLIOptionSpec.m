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

    describe(@"when the match fails", ^{
      
      beforeEach(^{
        segment = [option matchArguments:@[@"-h"]];
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
    
    afterEach(^{
      usageString = nil;
    });
    
    describe(@"when a longName is provided", ^{
      
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
                                                 longName:nil
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
                                                 longName:@"verbose"
                                                     flag:@"v"
                                                 required:NO];
        usageString = option.usageString;
      });
      
      it(@"surrounds the option in square brackets", ^{
        expect(usageString).to.equal(@"[--verbose]");
      });
      
    });
    
  });
  
});

SpecEnd
