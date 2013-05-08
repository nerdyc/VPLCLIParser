#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import <Foundation/Foundation.h>
#import "VPLCLIParser.h"

int main(int argc, const char * argv[])
{
  @autoreleasepool
  {
    VPLCLIInterface * interface = [VPLCLIInterface interfaceWithOptions:@[

                                     [VPLCLIOption requiredOptionWithName:@"repeat"
                                                                     flag:@"r"
                                                            requiresValue:YES
                                                               identifier:@"repeatCount"],
                                   
                                     [VPLCLIOption optionWithName:@"verbose"
                                                             flag:@"v"],
                                   
                                     [VPLCLIOption optionWithName:@"help"
                                                             flag:@"h"]
                                   
                                   ]];
    
    
    NSDictionary * commandLineData = [interface dictionaryFromProcessArguments];
    if (commandLineData == nil
        || commandLineData[@"help"] != nil)
    {
      printf("Usage: %s\n", [[interface usageString] UTF8String]);
    }
    else
    {
      printf("%s\n", [[commandLineData description] UTF8String]);
    }
  }
  return 0;
}

