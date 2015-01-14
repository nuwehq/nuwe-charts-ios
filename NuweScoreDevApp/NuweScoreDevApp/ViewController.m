//
//  ViewController.m
//  NuweScoreDevApp
//
//  Created by Ahmed Ghalab on 11/10/14.
//  Copyright (c) 2014 Nu Wellness Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize BigDialChart;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    self.BigDialChart = [[NUDialChart alloc] initWithFrame:self.BigDialChartContainerView.bounds];
    
    [self.BigDialChart setupWithCount:4 TotalValue:100];
    [self.BigDialChart setChartDataSource:self];
    [self.BigDialChart setChartDelegate:self];
    [self.BigDialChart reloadDialWithAnimation:YES];
    
    [self.view addSubview:self.BigDialChart];
}

/* Get current value of specific dial by index
 @param : Index of specific dial
 @return : Current value of the dial
 */
- (NSNumber*) dialChart:(NUDialChart*) dialChart valueOfCircleAtIndex:(int) _index
{
    
    return @30;
}
/* Get a color of specific dial by index
 @param : Index of specific dial
 @return : Color of the dial
 */
- (UIColor* ) dialChart:(NUDialChart*) dialChart colorOfCircleAtIndex:(int) _index
{
    return [UIColor redColor];
}
/* Get a text of specific dial by index
 @param : Index of specific dial
 @return : Text of the dial
 */ // It's for just Nutribu
- (NSString* ) dialChart:(NUDialChart*) dialChart textOfCircleAtIndex:(int) _index
{
    return @"Test string";
}

/* Get a text color of specific dial by index
 @param : Index of specific dial
 @return : Text of the dial
 */ // It's for just Nutribu
- (UIColor* ) dialChart:(NUDialChart*) dialChart textColorOfCircleAtIndex:(int)
_index
{
    return [UIColor greenColor];
}
/* Show center label and text
 @param : No params
 @return : Is show center label?
 */
- (BOOL) isShowCenterLabelInDial:(NUDialChart*) dialChart
{
    return YES;
}
/* Show only border of dial
 @param : Index of specific dial
 @return : Is only frame of dial?
 */
- (BOOL) dialChart:(NUDialChart*) dialChart defaultCircleAtIndex:(int) _index
{
    return NO;
}
/* Get current nuscore
 @param : No params
 @return : NU score
 */
- (int) nuscoreInDialChart:(NUDialChart*) dialChart
{
    return 10;
}
/* Get a color of center label's text color
 @param : Index of specific dial
 @return : Color of the dial
 */
- (UIColor*) centerTextColorInDialChart:(NUDialChart*) dialChart
{
    return [UIColor whiteColor];
}
/* Get a color of center label's background color
 @param : Index of specific dial
 @return : Color of the dial
 */
- (UIColor*) centerBackgroundColorInDialChart:(NUDialChart*) dialChart
{
    return [UIColor grayColor];
}

-(void) touchNuDialChart:(NUDialChart *)chart
{
    [self.BigDialChart reloadDialWithAnimation:YES];
}
@end
