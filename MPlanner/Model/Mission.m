//
//  Mission.m
//  MPlanner
//
//  Created by Amit Jain on 20/07/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import "Mission.h"

@implementation Mission

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_mCriterions = [NSArray array];
        self->_mOptions = [NSArray array];
    }
    return self;
}

-(BOOL) setRating:(NSNumber *) rating
     forCriterion:(NSUInteger) criterionIdx
         ofOption:(NSUInteger) optionIdx
{
    //TODO: to be implemented
    
    return true;
}

-(BOOL) setOrder:(NSComparisonResult) order
   forCriterionA:(NSUInteger) criterionAIdx
   andCriterionB:(NSUInteger) criterionBIdx
{
    //TODO: to be implemented
    
    return true;
}

#pragma mark - properties setters and getters
-(void)setMCriterions:(NSArray *)mCriterions
{
    _mCriterions = mCriterions;
    
    //TODO: to be implemented
}

-(void) setMOptions:(NSArray *)mOptions
{
    _mOptions = mOptions;
    
    //TODO: to be implemented
}

#pragma mark - private methods
-(void) updateRatingsAndPrioritiesMatrix
{
    //TODO: to be implemented
}
@end
