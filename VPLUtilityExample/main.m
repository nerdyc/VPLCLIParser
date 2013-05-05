#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC
#endif

#import <Foundation/Foundation.h>
#import "VPLCommandLineParser.h"

int main(int argc, const char * argv[])
{
  @autoreleasepool
  {
    VPLCLIInterface * interface = [VPLCLIInterface interfaceWithOptions:@[

                                     [VPLCLIOption optionWithName:@"alpha"],
                                     [VPLCLIOption optionWithName:@"help"],
                                   
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
