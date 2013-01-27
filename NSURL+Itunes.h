//
//  NSURL+Itunes.h
//  AffiliateLinks
//
//  Created by FJ Venegas on 27/01/2013.
//  Copyright (c) 2013 Javier Venegas. All rights reserved.
//

#import <Foundation/Foundation.h>

/* URL host for all the itunes products. */
extern NSString * const ItunesDomain;

@interface NSURL (Itunes)

/*
 Checks if a URL has itunes product format.
 
 @param candidateURL The URL will be checked if it has Itunes domain as host param.
 */
+ (BOOL)isItunesURL:(NSURL*)candidateURL;

/*
 Gets the product identifier associated to an itunes URL
 */
- (NSNumber*)productID;

/*
 Gets the affiliate identifier associated to an itunes URL
 */
- (NSNumber*)affiliateID;

/*
 Gets URL avoids redirections through Safari. Format: itms://...
 */
- (NSURL*)avoidRedirectsURL;

/*
 Gets string for URL avoids redirections through Safari. Format: itms://...
 */
- (NSString*)avoidRedirectsString;

@end
