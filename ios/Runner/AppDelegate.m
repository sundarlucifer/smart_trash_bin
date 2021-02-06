#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  // Add the following line, with your API key
  [GMSServices provideAPIKey: @"---GOOGLE-GEO-API-KEY-HERE---"];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
