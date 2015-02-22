//
//  UserDetailsViewController.h
//  
//
//  Created by Nishad Singh on 2/9/15.
//
//

#import <UIKit/UIKit.h>

@interface UserDetailsViewController : UIViewController

// UITableView header view properties
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *headerNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *headerImageView;


@property (weak, nonatomic) IBOutlet UILabel *welcomeText;


@property (weak, nonatomic) IBOutlet UIImageView *profPicBox;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
- (IBAction)continue:(id)sender;

@end
