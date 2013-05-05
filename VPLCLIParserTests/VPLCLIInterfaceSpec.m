#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import "VPLCLISpecHelper.h"

SpecBegin(VPLCLIInterfaceSpec)

describe(@"VPLCLInterface", ^{
  
  __block VPLCLIInterface * interface;
  
  afterEach(^{
    interface = nil;
  });
  
  // ===== PROCESS NAME ================================================================================================
#pragma mark - Process Name
  
  describe(@"- processName", ^{
    
    beforeEach(^{
      interface = [[VPLCLIInterface alloc] init];
    });
    
    it(@"defaults to the current process name", ^{
      expect(interface.processName).to.equal([[NSProcessInfo processInfo] processName]);
    });
    
  });
  
  // ===== USAGE STRING ================================================================================================
#pragma mark - Usage String
  
  describe(@"- usageString", ^{
    
    __block NSString * usageString;
    
    afterEach(^{
      usageString = nil;
    });
    
    describe(@"when no options are specified", ^{
      
      beforeEach(^{
        interface = [[VPLCLIInterface alloc] initWithProcessName:@"env"];
        usageString = [interface usageString];
      });
      
      it(@"returns the process name", ^{
        expect(usageString).to.equal(@"env");
      });
      
    });
    
    describe(@"when options are specified", ^{
      
      beforeEach(^{
        VPLCLIOption * verboseOption = [[VPLCLIOption alloc] initWithIdentifier:@"verbose"];
        VPLCLISequence * sequence = [VPLCLISequence sequenceWithOptions:@[ verboseOption ]];
        
        interface = [[VPLCLIInterface alloc] initWithProcessName:@"env"
                                                         options:sequence];
        usageString = [interface usageString];
      });
      
      it(@"returns the process name", ^{
        expect(usageString).to.equal(@"env --verbose");
      });
      
    });
    
  });
  
  // ===== INTERFACE HELPERS ===========================================================================================
#pragma mark - Interface Helpers
  
  describe(@"- dictionaryFromArguments:", ^{
    
    __block NSDictionary * dictionaryFromArguments;
    
    beforeEach(^{
      interface = [VPLCLIInterface interfaceWithOptions:@[
                   
                   [VPLCLIOption optionWithName:@"alpha"],
                   [VPLCLIOption optionWithName:@"help"],
                   
                   ]];
      
      dictionaryFromArguments = [interface dictionaryFromArguments:@[ @"--help", @"--alpha" ]];
    });
    
    afterEach(^{
      dictionaryFromArguments = nil;
    });
    
    it(@"reads command-line arguments and returns a dictionary", ^{
      expect(dictionaryFromArguments).to.equal((@{ @"help": [NSNull null],
                                                   @"alpha": [NSNull null] }));
    });
    
  });

  
});

SpecEnd