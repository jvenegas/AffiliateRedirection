//
//  AffiliateRedirection.m
//  AffiliateLinks
//
//  Created by FJ Venegas on 26/01/2013.
//  Copyright (c) 2013 Javier Venegas. All rights reserved.
//

#import "AffiliateRedirection.h"

NSString * const kAFDomain = @"affiliateRedirection.com";

NSInteger const kAFErrorAffiliateURLMissing                             = 1;
NSInteger const kAFErrorAffiliateroductViewControllerDelegateNotFound   = 2;
NSInteger const kAFErrorAffiliatePresentModalViewControllerNotFound     = 3;
NSInteger const kAFErrorAffiliateProductIDNotFound                      = 4;
NSInteger const kAFErrorAffiliateItunesURLNotFound                      = 5;

@interface AffiliateRedirection(Private)

- (void)openAffiliateURL;
- (void)showStoreProductViewController:(NSURL*)iTunesURL;

@end

@implementation AffiliateRedirection

- (id)init
{
    self = [super init];
    if (self) {
        //Sets default Timeout for the connection
        self.timeoutRequest = 10.0f;
    }
    return self;
}

- (id)initWithURL:(NSURL*)affilateLink
{
    self = [self init];
    if (self) {
        
        self.affilateURL = affilateLink;
    }
    return self;
}

- (void)setAffilateURL:(NSURL *)affilateURL
{
    _affilateURL = affilateURL;
    redirectURL = _affilateURL;
}

- (void)openAffiliateRedirectionWith:(NSURL *)affilateURL
                               block:(AffiliateRedirectionBlock)block
{
    self.affilateURL = affilateURL;
    [self openAffiliateRedirectionWithBlock:block];
}

- (void)openAffiliateRedirectionWithBlock:(AffiliateRedirectionBlock)block
{
    if (!_affilateURL) {
        block(nil, [NSError errorWithDomain:kAFDomain
                                       code:kAFErrorAffiliateURLMissing
                                   userInfo:@{NSLocalizedDescriptionKey: @"Affiliate URL not founded"}]);
    }
    else {
        self.block = block;
        [self openAffiliateURL];
    }
}

- (void)openAffiliateRedirectionWithProductViewController:(id)delegate
                                                    block:(AffiliateRedirectionBlock)block
{
    if ([delegate respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        
        if ([delegate respondsToSelector:@selector(productViewControllerDidFinish:)]) {
            
            _delegate = delegate;
            [self openAffiliateRedirectionWithBlock:block];
        }
        else {
            
            block(nil, [NSError errorWithDomain:kAFDomain
                                           code:kAFErrorAffiliateroductViewControllerDelegateNotFound
                                       userInfo:@{NSLocalizedDescriptionKey: @"Delegate does not respond to SKStoreProductViewControllerDelegate"}]);
        }
    }
    else {
        
        block(nil, [NSError errorWithDomain:kAFDomain
                                       code:kAFErrorAffiliatePresentModalViewControllerNotFound
                                   userInfo:@{NSLocalizedDescriptionKey: @"Delegate does not respond to presentViewController:animated:completion:"}]);
    }
}

- (void)openAffiliateRedirectionWith:(NSURL *)affilateURL
               productViewController:(id)delegate
                               block:(AffiliateRedirectionBlock)block
{
    self.affilateURL = affilateURL;
    [self openAffiliateRedirectionWithProductViewController:delegate block:block];
}

- (void)showStoreProductViewController:(NSURL*)iTunesURL
{
    NSLog(@"%@", iTunesURL);
    NSNumber *productID = [iTunesURL productID];
    //Checks if the productID is in the itunes URL
    if (productID) {
        
        //Presents a SKStoreProductViewController with the product ID
        SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
        NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier:[iTunesURL productID]};
        
        [_delegate presentViewController:storeViewController
                                animated:YES
                              completion:^{
                                  [storeViewController loadProductWithParameters:parameters
                                                                 completionBlock:^(BOOL result, NSError *error) {
                                                                     //Gives the response to the delegate
                                                                     storeViewController.delegate = _delegate;
                                                                     
                                                                     if (!result){
                                                                         NSLog(@"%@",error);
                                                                         _block(iTunesURL, error);
                                                                     }
                                                                     else {
                                                                         _block (iTunesURL, nil);
                                                                     }
                                                                 }
                                   ];
                              }];
    }
    else {
        _block(iTunesURL, [NSError errorWithDomain:kAFDomain
                                              code:kAFErrorAffiliateProductIDNotFound
                                          userInfo:@{NSLocalizedDescriptionKey: @"App ID cannot be founded"}]);
    }
}

- (void)openAffiliateURL
{
    // Some of our URLs are referral URLs that cause a redirect and some aren't.
    
    // About whether a URL is a referral or not, make openAffiliateURL able to handle both kinds of URLs.
    //
    // If the URL is a referral URL then redirectResponse (below) is called one or more times with a non-nil response objet and URL
    //
    // If the URL is a non-referral URL then redirectResponse (below) is called with a nil response object
    //
    // Store the original URL and update based on whether or not a redirection hapens i.e. non-nil response object

    
    NSMutableURLRequest *affiliateRequest = [NSMutableURLRequest requestWithURL:_affilateURL];
    affiliateRequest.timeoutInterval = self.timeoutRequest;
    
    [NSURLConnection connectionWithRequest:affiliateRequest
                                  delegate:self];
}

#pragma mark - NSURLConnection Delegate

// handle redirections
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    //
    // If a redirect occurs then response will be non-nil so save the most recent URL in case multiple redirects occur.
    //
    // If no redirect occurs then don't update the iTunesURL
    //
    // If the url is an itunes URL then cancel the connection and process the URL
    //
    
    NSURL *url = response.URL;
    
    if (url) {
        redirectURL = url;
    }
    
    if([NSURL isItunesURL:url]) {
        
        [connection cancel];
        [self connectionDidFinishLoading:connection];
        
        return nil;
    }
    else {
        
        return request;
    }
}

// No more redirects; use the last URL saved in affiliateResponse
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSURL *iTunesURL = redirectURL;
    
    if ([NSURL isItunesURL:iTunesURL]) {
        //iOS6
        if (NSClassFromString(@"SKStoreProductViewController") && _delegate){
            [self showStoreProductViewController:iTunesURL];
            
        }
        else {
            if (_delegate) {
                NSError *error = [NSError errorWithDomain:kAFDomain
                                                     code:kAFErrorAffiliateroductViewControllerDelegateNotFound
                                                 userInfo:@{NSLocalizedDescriptionKey: @"Delegate does not respond to SKStoreProductViewControllerDelegate"}];
                _block(iTunesURL, error);
            }
            else {
                _block (iTunesURL, nil);
            }
        }
    }
    else {
        //This is a non itunes redirection. Pass error and url to the block
        NSError *error = [NSError errorWithDomain:kAFDomain
                                             code:kAFErrorAffiliateItunesURLNotFound
                                         userInfo:@{NSLocalizedDescriptionKey: @"Itunes URL not founded"}];
        _block(iTunesURL, error);
    }
}

// Generic error handling
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
    if (_block) {
        _block(nil, error);
    }
}

@end
