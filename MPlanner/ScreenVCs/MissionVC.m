//
//  MissionVC.m
//  MPlanner
//
//  Created by Amit Jain on 20/07/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import "MissionVC.h"

@interface MissionVC ()
{
    Mission *mission;
}

@property (weak, nonatomic) IBOutlet UITextField *tfMission;
@end

@implementation MissionVC

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:NextBtId]) {
        CustomVC *vc = [segue destinationViewController];
        vc.mMission = mission;
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:NextBtId]) {
        
        //Fetch Mission Statement
        NSString *missionTitle = self.tfMission.text;
        missionTitle = [missionTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //Mission Statement Empty Check
        if (missionTitle.length == 0) {
            [self showErrorWithMsg:@"Mission statement cannot be empty"];
            return NO;
        }
        
        //Create Mission Object
        mission = [[Mission alloc] init];
        mission.mTitle = missionTitle;
    }
    
    return YES;
}


@end
