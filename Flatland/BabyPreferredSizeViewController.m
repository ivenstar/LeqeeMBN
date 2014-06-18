//
//  BabyPreferredSizeViewController.m
//  Flatland
//
//  Created by Magdalena Kamrowska on 02.07.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BabyPreferredSizeViewController.h"
#import "FlatRadioButtonGroup.h"
#import "FlatButton.h"

@interface BabyPreferredSizeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *capsuleImage;
@property (weak, nonatomic) IBOutlet FlatRadioButtonGroup *preferredSizeGroup;
@property (weak, nonatomic) IBOutlet UILabel *shortText;
@property (weak, nonatomic) IBOutlet UILabel *priceDescriptionLabel;
@property (weak, nonatomic) IBOutlet FlatButton *smallButton;
@property (weak, nonatomic) IBOutlet FlatButton *largeButton;
@property (weak, nonatomic) IBOutlet UILabel *longText;

- (IBAction)pickSize:(id)sender;

@end

@implementation BabyPreferredSizeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_capsuleImage setImage:[UIImage imageNamed:_capsule.imageName]];
    [((UIButton*)_preferredSizeGroup.buttons[0]) setTitle:[NSString stringWithFormat:@"%@ %@", _capsule.sizes[0],T(@"%bottlefeeding.ml")] forState:UIControlStateNormal];
    [((UIButton*)_preferredSizeGroup.buttons[1]) setTitle:[NSString stringWithFormat:@"%@ %@", _capsule.sizes[1],T(@"%bottlefeeding.ml")] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonPressed) name:@"groupButtonPressed" object:nil];
    [_preferredSizeGroup refreshButtons];
    _shortText.text = _capsule.dailyRecommendation;
    _priceDescriptionLabel.text = [NSString stringWithFormat:T(@"%babyprofile.capsules.summary"), _capsule.name, _capsule.sizes[0], FormatPrice(((NSNumber*)_capsule.prices[0]).integerValue)];
    [_longText setText:[NSString stringWithFormat:T(@"%babyprofile.capsule.text"), _capsule.name]];
    
//    if (IS_IOS7)
//    {
//        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
//        
//        UIView *blackBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//        [blackBar setBackgroundColor:[UIColor blackColor]];
//        
//        [self.view addSubview:blackBar];
//    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)pickSize:(id)sender {
    NSString *size;
    switch (self.preferredSizeGroup.selectedIndex) {
        case 0:
            size = @"Small";
            break;
        case 1:
            size = @"Large";
            break;
        default:
            size = @"Small";
            break;
    }
    [self.delegate picker:self didSelectPreferredSize:size];
}

- (void) buttonPressed {
    switch (self.preferredSizeGroup.selectedIndex) {
        case 0:
            _priceDescriptionLabel.text = [NSString stringWithFormat:T(@"%babyprofile.capsules.summary"), _capsule.name, _capsule.sizes[0], FormatPrice(((NSNumber*)_capsule.prices[0]).integerValue)];
            break;
        case 1:
            _priceDescriptionLabel.text = [NSString stringWithFormat:T(@"%babyprofile.capsules.summary"), _capsule.name, _capsule.sizes[1], FormatPrice(((NSNumber*)_capsule.prices[1]).integerValue)];
            break;
        default:
            _priceDescriptionLabel.text = [NSString stringWithFormat:T(@"%babyprofile.capsules.summary"), _capsule.name, _capsule.sizes[0], FormatPrice(((NSNumber*)_capsule.prices[0]).integerValue)];
            break;
    }
}

@end
