AffiliateRedirection
====================

With AffiliateRedirection you will increase the user experience in iOS Apps. This classes open Affiliate links avoiding the double jump between App -> Safari -> App Store, or opening the `SKStoreProductViewController` with the proper app after doing the URL redirection of the affiliate link. Get revenues without leaving the App.

This Class works opening a NSURLConnection asynchronously and given the final URL when the redirection is complete.

It works with affiliate links like LinkShare, TradeDoubler, Georiot,...

The classes are tested iOS 4.3+, in ARC environments.


## Set up your Xcode project

* Add into your project the following classes:

	`AffiliateRedirection.h`
 	`AffiliateRedirection.m`
	`NSURL+Itunes.h`
	`NSURL+Itunes.m`

* You need to add Store Kit Framework in your project.

          Target -> Build Phases -> Link Binary With Libraries
    
Click on the `+` button to Add `StoreKit.framework`. Set it as `Optional` is the iOS target is lower than `iOS 6`.

* Finally you must add `SKStoreProductViewControllerDelegate` in your View Controller and implement this method to dismiss `SKStoreProductViewController`

          - (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
          {
              [viewController dismissViewControllerAnimated:YES completion:nil];
          }

## How to

* Import the AffilateRedirection class in your View Controller:
	`#import "AffiliateRedirection.h"`

* You can use one of the following methods to get the iTunes URL after the redirection:

          - (void)openAffiliateRedirectionWith:(NSURL*)affilateURL
                                         block:(AffiliateRedirectionBlock)block;

* This is only for iOS 6+

         - (void)openAffiliateRedirectionWith:(NSURL*)affilateURL
                        productViewController:(id)delegate
                                        block:(AffiliateRedirectionBlock)block;




* Also `NSURL+Itunes.h` and `NSURL+Itunes.m` is a category of NSURL. This category is used to check if a URL is an iTunes URL as well as a parser to get the productID and the affiliateID of an iTunes URL.

* Example 

        [affilateRedirection openAffiliateRedirectionWith:affiliateLink
                                    productViewController:self
                                                    block:^(NSURL *itunesURL, NSError *error) {
            if (!error) {
             //Success code here   
            }
                                     }];


## Test the class

You can run the tests in Xcode. Open `AffiliateRedirection/AffiliateRedirection.xcodeproj`.


## Authors

* Javier Venegas https://github.com/jvenegas


## License

Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
