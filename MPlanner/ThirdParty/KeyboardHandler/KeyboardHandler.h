//
//  KeyboardHandler.h
//  Keyboard Handler
//
//  Created by Amit Jain on 25/04/13.
//  Copyright (c) 2013 ajonnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardHandler : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic,copy) NSArray *inputItems;
@property (nonatomic,strong) UIScrollView *hostingSCVW;
@property (nonatomic, readwrite) BOOL showNavigationAccessory;
@end
