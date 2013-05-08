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

                                     [VPLCLIOption optionWithName:@"repeat"
                                                             flag:@"r"
                                                    requiresValue:YES
                                                       identifier:@"repeatCount"],
                                   
                                     [VPLCLIOption optionWithName:@"verbose"
                                                             flag:@"v"],
                                   
                                     [VPLCLIOption optionWithName:@"help"
                                                             flag:@"h"]
                                   
                                   ]];
    
    interface.processTitle = @"Command Line Utility (VPLUtilityExample)";
    interface.processCopyright = @"(c) 2013 Vulpine Labs LLC";
    interface.processDescription = @"A simple command-line argument parsing example";
    
    NSDictionary * commandLineData = [interface dictionaryFromProcessArguments];
    if (commandLineData[@"help"] != nil)
    {
      printf("%s\n", [[interface helpText] UTF8String]);
    }
    else if (commandLineData == nil || [commandLineData count] == 0)
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

