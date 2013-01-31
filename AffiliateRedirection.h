//
//  AffiliateRedirection.h
//  AffiliateLinks
//
//  Created by FJ Venegas on 26/01/2013.
/*
 MIT License
 
 Copyright (c) 2013 Javier Venegas
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "NSURL+Itunes.h"

extern NSInteger const kAFErrorAffiliateURLMissing;
extern NSInteger const kAFErrorAffiliateroductViewControllerDelegateNotFound;
extern NSInteger const kAFErrorAffiliatePresentModalViewControllerNotFound;
extern NSInteger const kAFErrorAffiliateProductIDNotFound;
extern NSInteger const kAFErrorAffiliateItunesURLNotFound;

typedef void (^AffiliateRedirectionBlock)(NSURL *itunesURL, NSError *error);


@interface AffiliateRedirection : NSObject
{
    NSURL *redirectURL;
    __unsafe_unretained id _delegate;
    
}

@property (nonatomic ,copy) NSURL *affilateURL;//This is the original URL before the redirection
@property (nonatomic ,copy) AffiliateRedirectionBlock block;//Block to give the result
@property (assign) NSTimeInterval timeoutRequest;//Maximum time to do the redirection. Default: 10 seconds


/*
 Initializes the object with an affiliate link.
 
 @param affiliateLink The URL object with the affiliate link.
 */
- (id)initWithURL:(NSURL*)affilateURL;

/*
 Get a URL after the asynchronously redirection and calls the given block with the result.

 @param affilateURL The URL of the affiliate link will be redirected
 @param block The block to execute. The block should have the following argument signature:(ItunesURL *iTunesURL, NSError *error) iTunesURL will be nil if any of the given are malformed. error will be nil if the redirection is succeeded.
 */
- (void)openAffiliateRedirectionWith:(NSURL*)affilateURL
                               block:(AffiliateRedirectionBlock)block;

/*
 Get a URL after the asynchronously redirection and calls the given block with the result.
 
 @param block The block to execute. The block should have the following argument signature:(ItunesURL *iTunesURL, NSError *error) iTunesURL will be nil if any of the given are malformed. error will be nil if the redirection is succeeded.
 */
- (void)openAffiliateRedirectionWithBlock:(AffiliateRedirectionBlock)block;

/*
 Get a URL after the asynchronously redirection and calls the given block with the result.
 
 @param affilateURL The URL of the affiliate link will be redirected
 @param delegate The object to call SKStoreProductViewController on
 @param block The block to execute. The block should have the following argument signature:(ItunesURL *iTunesURL, NSError *error) iTunesURL will be nil if any of the given are malformed. error will be nil if the redirection is succeeded.
 */
- (void)openAffiliateRedirectionWith:(NSURL*)affilateURL
               productViewController:(id)delegate
                               block:(AffiliateRedirectionBlock)block;

/*
 Get a URL after the asynchronously redirection and calls the given block with the result.
 
 @param delegate The object to call SKStoreProductViewController on
 @param block The block to execute. The block should have the following argument signature:(ItunesURL *iTunesURL, NSError *error) iTunesURL will be nil if any of the given are malformed. error will be nil if the redirection is succeeded.
 */

- (void)openAffiliateRedirectionWithProductViewController:(id)delegate
                                                    block:(AffiliateRedirectionBlock)block;


@end
