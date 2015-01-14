//
//  ViewController.h
//  NuweScoreDevApp
//
//  Created by Ahmed Ghalab on 11/10/14.
//  Copyright (c) 2014 Nu Wellness Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NuweScoreCharts/NuweScoreCharts.h>

@interface ViewController : UIViewController <NUDialChartDataSource, NUDialChartDelegate>

@property (strong, nonatomic) IBOutlet UIView *BigDialChartContainerView;
@property (strong, nonatomic) IBOutlet NUDialChart *BigDialChart;

@end

