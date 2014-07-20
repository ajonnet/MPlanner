//
//  VCCustomizer.h
//  MPlanner
//
//  Created by Amit Jain on 20/07/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mission.h"

#define NextBtId @"NextBt"

@interface CustomVC : UIViewController

@property (nonatomic, strong) Mission *mMission;

-(void) showErrorWithMsg:(NSString *) msg;
@end
