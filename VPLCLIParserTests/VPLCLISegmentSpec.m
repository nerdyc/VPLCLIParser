#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLISpechelper.h"
#import "VPLCLISegment.h"

SpecBegin(VPLCLISegmentSpec)

describe(@"VPLCLISegment", ^{
  
  __block VPLCLISegment * segment;
  
  afterEach(^{
    segment = nil;
  });
  
  // ===== SEGMENTS ====================================================================================================
#pragma mark - Segments
  
  describe(@"- dictionaryOfSegmentValues", ^{
    
    describe(@"when no sub-segments exist", ^{
      
      beforeEach(^{
        segment = [[VPLCLISegment alloc] init];
      });
      
      it(@"returns an empty dictionary", ^{
        expect([segment dictionaryOfSegmentValues]).to.equal(@{});
      });
      
    });
    
    describe(@"when simple sub-segments exist", ^{
      
      beforeEach(^{
        VPLCLISegment * helpSegment = [[VPLCLISegment alloc] initWithIdentifier:@"help"
                                                               matchedArguments:@[ @"--help" ]
                                                                   matchedRange:NSMakeRange(0, 1)];

        VPLCLISegment * verboseSegment = [[VPLCLISegment alloc] initWithIdentifier:@"verbose"
                                                                  matchedArguments:@[ @"-v" ]
                                                                      matchedRange:NSMakeRange(1, 1)];
        
        segment = [[VPLCLISegment alloc] initWithIdentifier:nil
                                           matchedArguments:@[ @"--help", @"-v" ]
                                               matchedRange:NSMakeRange(0, 2)
                                                      value:nil
                                                   segments:@[ helpSegment, verboseSegment ]];
      });
      
      it(@"returns a dictionary mapping each segment's identifier to its value", ^{
        expect([segment dictionaryOfSegmentValues]).to.equal((@{
                                                              
                                                              @"help": [NSNull null],
                                                              @"verbose": [NSNull null]
                                                              
                                                             }));
      });
      
    });
    
    describe(@"when the segment contains an anonymous sub-segment", ^{
      
      beforeEach(^{
        VPLCLISegment * helpSegment = [[VPLCLISegment alloc] initWithIdentifier:@"help"
                                                               matchedArguments:@[ @"--help" ]
                                                                   matchedRange:NSMakeRange(0, 1)];
        
        VPLCLISegment * anonymousSegment = [[VPLCLISegment alloc] initWithIdentifier:nil
                                                                    matchedArguments:@[ @"--help" ]
                                                                        matchedRange:NSMakeRange(0, 1)
                                                                               value:nil
                                                                            segments:@[ helpSegment ]];
        
        VPLCLISegment * verboseSegment = [[VPLCLISegment alloc] initWithIdentifier:@"verbose"
                                                                  matchedArguments:@[ @"-v" ]
                                                                      matchedRange:NSMakeRange(1, 1)];
        
        segment = [[VPLCLISegment alloc] initWithIdentifier:nil
                                           matchedArguments:@[ @"--help", @"-v" ]
                                               matchedRange:NSMakeRange(0, 2)
                                                      value:nil
                                                   segments:@[ anonymousSegment, verboseSegment ]];
      });
      
      it(@"the anonymous segment's dictionary is merged into the segment's dictionary", ^{
        expect([segment dictionaryOfSegmentValues]).to.equal((@{
                                                              
                                                              @"help": [NSNull null],
                                                              @"verbose": [NSNull null]
                                                              
                                                              }));
      });
      
    });
    
    describe(@"when the segment contains a named sub-segment", ^{
      
      beforeEach(^{
        VPLCLISegment * showExamplesSegment = [[VPLCLISegment alloc] initWithIdentifier:@"showExamples"
                                                                       matchedArguments:@[ @"--show-examples" ]
                                                                           matchedRange:NSMakeRange(0, 1)];
        
        VPLCLISegment * showTutorialSegment = [[VPLCLISegment alloc] initWithIdentifier:@"tutorialName"
                                                                       matchedArguments:@[ @"--show-tutorial", @"hello-world" ]
                                                                           matchedRange:NSMakeRange(1, 2)
                                                                                  value:@"hello-world"];
        
        VPLCLISegment * helpSegment = [[VPLCLISegment alloc] initWithIdentifier:@"help"
                                                               matchedArguments:@[ @"--show-examples", @"--show-tutorial", @"hello-world" ]
                                                                   matchedRange:NSMakeRange(0, 3)
                                                                          value:nil
                                                                       segments:@[ showExamplesSegment, showTutorialSegment ]];
        
        VPLCLISegment * verboseSegment = [[VPLCLISegment alloc] initWithIdentifier:@"verbose"
                                                                  matchedArguments:@[ @"-v" ]
                                                                      matchedRange:NSMakeRange(3, 1)];
        
        segment = [[VPLCLISegment alloc] initWithIdentifier:nil
                                           matchedArguments:@[ @"--show-examples", @"--show-tutorial", @"hello-world", @"-v" ]
                                               matchedRange:NSMakeRange(0, 4)
                                                      value:nil
                                                   segments:@[ helpSegment, verboseSegment ]];
      });
      
      it(@"maps the named segment's dictionary in the enclosing dictionary", ^{
        expect([segment dictionaryOfSegmentValues]).to.equal((@{
                                                              
                                                                @"help": @{
                                                                  @"showExamples": [NSNull null],
                                                                  @"tutorialName": @"hello-world"
                                                                },
                                                                @"verbose": [NSNull null]
                                                              
                                                              }));
      });
      
    });
    
  });
  
});

SpecEnd