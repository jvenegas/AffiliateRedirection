AffiliateRedirection
====================

With AffiliateRedirection you will increase the user experience in iOS Apps. This classes open Affiliate links avoiding the double jump between App -> Safari -> App Store, or opening the `SKStoreProductViewController` with the proper app after doing the URL redirection of the affiliate link. Get revenues without leaving the App.

This Class works opening a `NSURLConnection` asynchronously and given the final URL when the redirection is complete.

It works with affiliate links like LinkShare, TradeDoubler, Georiot,...

The library has been tested iOS 4.3+ and ARC environments.

__*Important note if your project doesn't use ARC*: you must add the @-fobjc-arc@ compiler flag to @ODRefreshControl.m@ in Target Settings > Build Phases > Compile Sources.__

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
```objc
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
        [viewController dismissViewControllerAnimated:YES completion:nil];
}
```
## How to

* Import the AffilateRedirection class in your View Controller:
	`#import "AffiliateRedirection.h"`

* You can use one of the following methods to get the iTunes URL after the redirection:
```objc
- (void)openAffiliateRedirectionWith:(NSURL*)affilateURL
                                   block:(AffiliateRedirectionBlock)block;
```
* This is only for iOS 6+
```objc
- (void)openAffiliateRedirectionWith:(NSURL*)affilateURL
                   productViewController:(id)delegate
                                   block:(AffiliateRedirectionBlock)block;
```



* Also `NSURL+Itunes.h` and `NSURL+Itunes.m` is a category of NSURL. This category is used to check if a URL is an iTunes URL as well as a parser to get the productID and the affiliateID of an iTunes URL.

* Example (iOS 6 and lower)
```objc
[affilateRedirection openAffiliateRedirectionWith:affiliateLink
                                productViewController:self
                                                block:^(NSURL *itunesURL, NSError *error) {
            if (error) {
                 if (!itunesURL) {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:error.localizedDescription
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                    [av show];
                }
                else {
                    [[UIApplication sharedApplication] openURL:itunesURL];
                }            
            }
                                     }];
```

## Test the class

You can run the tests in Xcode. Open `AffiliateRedirection/AffiliateRedirection.xcodeproj`.


## Authors

* Javier Venegas https://github.com/jvenegas


## MIT License

Copyright (c) 2013 Javier Venegas

Permission is hereby granted, free of charge, to any
person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the
Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice
shall be included in all copies or substantial portions of
the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
