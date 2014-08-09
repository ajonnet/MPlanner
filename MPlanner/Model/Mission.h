//
//  Mission.h
//  MPlanner
//
//  Created by Amit Jain on 20/07/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Option;
@class Criterion;

@interface Mission : NSObject <NSCoding>

@property (nonatomic, strong)   NSString *mTitle;
@property (nonatomic, strong)   NSArray  *mOptions;
@property (nonatomic, strong)   NSArray  *mCriterions;

//Order
-(void) setOrder:(NSComparisonResult) order
   forCriterionA:(Criterion *) criterionA
   andCriterionB:(Criterion *) criterionB;
-(NSComparisonResult) getOrderBtwCriterionA:(Criterion *) criterionA
                              andCriterionB:(Criterion *) criterionB;

//Rating
-(void) setRating:(NSNumber *) rating
      ofCriterion:(Criterion *) criterion
        forOption:(Option *) option;
-(NSNumber *) getRatingOfCriterion:(Criterion *) criterion
                         forOption:(Option *) option;

-(Option *) renderBestOption;
@end

@interface Option : NSObject <NSCoding>

@property (nonatomic, strong) NSString *mTitle;
@end

@interface Criterion : NSObject <NSCoding>

@property (nonatomic, strong) NSString *mTitle;
@end
