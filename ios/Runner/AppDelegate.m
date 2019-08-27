#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  // Add the following line, with your API key
  [GMSServices provideAPIKey: @"AIzaSyBc2Bnq8n7Sr8QgDUymx7saKPv2-XfiU8o"];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
