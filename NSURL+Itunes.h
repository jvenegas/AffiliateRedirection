//
//  NSURL+Itunes.h
//  AffiliateLinks
//
//  Created by FJ Venegas on 27/01/2013.
/*
 MIT License
 
 Copyright (c) 2013 Javier Venegas
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
