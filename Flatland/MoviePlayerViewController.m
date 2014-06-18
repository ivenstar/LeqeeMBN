//
//  MoviePlayerViewController.m
//  Flatland
//
//  Created by Jochen Block on 09.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "MoviePlayerViewController.h"

@interface MoviePlayerViewController ()
    
@end

@implementation MoviePlayerViewController

#pragma mark - Autorotation

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationPortrait|UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight;
}


@end
