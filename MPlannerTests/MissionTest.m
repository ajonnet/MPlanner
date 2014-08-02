//
//  MissionTest.m
//  MPlanner
//
//  Created by Amit Jain on 27/07/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Mission.h"

@interface MissionTest : XCTestCase
{
    Mission *missionObj;
}

@end


@implementation MissionTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    missionObj = [[Mission alloc] init];
    missionObj.mTitle = @"Choose College";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    missionObj = nil;
}

- (void) testBestOption
{
    Option *college1 = [[Option alloc] init];
    college1.mTitle = @"College A";
    Option *college2 = [[Option alloc] init];
    college2.mTitle = @"College B";
    
    //Adding options
    missionObj.mOptions = @[college1,college2];
    
    Criterion *criterion1 = [[Criterion alloc] init];
    criterion1.mTitle = @"Location";
    Criterion *criterion2 = [[Criterion alloc] init];
    criterion2.mTitle = @"Placement";
    Criterion *criterion3 = [[Criterion alloc] init];
    criterion3.mTitle = @"Education";
    Criterion *criterion4 = [[Criterion alloc] init];
    criterion4.mTitle = @"Fees";
    
    //Adding Criterions
    missionObj.mCriterions = @[criterion1,criterion2,criterion3,criterion4];
    
    //Setting Rating of Criterions for College 1
    [missionObj setRating:@(7) ofCriterion:criterion1 forOption:college1];
    [missionObj setRating:@(3) ofCriterion:criterion2 forOption:college1];
    [missionObj setRating:@(1) ofCriterion:criterion3 forOption:college1];
    [missionObj setRating:@(2) ofCriterion:criterion4 forOption:college1];

    //Setting Rating of Criterions for College 2
    [missionObj setRating:@(8) ofCriterion:criterion1 forOption:college2];
    [missionObj setRating:@(7) ofCriterion:criterion2 forOption:college2];
    [missionObj setRating:@(6) ofCriterion:criterion3 forOption:college2];
    [missionObj setRating:@(5) ofCriterion:criterion4 forOption:college2];

    
    //Setting relative order among various Criterions
    [missionObj setOrder:NSOrderedDescending forCriterionA:criterion1 andCriterionB:criterion2];
    [missionObj setOrder:NSOrderedAscending forCriterionA:criterion1 andCriterionB:criterion3];
    [missionObj setOrder:NSOrderedSame forCriterionA:criterion1 andCriterionB:criterion4];
    [missionObj setOrder:NSOrderedAscending forCriterionA:criterion2 andCriterionB:criterion3];
    [missionObj setOrder:NSOrderedSame forCriterionA:criterion2 andCriterionB:criterion4];
    [missionObj setOrder:NSOrderedDescending forCriterionA:criterion3 andCriterionB:criterion4];
    
    Option *bestOption = [missionObj renderBestOption];
    NSLog(@"BestOption: %@",bestOption);
    
}

@end
