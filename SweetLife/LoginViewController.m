//
//  LoginViewController.m
//  EwwKittens
//
//  Created by Marion Ano on 4/8/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    //cannot do segue in viewDidLoad
    //place check if user exists so people don't have to register over and over again
    PFUser *user = [PFUser currentUser];
    //if user.username is not empty or non-existent
    if (user.username != nil)
    {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRegisterButtonPressed:(id)sender;
{
    //dismiss keyboard
    [self.userNameField resignFirstResponder];
    [self.emailAddressField resignFirstResponder];
    [self.emailPasswordField resignFirstResponder];
    [self.reEnterPasswordField resignFirstResponder];
    [self checkFieldsComplete];
}

- (IBAction)onAlreadyUserButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
                       self.LogInOverlayView.frame = self.view.frame;
                   }];

}


//- (IBAction)onAlreadyRegisteredPressed:(id)sender
//{
//    [UIView animateWithDuration:0.3 animations:^{
//               self.LogInOverlayView.frame = self.view.frame;
//           }];
//}


//- (IBAction)onAlreadyRegisteredPressed:(id)sender
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        self.LogInOverlayView.frame = self.view.frame;
//    }];
//}

- (IBAction)onLogInButtonPressed:(id)sender
{
    [PFUser logInWithUsernameInBackground:self.logInUserTextField.text password:self.logInPasswordTextField.text block:^(PFUser *user, NSError *error) {
        if (!error)
        {
            NSLog(@"Login User");
            self.logInUserTextField.text = nil;
            self.logInPasswordTextField.text = nil;
            self.userNameField.text = nil;
            self.emailAddressField.text = nil;
            self.emailPasswordField.text = nil;
            self.reEnterPasswordField.text = nil;
            //is this where the problem is??
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        if (error)
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"ooops" message:@"sorry we had a problem logging you in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        
    }];
}


//help method to make sure that the
-(void)checkFieldsComplete
{
    if ([self.userNameField.text isEqualToString:@""] || [self.emailAddressField.text isEqualToString:@""] || [self.emailPasswordField.text isEqualToString:@""] || [self.reEnterPasswordField.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oooooopps" message:@"You need to complete all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        [self checkPasswordsMatch];
    }
    
}

-(void)checkPasswordsMatch
{
    if (![self.emailPasswordField.text isEqualToString:self.reEnterPasswordField.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oooooopps" message:@"You need to complete all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        [self registerNewUser];
    }
    
}
//here is where parse comes in:
-(void)registerNewUser
{
    //in here we create a new PFUser
    PFUser *newUser = [PFUser user];
    newUser.username = self.userNameField.text;
    newUser.email = self.emailAddressField.text;
    newUser.password = self.emailPasswordField.text;
    
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            NSLog(@"Registration Success");
            self.logInUserTextField.text = nil;
            self.logInPasswordTextField.text = nil;
            self.userNameField.text = nil;
            self.emailAddressField.text = nil;
            self.emailPasswordField.text = nil;
            self.reEnterPasswordField.text = nil;
            //since registration is successful it segues into the app
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        
        else
        {
            NSLog(@"There was an error in registration");
        }
    }];
}

@end