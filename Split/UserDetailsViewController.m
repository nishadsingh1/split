#import "UserDetailsViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation UserDetailsViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Your Profile";
        
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    self.continueButton.enabled = NO;
    
    [super viewDidLoad];
    

    
    // Add logout navigation bar button
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(logoutButtonAction:)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    [self _loadData];
}

#pragma mark -
#pragma mark UITableViewDataSource



#pragma mark -
#pragma mark Actions

- (void)logoutButtonAction:(id)sender {
    // Logout user, this automatically clears the cache
    [PFUser logOut];
    
    // Return to login view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Data

- (void)_loadData {
    // If the user is already logged in, display any previously cached values before we get the latest from Facebook.
    if ([PFUser currentUser]) {
        [self _updateProfileData];
    }
    
    // Send request to Facebook
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            PFUser * currentUser = [PFUser currentUser];
            if (facebookID) {
                currentUser[@"facebookId"] = facebookID;
            }
            
            NSString *name = userData[@"name"];
            if (name) {
                currentUser[@"name"] = name;
            }
            
            NSString *firstName = userData[@"first_name"];
            if (name) {
                currentUser[@"firstName"] = firstName;
            }
            
            
            NSString * pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            
            if(pictureURL){
                currentUser[@"pictureURL"] = pictureURL;
            }
            
            [[PFUser currentUser] saveInBackground];
            
            [self _updateProfileData];
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [self logoutButtonAction:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

// Set received values if they are not nil and reload the table
- (void)_updateProfileData {
    
    // Set the name in the header view label
    NSString *name = [PFUser currentUser][@"name"];
    if (name) {
        self.headerNameLabel.text = name;
        
    }
    NSString *firstName = [PFUser currentUser][@"firstName"];
    if(firstName){
        self.welcomeText.text = [[@"Welcome, " stringByAppendingString:firstName] stringByAppendingString:@"!"];
    }
    
    NSString *userProfilePhotoURLString = [PFUser currentUser][@"pictureURL"];
    // Download the user's facebook profile picture
    if (userProfilePhotoURLString) {
        NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil && data != nil) {
                                       self.profPicBox.image = [UIImage imageWithData:data];
                                       
                                       // Add a nice corner radius to the image
//                                       self.headerImageView.layer.cornerRadius = 8.0f;
//                                       self.headerImageView.layer.masksToBounds = YES;
                                   } else {
                                       NSLog(@"Failed to load profile photo.");
                                   }
                               }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    NSString * phoneInput = self.phoneNumberField.text;
    self.continueButton.enabled = [self isValidPhoneNumber: phoneInput];
    
}

-(BOOL) isValidPhoneNumber: (NSString *) number{
    return [number length] >=10;
}

- (IBAction)continue:(id)sender {
    [PFUser currentUser][@"phoneNumber"] = self.phoneNumberField.text;
    [[PFUser currentUser] saveInBackground];
//    [self _presentUserDetailsViewControllerAnimated:YES];
}
@end
