//
//  CMJViewController.m
//  SweetLife
//
//  Created by Claire Jencks on 4/9/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//

#import "CMJViewController.h"

@interface CMJViewController ()

@end

@implementation CMJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
