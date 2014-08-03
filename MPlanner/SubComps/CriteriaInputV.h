//
//  CriteriaInputV.h
//  MPlanner
//
//  Created by Amit Jain on 02/08/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CriteriaInputV : UIView

@property (nonatomic, readwrite) NSUInteger mIdx;
@property (nonatomic, strong) Criterion *mCriterion;
@property (nonatomic, strong) NSArray *mOptions;
@property (nonatomic, strong) NSArray *mRatings;

+(CriteriaInputV *) getInstance;
@end
