#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLISpecHelper.h"

SpecBegin(VPLCLIChoiceGroupSpec)

describe(@"VPLCLIChoiceGroup", ^{
  
  __block VPLCLIChoiceGroup * group;
  
  beforeEach(^{
    VPLCLIOption * verboseOption = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"
                                                                   longName:@"verbose"
                                                                       flag:@"v"
                                                                   required:YES];
    
    VPLCLIOption * helpOption = [[VPLCLIOption alloc] initWithIdentifier:@"help"
                                                                longName:@"help"
                                                                    flag:@"h"
                                                                required:YES];
    
    group = [VPLCLIChoiceGroup choiceGroupWithOptions:@[ verboseOption, helpOption ]];
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
    
    describe(@"when one option matches", ^{
      
      beforeEach(^{
        segment = [group matchArguments:@[ @"--verbose", @"-h", @"-o", @"-" ]];
      });
      
      it(@"returns the first matched option", ^{
        expect(segment.identifier).to.equal(@"verbose");
      });
      
    });
    
    describe(@"when another option matches", ^{
      
      beforeEach(^{
        segment = [group matchArguments:@[ @"-h", @"--verbose", @"-o", @"-" ]];
      });
      
      it(@"returns the matched option", ^{
        expect(segment.identifier).to.equal(@"help");
      });
      
    });
    
    describe(@"when no option matches", ^{
      
      beforeEach(^{
        segment = [group matchArguments:@[@"--env"]];
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
    
    it(@"returns the options joined by option bars, surrounded by parentheses", ^{
      expect(usageString).to.equal(@"(--verbose | --help)");
    });
    
  });
  
});

SpecEnd