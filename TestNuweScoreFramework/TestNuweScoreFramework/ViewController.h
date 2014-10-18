//
//  ViewController.h
//  TestNuweScoreFramework
//
//  Created by Dev Mac on 10/14/14.
//  Copyright (c) 2014 Dimitar Plamenov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NuweScoreChart/NuweScoreFramework.h>

@interface ViewController : UIViewController <NUDialChartDataSource, NUDialChartDelegate>

@property (strong, nonatomic) IBOutlet NUDialChart *BigDialChart;
@property (strong, nonatomic) IBOutlet NUDialChart *TopDialChart1;
@property (strong, nonatomic) IBOutlet NUDialChart *TopDialChart2;


@property (strong, nonatomic) IBOutlet NUDialChart *BottomDialChart1;
@property (strong, nonatomic) IBOutlet NUDialChart *BottomDialChart2;
@property (strong, nonatomic) IBOutlet NUDialChart *BottomDialChart3;





@end

