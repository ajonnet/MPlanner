//
//  VCCustomizer.m
//  MPlanner
//
//  Created by Amit Jain on 20/07/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import "CustomVC.h"
#import "KeyboardHandler.h"

@interface CustomVC ()
{
    KeyboardHandler *keybHandler;
}
@end

@implementation CustomVC

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

    //Hide the Navigation Bar
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
    
    /*
    //Initializing Keyboard handler
    keybHandler = [[KeyboardHandler alloc] init];
    keybHandler.inputItems = self.InputItemsArr;
    keybHandler.hostingSCVW = self.scvw;
     */
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //configuring the scrollView
    if (self.scvw && self.scvwContentView) {
        self.scvw.contentSize = self.scvwContentView.bounds.size;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction methods
- (IBAction)onBackBtClick:(id)sender {
    
    //Pop current object Navigation Stack
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Public methods
-(void) showErrorWithMsg:(NSString *) msg
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:nil] show];
}
@end
