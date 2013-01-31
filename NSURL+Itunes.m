//
//  NSURL+Itunes.m
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

#import "NSURL+Itunes.h"

NSString * const ItunesDomain = @"itunes.apple.com";

@implementation NSURL (Itunes)

+ (BOOL)isItunesURL:(NSURL *)candidateURL
{
    return [candidateURL.host hasSuffix:ItunesDomain];
}

- (NSNumber*)productID
{
    if ([[self class] isItunesURL:self]) {
        NSArray *params = [self.lastPathComponent componentsSeparatedByString:@"&"];
        for (NSString *param in params) {
            if ([param hasPrefix:@"id"]) {//Include in param name (Ex: id123123)
                return [NSNumber numberWithLongLong:[[param substringFromIndex:2] longLongValue]];
            }
        }
    }
    
    return nil;
}

- (NSNumber*)affiliateID
{
    if ([[self class] isItunesURL:self]) {
        NSArray *params = [self.query componentsSeparatedByString:@"&"];
        for (NSString *param in params) {
            if ([param hasPrefix:@"affId"]) {//Value of the param pair (Ex: affId=123123)
                NSArray *keyValue = [param componentsSeparatedByString:@"="];
                if (keyValue.count > 1) {
                    NSString *affId = keyValue.lastObject;
                    return  [NSNumber numberWithLongLong:[affId longLongValue]];
                }
            }
        }
    }
    
    return nil;
}

- (NSString*)avoidRedirectsString
{
    NSString *stringURL;
    //Replaces the url schema for itms schema
    if ([[self class] isItunesURL:self]) {
         NSString *avoidRedirectString = [self.absoluteString stringByReplacingOccurrencesOfString:self.scheme withString:@"itms"];
        stringURL = avoidRedirectString;
    }
    else {
        stringURL = self.absoluteString;
    }
   
    return stringURL;
}

- (NSURL*)avoidRedirectsURL
{
    return [NSURL URLWithString:[self avoidRedirectsString]];
}

- (NSString*)description
{
    if ([[self class] isItunesURL:self]) {
        return [NSString stringWithFormat:@"ProductID: %@ - AffiliateID: %@ - NSURL: %@", [self productID], [self affiliateID], self.absoluteString];
    }
    else {
        return self.absoluteString;
    }
}

@end
