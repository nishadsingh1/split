//
//  LoginViewController.h
//  Split
//
//  Created by Nishad Singh on 2/9/15.
//  Copyright (c) 2015 Nishad Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)loginButtonTouchHandler:(id)sender;

@end
