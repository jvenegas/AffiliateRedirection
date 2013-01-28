//
//  RootController.m
//  AffiliateRedirection
//
//  Created by FJ Venegas on 27/01/2013.
//  Copyright (c) 2013 Javier Venegas. All rights reserved.
//

#import "RootController.h"
#import "AffiliateRedirection.h"

@interface RootController ()

@end

@implementation RootController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)getLoadingView
{
    CGRect frame = self.view.frame;
    frame.origin = CGPointZero;
    
    UIView *loadingAppStoreView = [[UIView alloc] initWithFrame:frame];
    loadingAppStoreView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:0.8f];
    loadingAppStoreView.userInteractionEnabled = YES;
    
    UIActivityIndicatorView *aIView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140.0f, 170.0f, 40.0f, 40.0f)];
    aIView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [aIView startAnimating];
    [loadingAppStoreView addSubview:aIView];
    
    return loadingAppStoreView;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *title;
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            title = @"Evernote through Georiot";
            break;
            
        case 1:
            title = @"iTunes URL - Evernote";
            break;
            
        case 2:
            title = @"No redirection URL";
            break;
            
        case 3:
            title = @"No URL";
            break;
            
        case 4:
            title = @"No delegate";
            break;
    }
    
    cell.textLabel.text = title;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AffiliateRedirection *affilateRedirection = [[AffiliateRedirection alloc] init];
    id delegate = nil;
    NSURL *affiliateLink = nil;
    
    switch (indexPath.row) {
        case 0:
            delegate = self;
            affiliateLink = [NSURL URLWithString:@"http://target.georiot.com/Proxy.ashx?grid=17342&id=uZpkajcoNlg&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=https%253A%252F%252Fitunes.apple.com%252Fus%252Fapp%252Fevernote%252Fid281796108%253Fmt%253D8%2526uo%253D4%2526partnerId%253D30"];
            break;
            
        case 1:
            delegate = self;
            affiliateLink = [NSURL URLWithString:@"http://itunes.apple.com/us/app/id281796108?mt=8"];
            break;
            
        case 2:
            delegate = self;
            affiliateLink = [NSURL URLWithString:@"http://www.google.es"];
            break;
            
        case 3:
            delegate = self;
            break;
            
        case 4:
            affiliateLink = [NSURL URLWithString:@"http://target.georiot.com/Proxy.ashx?grid=17342&id=uZpkajcoNlg&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=https%253A%252F%252Fitunes.apple.com%252Fus%252Fapp%252Fevernote%252Fid281796108%253Fmt%253D8%2526uo%253D4%2526partnerId%253D30"];
            break;
    }
    
    UIView *loadingAppStoreView = [self getLoadingView];
    [self.view addSubview:loadingAppStoreView];
    
    [affilateRedirection openAffiliateRedirectionWith:affiliateLink
                                productViewController:delegate
                                                block:^(NSURL *itunesURL, NSError *error) {
            //Removes Loading View
            [loadingAppStoreView removeFromSuperview];
            
            if (error) {
                if (!itunesURL) {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:error.localizedDescription
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil,
                                       nil];
                    [av show];
                }
                else {
                    
                    [[UIApplication sharedApplication] openURL:itunesURL];
                }
            }
                                                }];
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SKStore Product ViewController Delegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
