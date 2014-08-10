//
//  VerdictVC.m
//  MPlanner
//
//  Created by Amit Jain on 20/07/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import "VerdictVC.h"

@interface VerdictVC ()

@property (weak, nonatomic) IBOutlet UIView *vResult;
@property (weak, nonatomic) IBOutlet UIView *vFailure;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;
@end

@implementation VerdictVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Rendering the result
    Option *option = [self.mMission renderBestOption];
    self.vResult.hidden = YES;
    self.vFailure.hidden = YES;
    if (option) {
        self.lblResult.text = option.mTitle;
        self.vResult.hidden = NO;
    }else {
        self.vFailure.hidden = NO;
    }
}

#pragma mark - IBAction methods
- (IBAction)onFinishBtClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:DetailsBtId]) {
        CustomVC *vc = [segue destinationViewController];
        vc.mMission = self.mMission;
    }
}


@end
