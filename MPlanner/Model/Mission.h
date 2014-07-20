//
//  Mission.h
//  MPlanner
//
//  Created by Amit Jain on 20/07/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mission : NSObject

@property (nonatomic, strong)           NSString *mTitle;
@property (nonatomic, strong)           NSArray  *mOptions;
@property (nonatomic, strong)           NSArray  *mCriterions;
@property (nonatomic, strong, readonly) NSArray  *mRatings;
@property (nonatomic, strong, readonly) NSArray  *mPriorities;

-(BOOL) setRating:(NSNumber *) rating
     forCriterion:(NSUInteger) criterionIdx
         ofOption:(NSUInteger) optionIdx;

-(BOOL) setOrder:(NSComparisonResult) order
   forCriterionA:(NSUInteger) criterionAIdx
   andCriterionB:(NSUInteger) criterionBIdx;
@end
