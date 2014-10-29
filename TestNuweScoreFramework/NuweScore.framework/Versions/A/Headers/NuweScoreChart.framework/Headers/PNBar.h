//
//  PNBar.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol PNBarDelegate <NSObject>

- (void) clickedBar:(id) bar;

@end

@interface PNBar : UIView

@property (nonatomic) float grade;

@property (nonatomic,strong) CAShapeLayer * chartLine;

@property (nonatomic, strong) UIColor * barColor;

@property (nonatomic, assign) id<PNBarDelegate> pDelegate;

-(void)rollBack;

@end
