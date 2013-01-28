//
//  NSURL+Itunes.m
//  AffiliateLinks
//
//  Created by FJ Venegas on 27/01/2013.
//  Copyright (c) 2013 Javier Venegas. All rights reserved.
//

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
