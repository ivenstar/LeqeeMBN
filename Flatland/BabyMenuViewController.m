//
//  BabyMenuVew.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 04.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BabyMenuViewController.h"
#import "CircularMaskImageView.h"

@interface BabyMenuViewController ()
@property (weak, nonatomic) IBOutlet UILabel *babyName;
@property (weak, nonatomic) IBOutlet CircularMaskImageView *babyPicture;

@property (strong, nonatomic) Baby *baby;
@end

@implementation BabyMenuViewController

+ (BabyMenuViewController *)babyMenuViewControllerWithBaby:(Baby *)baby {
    BabyMenuViewController *babyMenuView = [[BabyMenuViewController alloc] initWithNibName:NSStringFromClass([BabyMenuViewController class]) bundle:nil];
    babyMenuView.baby = baby;
    return babyMenuView;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self icnhLocalizeView];
    [self.view changeSystemFontToApplicationFont];
    self.babyName.text = self.baby.name;

    //  Set baby image
    [self.baby loadPictureWithCompletion:^(UIImage *picture)
    {
        self.babyPicture.image = picture;
        self.babyPicture.drawBorder = self.highlighted;

    }];
    
    UIButton *babyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    babyButton.frame = self.babyPicture.frame;
    [self.view addSubview:babyButton];
    
    [babyButton addTarget:self action:@selector(babyClicked) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - Actions

- (void)babyClicked {
    [self.delegate babyClicked:self.baby];
}

- (IBAction)editBaby
{
    
    BabyMenuViewContainer *babyview = (BabyMenuViewContainer*)self.view;
    [babyview.editButton setEnabled:NO];
    
    [self.delegate editBaby:self.baby];
    
    [self performSelector:@selector(enableEditButtons) withObject:nil afterDelay:1.0];
    
}

-(void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    self.babyPicture.drawBorder = highlighted;
    [self.babyPicture setNeedsDisplay];
}


-(void)enableEditButtons
{
    BabyMenuViewContainer *babyview = (BabyMenuViewContainer*)self.view;
    [babyview.editButton setEnabled:YES];
}

@end

@interface BabyMenuViewContainer()


@end

@implementation BabyMenuViewContainer

- (void)layoutSubviews
{
        [super layoutSubviews];
}
@end