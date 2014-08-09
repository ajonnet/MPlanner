//
//  OrderInputV.h
//  MPlanner
//
//  Created by Amit Jain on 10/08/14.
//  Copyright (c) 2014 ajonnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInputV : UIView

@property (nonatomic, readwrite) NSUInteger mIdx;
@property (nonatomic, weak) NSArray *mLeftCriterions;
@property (nonatomic, weak) NSArray *mRightCriterions;
@property (nonatomic, weak) NSMutableArray *mOrders;

+(OrderInputV *) getInstance;
@end
