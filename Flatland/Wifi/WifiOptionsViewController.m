//
//  WifiOptionsViewController.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 19.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WifiOptionsViewController.h"
#import "FlatCheckbox.h"
#import "DynamicSizeContainer.h"
#import "WifiBabyProfilesViewController.h"
#import "AlertView.h"
#import "RESTService.h"
#import "User.h"
#import "WifiPaymentViewController.h"
#import "WebViewViewController.h"

@interface WifiOptionsViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet DynamicSizeContainer *contentView;
@property (weak, nonatomic) IBOutlet FlatCheckbox *firstOption;
@property (weak, nonatomic) IBOutlet FlatCheckbox *secondOption;
@property (weak, nonatomic) IBOutlet FlatCheckbox *thirdOption;
@property (strong, nonatomic) IBOutlet FlatCheckbox *firstCheckFirst;
@property (strong, nonatomic) IBOutlet FlatCheckbox *firstCheckSecond;
@property (strong, nonatomic) IBOutlet UIImageView *firstCheckError;
@property (strong, nonatomic) IBOutlet UIImageView *firstCheckSecondError;
@property (strong, nonatomic) IBOutlet FlatCheckbox *secondCheckFirst;
@property (strong, nonatomic) IBOutlet FlatCheckbox *secondCheckSecond;
@property (strong, nonatomic) IBOutlet UIImageView *secondCheckError;
@property (strong, nonatomic) IBOutlet UIImageView *secondCheckSecondError;
@property (strong, nonatomic) IBOutlet FlatCheckbox *thirdCheckFirst;
@property (strong, nonatomic) IBOutlet UIImageView *thirdCheckError;
@property (strong, nonatomic) IBOutlet FlatCheckbox *thirdCheckSecond;
@property (strong, nonatomic) IBOutlet UIImageView *thirdCheckSecondError;


@property (strong, nonatomic) IBOutlet UILabel *firstOptionTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstOptionFirstLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstOptionSecondLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstOptionThirdLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstOptionFourthLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstOptionFifthLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstOptionPrivacyLabel;
@property (strong, nonatomic) IBOutlet UIButton *firstOptionFirstButton;
@property (strong, nonatomic) IBOutlet UIButton *firstOptionSecondButton;
@property (strong, nonatomic) IBOutlet UIButton *firstOptionThirdButton; //Only Used on US.Please remove if design changes

@property (strong, nonatomic) IBOutlet UILabel *secondOptionTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondOptionFirstLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondOptionSecondLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondOptionThirdLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondOptionFourthLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondOptionFifthLabel;
@property (strong, nonatomic) IBOutlet UIButton *secondOptionFirstButton;
@property (strong, nonatomic) IBOutlet UILabel *secondOptionsPrivacyLabel;
@property (weak, nonatomic) IBOutlet UIButton *secondOptionThirdButton;//Only Used on US.Please remove if design changes


@property (strong, nonatomic) IBOutlet UILabel *thirdOptionTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdOptionFirstLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdOptionSecondLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdOptionThirdLabel;
@property (strong, nonatomic) IBOutlet UIButton *thirdOptionFirstButton;
@property (strong, nonatomic) IBOutlet UILabel *thirdOptionPrivacyLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdOptionFourthLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdOptionFifthLabel;
@property (weak, nonatomic) IBOutlet UIButton *thirdOptionTermsButton;//Only Used on US.Please remove if design changes


@property (nonatomic, readonly) NSInteger selectedViewTag;


@end

@implementation WifiOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (IS_IOS7)
    {
        //lower the scroll view by 20
//        self.scrollView.center = CGPointMake(self.scrollView.center.x, self.scrollView.center.y + 20);
        
        //add a black uiview to act as status bar
//        UIView *blackBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//        [blackBar setBackgroundColor:[UIColor blackColor]];
//        [self.view addSubview:blackBar];
    }
    
    // size the scroll view content size to fit its child view
    self.contentView.gap = 8;
    self.contentView.border = 8;
    
    self.navigationItem.title = T(@"%wifisetup.replenishmentoptions");
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;

#ifdef BABY_NES_US
    _firstOptionSecondLabel.frame = CGRectMake(40, 17, 250, 88);
    _firstOptionThirdLabel.frame = CGRectMake(40, 70, 260, 75);
    
    _firstOptionPrivacyLabel.frame = CGRectMake(73, 123, 217, 53); //privacy text label
    
    [_firstOptionFirstButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_firstOptionSecondButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_firstOptionThirdButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    _firstOptionFirstButton.frame = CGRectMake(40, 180, 227, 17); //privacy link
    _firstOptionSecondButton.frame = CGRectMake(40, 200, 227, 17); //general guilelines link
    _firstOptionThirdButton.frame = CGRectMake(40, 220, 227, 17); //terms and conditions
    
    _firstCheckFirst.frame = CGRectMake(40, 140, 25, 25); //privacy checkbox
    _firstCheckError.frame = CGRectMake(10, 140, 25, 25); //privacy allert img
    
    _secondOptionSecondLabel.frame =  CGRectMake(40, 17, 250, 88);
    _secondOptionThirdLabel.frame =  CGRectMake(40, 74, 250, 75);
    _secondOptionFourthLabel.frame = CGRectMake(40, 120, 250, 75);
    
    _secondOptionsPrivacyLabel.frame = CGRectMake(73, 178, 217, 53); //privacy text label
    
    [_secondOptionFirstButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_secondOptionThirdButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    _secondOptionFirstButton.frame = CGRectMake(40, 245, 227, 17); //privacy link
    _secondOptionThirdButton.frame = CGRectMake(40, 265, 227, 17);//terms and conditions
    
    _secondCheckFirst.frame = CGRectMake(40, 193, 25, 25); //privacy checkbox
    _secondCheckError.frame = CGRectMake(10, 193, 25, 25); //privacy allert img
    
    _thirdOptionSecondLabel.frame = CGRectMake(40, 17, 250, 88);
    
    _thirdOptionThirdLabel.frame = CGRectMake(73, 88, 217, 53); //privacy text label
    
    [_thirdOptionFirstButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    _thirdOptionFirstButton.frame = CGRectMake(40, 150, 227, 17); //privacy link
    [_thirdOptionTermsButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    _thirdOptionTermsButton.frame = CGRectMake(40, 170, 227, 17); //privacy link
    _thirdOptionFirstButton.hidden = NO;
    _thirdOptionTermsButton.hidden = NO;
    
    _thirdCheckFirst.frame = CGRectMake(40, 98, 25, 25); //privacy checkbox
    _thirdCheckError.frame = CGRectMake(10, 98, 25, 25); //privacy allert img
    
    NSLog(@"%@",NSStringFromCGRect([_firstCheckError frame]));
    NSLog(@"%@",NSStringFromCGRect([_firstCheckFirst frame]));
    
    _firstCheckFirst.hidden = NO;
    _firstCheckSecond.hidden = YES;
    
    _secondCheckFirst.hidden = NO;
    _secondCheckSecond.hidden = YES;
    
    _thirdOptionThirdLabel.hidden = NO;
    _thirdCheckFirst.hidden = NO;
    
    
#else
    _firstOptionThirdButton.hidden = YES;
    _secondOptionThirdButton.hidden = YES;
    _thirdOptionTermsButton.hidden = YES;
    
    if ([T(@"%general.language") isEqual:@"fr"] || [T(@"%general.language") isEqual:@"de"])
    {
        int startY = 6;
        
        // First Option
        _firstCheckFirst.hidden = NO;
        _firstCheckSecond.hidden = NO;
        _firstOptionFirstButton.hidden = YES;
        _firstOptionSecondButton.hidden = YES;
        
        _firstOptionTitleLabel.numberOfLines = 0;
        _firstOptionTitleLabel.frame = CGRectMake(40, startY, 250, 100);
        [_firstOptionTitleLabel sizeToFit];
        startY += _firstOptionTitleLabel.frame.size.height + 5;
        
        _firstOptionFirstLabel.frame = CGRectMake(40, startY, 250, 110);
        [_firstOptionFirstLabel sizeToFit];
        startY += _firstOptionFirstLabel.frame.size.height + 10;
        
        _firstOptionSecondLabel.frame = CGRectMake(40, startY, 250, 120);
        [_firstOptionSecondLabel sizeToFit];
        startY += _firstOptionSecondLabel.frame.size.height + 10;
        
        _firstOptionThirdLabel.frame = CGRectMake(40, startY, 250, 90);
        NSRange _firstOptionThirdLabelRange = NSRangeFromString(T(@"%wifiOptions.first.2.boldRange"));
        NSMutableAttributedString *_firstOptionThirdLabelString = [[NSMutableAttributedString alloc] initWithString:T(@"%wifiOptions.first.2")];
        [_firstOptionThirdLabelString addAttribute:NSFontAttributeName value:[UIFont boldFontOfSize: _firstOptionThirdLabel.font.pointSize] range:_firstOptionThirdLabelRange];
        [_firstOptionThirdLabel setAttributedText:_firstOptionThirdLabelString];
        [_firstOptionThirdLabel sizeToFit];
        startY += _firstOptionThirdLabel.frame.size.height + 15;
        
        _firstCheckFirst.frame = CGRectMake(40, startY, 25, 25);
        _firstCheckError.frame = CGRectMake(10, startY, 24, 24);
        _firstOptionPrivacyLabel.frame = CGRectMake(73, startY, 217, 53);
        [_firstOptionPrivacyLabel sizeToFit];
        startY += (_firstOptionPrivacyLabel.frame.size.height > _firstCheckFirst.frame.size.height ? _firstOptionPrivacyLabel.frame.size.height : _firstCheckFirst.frame.size.height ) + 10;
        
        _firstCheckSecond.frame = CGRectMake(40, startY, 25, 25);
        _firstCheckSecondError.frame = CGRectMake(10, startY, 24, 24);
        _firstOptionFourthLabel.frame = CGRectMake(73, startY, 217, 25);
        NSRange _firstOptionFourthLabelRange = NSRangeFromString(T(@"%wifiOptions.first.4.underlineRange"));
        NSMutableAttributedString *_firstOptionFourthLabelString = [[NSMutableAttributedString alloc] initWithString:T(@"%wifiOptions.first.4")];
        [_firstOptionFourthLabelString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:_firstOptionFourthLabelRange];
        [_firstOptionFourthLabel setAttributedText:_firstOptionFourthLabelString];
        UITapGestureRecognizer *_firstOptionFourthLabelGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goConditionsGr)];
        [_firstOptionFourthLabel addGestureRecognizer:_firstOptionFourthLabelGR];
        [_firstOptionFourthLabel setUserInteractionEnabled:YES];
        [_firstOptionFourthLabel sizeToFit];
        startY += (_firstOptionFourthLabel.frame.size.height > _firstCheckSecond.frame.size.height ? _firstOptionFourthLabel.frame.size.height : _firstCheckSecond.frame.size.height ) + 10;
        
        _firstOptionFifthLabel.gestureRecognizers = nil;
        _firstOptionFifthLabel.numberOfLines = 0;
        NSRange _firstOptionFifthLabelFirstRange = NSRangeFromString(T(@"%wifiOptions.first.5.underlineRange"));
        NSRange _firstOptionFifthLabelSecondRange = NSRangeFromString(T(@"%wifiOptions.first.5.underlineRange.1"));
        NSMutableAttributedString *_firstOptionFifthLabelString = [[NSMutableAttributedString alloc] initWithString:T(@"%wifiOptions.first.5")];
        [_firstOptionFifthLabelString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:_firstOptionFifthLabelFirstRange];
        [_firstOptionFifthLabelString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:_firstOptionFifthLabelSecondRange];
        [_firstOptionFifthLabel setAttributedText:_firstOptionFifthLabelString];
        _firstOptionFifthLabel.hidden = NO;
        [_firstOptionFifthLabel setFont:_firstOptionFourthLabel.font];
        _firstOptionFifthLabel.frame = CGRectMake(40, startY, 240, 300);
        [_firstOptionFifthLabel sizeToFit];
        UITapGestureRecognizer *_firstOptionFifthLabelGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTappedFirstOptionFifthLabel:)];
        [_firstOptionFifthLabel addGestureRecognizer:_firstOptionFifthLabelGr];
        [_firstOptionFifthLabel setUserInteractionEnabled:YES];
        
        startY = 6;
        
        // Second option
        _secondCheckFirst.hidden = NO;
        _secondCheckSecond.hidden = NO;
        _secondOptionFirstButton.hidden = YES;
        
        _secondOptionTitleLabel.numberOfLines = 0;
        _secondOptionTitleLabel.frame = CGRectMake(40, startY, 250, 100);
        [_secondOptionTitleLabel sizeToFit];
        startY += _secondOptionTitleLabel.frame.size.height + 5;
        
        _secondOptionFirstLabel.frame = CGRectMake(40, startY, 250, 110);
        [_secondOptionFirstLabel sizeToFit];
        startY += _secondOptionFirstLabel.frame.size.height + 10;
        
        _secondOptionSecondLabel.frame = CGRectMake(40, startY, 250, 120);
        [_secondOptionSecondLabel sizeToFit];
        startY += _secondOptionSecondLabel.frame.size.height + 10;
        
        _secondOptionThirdLabel.frame = CGRectMake(40, startY, 250, 90);
        NSRange _secondOptionThirdLabelRange = NSRangeFromString(T(@"%wifiOptions.second.2.boldRange"));
        NSMutableAttributedString *_secondOptionThirdLabelString = [[NSMutableAttributedString alloc] initWithString:T(@"%wifiOptions.second.2")];
        [_secondOptionThirdLabelString addAttribute:NSFontAttributeName value:[UIFont boldFontOfSize: _secondOptionThirdLabel.font.pointSize] range:_secondOptionThirdLabelRange];
        [_secondOptionThirdLabel setAttributedText:_secondOptionThirdLabelString];
        [_secondOptionThirdLabel sizeToFit];
        startY += _secondOptionThirdLabel.frame.size.height + 15;
        
        _secondCheckFirst.frame = CGRectMake(40, startY, 25, 25);
        _secondCheckError.frame = CGRectMake(10, startY, 24, 24);
        _secondOptionsPrivacyLabel.frame = CGRectMake(73, startY, 217, 53);
        [_secondOptionsPrivacyLabel sizeToFit];
        startY += (_secondOptionsPrivacyLabel.frame.size.height > _secondCheckFirst.frame.size.height ? _secondOptionsPrivacyLabel.frame.size.height : _secondCheckFirst.frame.size.height ) + 10;
        
        _secondCheckSecond.frame = CGRectMake(40, startY, 25, 25);
        _secondCheckSecondError.frame = CGRectMake(10, startY, 24, 24);
        _secondOptionFourthLabel.frame = CGRectMake(73, startY, 217, 25);
        NSRange _secondOptionFourthLabelRange = NSRangeFromString(T(@"%wifiOptions.second.4.underlineRange"));
        NSMutableAttributedString *_secondOptionFourthLabelString = [[NSMutableAttributedString alloc] initWithString:T(@"%wifiOptions.second.4")];
        [_secondOptionFourthLabelString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:_secondOptionFourthLabelRange];
        [_secondOptionFourthLabel setAttributedText:_secondOptionFourthLabelString];
        UITapGestureRecognizer *_secondOptionFourthLabelGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goConditionsGr)];
        [_secondOptionFourthLabel addGestureRecognizer:_secondOptionFourthLabelGR];
        [_secondOptionFourthLabel setUserInteractionEnabled:YES];
        [_secondOptionFourthLabel sizeToFit];
        startY += (_secondOptionFourthLabel.frame.size.height > _secondCheckSecond.frame.size.height ? _secondOptionFourthLabel.frame.size.height : _secondCheckSecond.frame.size.height ) + 10;
        
        _secondOptionFifthLabel.gestureRecognizers = nil;
        _secondOptionFifthLabel.numberOfLines = 0;
        NSRange _secondOptionFifthLabelFirstRange = NSRangeFromString(T(@"%wifiOptions.second.5.underlineRange"));
        NSRange _secondOptionFifthLabelSecondRange = NSRangeFromString(T(@"%wifiOptions.second.5.underlineRange.1"));
        NSMutableAttributedString *_secondOptionFifthLabelString = [[NSMutableAttributedString alloc] initWithString:T(@"%wifiOptions.second.5")];
        [_secondOptionFifthLabelString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:_secondOptionFifthLabelFirstRange];
        [_secondOptionFifthLabelString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:_secondOptionFifthLabelSecondRange];
        [_secondOptionFifthLabel setAttributedText:_secondOptionFifthLabelString];
        _secondOptionFifthLabel.hidden = NO;
        [_secondOptionFifthLabel setFont:_secondOptionFourthLabel.font];
        _secondOptionFifthLabel.frame = CGRectMake(40, startY, 240, 300);
        [_secondOptionFifthLabel sizeToFit];
        UITapGestureRecognizer *_secondOptionFifthLabelGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTappedSecondOptionFifthLabel:)];
        [_secondOptionFifthLabel addGestureRecognizer:_secondOptionFifthLabelGr];
        [_secondOptionFifthLabel setUserInteractionEnabled:YES];
        
        startY = 6;
        
        // Third Option
        _thirdOptionThirdLabel.hidden = NO;
        _thirdOptionPrivacyLabel.hidden = NO;
        _thirdOptionFourthLabel.hidden = NO;
        _thirdCheckFirst.hidden = NO;
        _thirdCheckSecond.hidden = NO;
        _thirdOptionFirstButton.hidden = YES;
        _thirdOptionFirstButton.frame = CGRectMake(13, 250, 227, 17);
        
        _thirdOptionTitleLabel.numberOfLines = 0;
        _thirdOptionTitleLabel.frame = CGRectMake(40, startY, 250, 100);
        [_thirdOptionTitleLabel sizeToFit];
        startY += _thirdOptionTitleLabel.frame.size.height + 5;
        
        _thirdOptionFirstLabel.frame = CGRectMake(40, startY, 250, 110);
        [_thirdOptionFirstLabel sizeToFit];
        startY += _thirdOptionFirstLabel.frame.size.height + 10;
        
        _thirdOptionSecondLabel.frame = CGRectMake(40, startY, 250, 120);
        [_thirdOptionSecondLabel sizeToFit];
        startY += _thirdOptionSecondLabel.frame.size.height + 10;
        
        _thirdOptionThirdLabel.frame = CGRectMake(40, startY, 250, 90);
        NSRange _thirdOptionThirdLabelRange = NSRangeFromString(T(@"%wifiOptions.third.2.boldRange"));
        NSMutableAttributedString *_thirdOptionThirdLabelString = [[NSMutableAttributedString alloc] initWithString:T(@"%wifiOptions.third.2")];
        [_thirdOptionThirdLabelString addAttribute:NSFontAttributeName value:[UIFont boldFontOfSize: _thirdOptionThirdLabel.font.pointSize] range:_thirdOptionThirdLabelRange];
        [_thirdOptionThirdLabel setAttributedText:_thirdOptionThirdLabelString];
        [_thirdOptionThirdLabel sizeToFit];
        startY += _thirdOptionThirdLabel.frame.size.height + 15;

        
        _thirdOptionPrivacyLabel.frame = CGRectMake(73, startY, 217, 53);
        _thirdCheckFirst.frame = CGRectMake(40, startY, 25, 25);
        _thirdCheckError.frame = CGRectMake(10, startY, 24, 24);
        [_thirdOptionPrivacyLabel sizeToFit];
        startY += (_thirdOptionPrivacyLabel.frame.size.height > _thirdCheckFirst.frame.size.height ? _thirdOptionPrivacyLabel.frame.size.height : _thirdCheckFirst.frame.size.height ) + 10;
        
        _thirdCheckSecondError.frame = CGRectMake(10, startY, 24, 24);
        _thirdCheckSecond.frame = CGRectMake(40, startY, 25, 25);
        _thirdOptionFourthLabel.frame = CGRectMake(73, startY, 217, 25);
        NSRange _thirdOptionFourthLabelRange = NSRangeFromString(T(@"%wifiOptions.third.4.underlineRange"));
        NSMutableAttributedString *_thirdOptionFourthLabelString = [[NSMutableAttributedString alloc] initWithString:T(@"%wifiOptions.third.4")];
        [_thirdOptionFourthLabelString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:_thirdOptionFourthLabelRange];
        [_thirdOptionFourthLabel setAttributedText:_thirdOptionFourthLabelString];
        UITapGestureRecognizer *_thirdOptionFourthLabelGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goConditionsGr)];
        [_thirdOptionFourthLabel addGestureRecognizer:_thirdOptionFourthLabelGR];
        [_thirdOptionFourthLabel setUserInteractionEnabled:YES];
        [_thirdOptionFourthLabel sizeToFit];
        startY += (_thirdOptionFourthLabel.frame.size.height > _thirdCheckSecond.frame.size.height ? _thirdOptionFourthLabel.frame.size.height : _thirdCheckSecond.frame.size.height ) + 10;
        
        _thirdOptionFifthLabel.gestureRecognizers = nil;
        _thirdOptionFifthLabel.numberOfLines = 0;
        NSRange _thirdOptionFifthLabelFirstRange = NSRangeFromString(T(@"%wifiOptions.third.5.underlineRange"));
        NSRange _thirdOptionFifthLabelSecondRange = NSRangeFromString(T(@"%wifiOptions.third.5.underlineRange.1"));
        NSMutableAttributedString *_thirdOptionFifthLabelString = [[NSMutableAttributedString alloc] initWithString:T(@"%wifiOptions.third.5")];
        [_thirdOptionFifthLabelString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:_thirdOptionFifthLabelFirstRange];
        [_thirdOptionFifthLabelString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:_thirdOptionFifthLabelSecondRange];
        [_thirdOptionFifthLabel setAttributedText:_thirdOptionFifthLabelString];
        _thirdOptionFifthLabel.hidden = NO;
        [_thirdOptionFifthLabel setFont:_thirdOptionFourthLabel.font];
        _thirdOptionFifthLabel.frame = CGRectMake(40, startY, 240, 300);
        [_thirdOptionFifthLabel sizeToFit];
        UITapGestureRecognizer *_thirdOptionFifthLabelGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTappedThirdOptionFifthLabel:)];
        [_thirdOptionFifthLabel addGestureRecognizer:_thirdOptionFifthLabelGr];
        [_thirdOptionFifthLabel setUserInteractionEnabled:YES];
    }
    else
    {
        _firstOptionFirstLabel.frame = CGRectMake(40, 17, 250, 105);
        _firstOptionSecondLabel.frame = CGRectMake(40, 100, 250, 105);
        _firstOptionThirdLabel.frame = CGRectMake(40, 175, 250, 120);
        _firstOptionFirstButton.frame = CGRectMake(36, 300, 227, 17);
        _firstOptionSecondButton.frame = CGRectMake(-14, 325, 227, 17);
        _secondOptionFirstLabel.frame = CGRectMake(40, 17, 250, 105);
        _secondOptionSecondLabel.frame = CGRectMake(40, 120, 250, 105);
        _secondOptionThirdLabel.frame = CGRectMake(40, 195, 250, 120);
        _secondOptionFirstButton.frame = CGRectMake(-14, 300, 227, 17);
        _thirdOptionFirstButton.frame = CGRectMake(-14, 280, 227, 17);
        
        _firstCheckFirst.hidden = YES;
        _firstCheckSecond.hidden = YES;
        _secondCheckFirst.hidden = YES;
        _secondCheckSecond.hidden = YES;
        _thirdOptionThirdLabel.hidden = NO;
    }
#endif //BABY_NES_US
    
    // add tap listener to the scroll view's views
    for (UIView *view in self.contentView.subviews) {
        if (view.tag) {
            UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSelect:)];
            [view addGestureRecognizer:r];
            
            CGRect frame = view.frame;
            

            
#ifdef BABY_NES_US
            
            frame.size.height = 95; //136            
#else
            if ([T(@"%general.language") isEqual:@"fr"] || [T(@"%general.language") isEqual:@"de"]) {
                switch (view.tag)
                {
                    case 1:
                        frame.size.height = _firstOptionFirstLabel.frame.origin.y + _firstOptionFirstLabel.frame.size.height + 5;
                        break;
                    case 2:
                        frame.size.height = _secondOptionFirstLabel.frame.origin.y + _secondOptionFirstLabel.frame.size.height + 5;
                        break;
                    case 3:
                        frame.size.height = _thirdOptionFirstLabel.frame.origin.y + _thirdOptionFirstLabel.frame.size.height + 5;
                        break;
                }
            }
            else
            {
                frame.size.height = 110; //136
            }
#endif //BABY_NES_US
            view.frame = frame;
        }
    }

    
    [self.contentView sizeToFit];
    
    self.scrollView.contentSize = self.contentView.bounds.size;
    
    if([[[User activeUser] wifiOrderOption] isEqualToString:@"Automatic"])
    {
        [self doSelectWithView:_firstOption.superview];
    }
    else if([[[User activeUser] wifiOrderOption] isEqualToString:@"QuickOrder"])
    {
        [self doSelectWithView:_secondOption.superview];
    }
    else if([[[User activeUser] wifiOrderOption] isEqualToString:@"TrackerOnly"])
    {
        [self doSelectWithView:_thirdOption.superview];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)doSelect:(UITapGestureRecognizer *)r
{
    [self doSelectWithView:r.view];
}


- (void)doSelectWithView:(UIView *)view
{
    _selectedViewTag = view.tag;
    FlatCheckbox *checkBox;
    
    for (UIView *view in self.contentView.subviews) {
        if (view.tag) {
            CGRect frame = view.frame;
            //auto-check checkboxes
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:[FlatCheckbox class]]) {
                    [((FlatCheckbox*)subview) setOn:TRUE];
                }
            }
#ifdef BABY_NES_US
            //bchitu todo remove comment
            if(view.tag != _selectedViewTag)
            {
                frame.size.height = 95;
            }
            else
            {
                switch (view.tag)
                {
                    case 1:
                        frame.size.height = 250;
                        break;
                    case 2:
                        frame.size.height = 300;
                        break;
                    case 3:
                        frame.size.height = 200;
                        break;
                    default:
                        frame.size.height = 320;
                        break;
                }
            }
            
            
            
#else
            if ([T(@"%general.language") isEqual:@"fr"] || [T(@"%general.language") isEqual:@"de"])
            {
                if (view.tag == _selectedViewTag)
                {
                    switch (view.tag)
                    {
                        case 1:
                            frame.size.height = _firstOptionFifthLabel.frame.origin.y + _firstOptionFifthLabel.frame.size.height + 20;
                            break;
                        case 2:
                            frame.size.height = _secondOptionFifthLabel.frame.origin.y + _secondOptionFifthLabel.frame.size.height + 20;
                            break;
                        case 3:
                            frame.size.height = _thirdOptionFifthLabel.frame.origin.y + _thirdOptionFifthLabel.frame.size.height + 20;
                            break;
                    }
                }
                else
                {
                    switch (view.tag)
                    {
                        case 1:
                            frame.size.height = _firstOptionFirstLabel.frame.origin.y + _firstOptionFirstLabel.frame.size.height + 5;
                            break;
                        case 2:
                            frame.size.height = _secondOptionFirstLabel.frame.origin.y + _secondOptionFirstLabel.frame.size.height + 5;
                            break;
                        case 3:
                            frame.size.height = _thirdOptionFirstLabel.frame.origin.y + _thirdOptionFirstLabel.frame.size.height + 5;
                            break;
                    }
                }
            }else{
                frame.size.height = view.tag == _selectedViewTag ? 380 : 110;
            }
            
#endif //BABY_NES_US
            view.frame = frame;
            
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:[FlatCheckbox class]]) {
                    checkBox = (FlatCheckbox *) subview;
                    break;
                }
            }
            if (checkBox != nil)
            checkBox.selected = view.tag == _selectedViewTag;
        }
//        else {
//            for (UIView *subview in view.subviews) {
//                if ([subview isKindOfClass:[FlatCheckbox class]]) {
//                    [((FlatCheckbox*)subview) setOn:FALSE];
//                }
//            }
//
//        }
    }
    [self performSelector:@selector(resizeScrollViewAndScrollToView:) withObject:view afterDelay:0];
    
}

- (void)resizeScrollViewAndScrollToView:(UIView *)view {
    DynamicSizeContainer *contentView = [self.scrollView.subviews objectAtIndex:0];
    [contentView sizeToFit];
    self.scrollView.contentSize = contentView.bounds.size;
    [self.scrollView scrollRectToVisible:view.frame animated:YES];
}


- (IBAction)performSequeIfValid {
    BOOL error = NO;
    if ([self selectedOption] == WifiOptionNone) {
        [[AlertView alertViewFromString:T(@"%wifiOptions.alert.select" ) buttonClicked:nil] show];
    } else {
        NSString *wifiOption;
        _firstCheckError.hidden = YES;
        _firstCheckSecondError.hidden = YES;
        _secondCheckSecondError.hidden = YES;
        _secondCheckError.hidden = YES;
        _thirdCheckError.hidden = YES;
        _thirdCheckSecondError.hidden = YES;
        
        switch ([self selectedOption]) {
            case 1:
                wifiOption = @"Automatic";
#ifdef BABY_NES_US
                if(!_firstCheckFirst.isOn){
                    error = YES;
                    _firstCheckError.hidden = NO;
                }
#else
                if ([T(@"%general.language") isEqual:@"fr"] || [T(@"%general.language") isEqual:@"de"]) {
                    if(!_firstCheckFirst.isOn){
                        error = YES;
                        _firstCheckError.hidden = NO;
                    }
                    if(!_firstCheckSecond.isOn){
                        error = YES;
                        _firstCheckSecondError.hidden = NO;
                    }
                }
#endif//BABY_NES_US
                break;
            case 2:
                wifiOption = @"QuickOrder";
#ifdef BABY_NES_US
                if(!_secondCheckFirst.isOn){
                    error = YES;
                    _secondCheckError.hidden = NO;
                }
#else
                if ([T(@"%general.language") isEqual:@"fr"] || [T(@"%general.language") isEqual:@"de"]) {
                    if(!_secondCheckFirst.isOn){
                        error = YES;
                        _secondCheckError.hidden = NO;
                    }
                    if(!_secondCheckSecond.isOn){
                        error = YES;
                        _secondCheckSecondError.hidden = NO;
                    }
                }
#endif //BABY_NES_US
                
                break;
            case 3:
                wifiOption = @"TrackerOnly";
#ifdef BABY_NES_US
                if(!_thirdCheckFirst.isOn){
                    error = YES;
                    _thirdCheckError.hidden = NO;
                }
#else
                if ([T(@"%general.language") isEqual:@"fr"] || [T(@"%general.language") isEqual:@"de"]) {
                    if(!_thirdCheckFirst.isOn){
                        error = YES;
                        _thirdCheckError.hidden = NO;
                    }
                    if(!_thirdCheckSecond.isOn){
                        error = YES;
                        _thirdCheckSecondError.hidden = NO;
                    }
                }
#endif //BABY_NES_US
                break;
            default:
                wifiOption = @"TrackerOnly";
                break;
        }
        if(!error){
            if([[[[User activeUser] wifiOrderOption] lowercaseString] isEqualToString:wifiOption]) {
                [self performSegueWithIdentifier:@"babyProfiles" sender:self];
            } else {
                [[RESTService sharedService]
                 queueRequest:[RESTRequest getURL:[NSString stringWithFormat:WS_orderCreationMethodPut, wifiOption]]
                 completion:^(RESTResponse *request) {
                    //
//                     if(request.success)//
                     if(true)
                     {
                         switch ([self selectedOption]) {
                             case 1:
                                 [[User activeUser] setWifiOrderOption:@"Automatic"];
                                 break;
                             case 2:
                                 [[User activeUser] setWifiOrderOption:@"QuickOrder"];
                                 break;
                             case 3:
                                 [[User activeUser] setWifiOrderOption:@"TrackerOnly"];;
                                 break;
                             default:
                                 [[User activeUser] setWifiOrderOption:@"TrackerOnly"];;
                                 break;
                         }
                         [self performSegueWithIdentifier:@"babyProfiles" sender:self];
                     } else {
                         [[AlertView alertViewFromString:T(@"%general.alert.somethingWentWrong") buttonClicked:nil] show];
                     }
                 }];
            }
        }
    }
}

- (WifiOption)selectedOption {
    //we already have the selected option,no need to search in subviews
    return (WifiOption) self.selectedViewTag;
    
    
//     find selected option
//    for (UIView *view in self.contentView.subviews) {
//        if (view.tag) {
//            for (UIView *subview in view.subviews) {
//                if ([subview isKindOfClass:[FlatCheckbox class]]) {
//                    FlatCheckbox *checkBox = (FlatCheckbox *) subview;
//                    if (checkBox.selected) {
//                        // create enum from the options
//                        return (WifiOption) view.tag;
//                    }
//                }
//            }
//        }
//    }
    
    return WifiOptionNone;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"babyProfiles"]) {
        WifiBabyProfilesViewController *vc = segue.destinationViewController;
        vc.wifiOption = [self selectedOption];
    }
    
    if([segue.identifier isEqualToString:@"firstButton"]){
        WebViewViewController *vc = segue.destinationViewController;
        vc.modal = YES;
        vc.title = T(@"%menu.information.terms");
        vc.viewName = T(@"%menu.information.terms.html");
    }
    
    if([segue.identifier isEqualToString:@"secondButton"]){
        WebViewViewController *vc = segue.destinationViewController;
        vc.modal = YES;
        vc.title = T(@"%menu.information.privacy");
        vc.viewName = T(@"%menu.information.privacy.html");
    }
    
    if([segue.identifier isEqualToString:@"thirdButton"]){
        WebViewViewController *vc = segue.destinationViewController;
        vc.modal = YES;
        vc.title = T(@"%menu.information.legal");
        vc.viewName = T(@"%menu.information.legal.html");
    }
    
}

- (IBAction)goConditions:(id)sender {
    [self performSegueWithIdentifier:@"firstButton" sender:self];
}

-(void)goConditionsGr
{
    [self goConditions: self];
}

-(void) goWifiTerms
{
    WebViewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    vc.modal = YES;
    vc.title = T(@"%menu.information.wifi");
    vc.viewName = T(@"%menu.information.wifi.html");
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)goPolitics:(id)sender {
    [self performSegueWithIdentifier:@"secondButton" sender:self];
}

- (IBAction)secondOptionButton:(id)sender {
    [self performSegueWithIdentifier:@"secondButton" sender:self];
}

- (IBAction)thirdOptionButton:(id)sender {
    [self performSegueWithIdentifier:@"secondButton" sender:self];
}

- (void)openWebViewWithTitle:(NSString *)title andView:(NSString *)view {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    WebViewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    vc.title = title;
    vc.viewName = view;
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textTappedFirstOptionFifthLabel:(UIGestureRecognizer *)recognizer
{
    UILabel *label = (UILabel *)recognizer.view;
    CGPoint location = [recognizer locationInView:label];
    NSMutableArray *wordAreas = [[NSMutableArray alloc] init];
    NSArray *words = [label.text componentsSeparatedByString: @" "];
    NSRange _firstOptionFifthLabelFirstRange = NSRangeFromString(T(@"%wifiOptions.first.5.underlineRange"));
    NSRange _firstOptionFifthLabelSecondRange = NSRangeFromString(T(@"%wifiOptions.first.5.underlineRange.1"));
    if ([words count] == 0) return;
    NSInteger lengthUntil[[words count]];
    for (int i=0;i<[words count];i++)
    {
        if (i == 0)
        {
            lengthUntil[i] = 0;
        }
        else
        {
            lengthUntil[i] = [words[i-1] length] + lengthUntil[i-1] + 1;
        }
    }
    
    CGPoint drawPoint = CGPointMake(0, 0);
    CGRect rect = [label frame];
    
    NSMutableString *line = [[NSMutableString alloc] init];
    [line setString: @""];
    for (int i=0;i<[words count];i++)
    {
        CGSize size = [line sizeWithFont:label.font];
        [line appendString:words[i]];
        
        if ([line sizeWithFont:label.font].width > rect.size.width)
        {
            [line setString:words[i]];
            [line appendString:@" "];
            size = CGSizeMake(0, size.height);
            drawPoint = CGPointMake(0, drawPoint.y + size.height);
        }
        else
        {
            [line appendString:@" "];
        }
        
        // Check if current word is in a link and include the space if it's not the last word in the link
        if (
            (lengthUntil[i]>=_firstOptionFifthLabelFirstRange.location && lengthUntil[i]<_firstOptionFifthLabelFirstRange.location+_firstOptionFifthLabelFirstRange.length && lengthUntil[i+1]<_firstOptionFifthLabelFirstRange.location+_firstOptionFifthLabelFirstRange.length)
            ||
            (lengthUntil[i]>=_firstOptionFifthLabelSecondRange.location && lengthUntil[i]<_firstOptionFifthLabelSecondRange.location+_firstOptionFifthLabelSecondRange.length && lengthUntil[i+1]<_firstOptionFifthLabelSecondRange.location+_firstOptionFifthLabelSecondRange.length)
           )
        {
            [wordAreas addObject:[NSValue valueWithCGRect:CGRectMake(size.width, drawPoint.y, [[NSString stringWithFormat:@"%@ ",words[i]] sizeWithFont:label.font].width, [words[i] sizeWithFont:label.font].height)]];
        }
        else
        {
            [wordAreas addObject:[NSValue valueWithCGRect:CGRectMake(size.width, drawPoint.y, [words[i] sizeWithFont:label.font].width, [words[i] sizeWithFont:label.font].height)]];
        }
    }
    
    for (int i=0;i<[words count];i++)
    {
        CGRect area = [wordAreas[i] CGRectValue];
        if (CGRectContainsPoint(area, location)) {
            if (lengthUntil[i]>=_firstOptionFifthLabelFirstRange.location && lengthUntil[i]<_firstOptionFifthLabelFirstRange.location+_firstOptionFifthLabelFirstRange.length)
            {
                [self goPolitics: self];
            }
            if (lengthUntil[i]>=_firstOptionFifthLabelSecondRange.location && lengthUntil[i]<_firstOptionFifthLabelSecondRange.location+_firstOptionFifthLabelSecondRange.length)
            {
                [self goWifiTerms];
            }
            
            break;
        }
    }
}

-(void) textTappedSecondOptionFifthLabel:(UIGestureRecognizer *)recognizer
{
    UILabel *label = (UILabel *)recognizer.view;
    CGPoint location = [recognizer locationInView:label];
    NSMutableArray *wordAreas = [[NSMutableArray alloc] init];
    NSArray *words = [label.text componentsSeparatedByString: @" "];
    NSRange _secondOptionFifthLabelFirstRange = NSRangeFromString(T(@"%wifiOptions.second.5.underlineRange"));
    NSRange _secondOptionFifthLabelSecondRange = NSRangeFromString(T(@"%wifiOptions.second.5.underlineRange.1"));
    if ([words count] == 0) return;
    NSInteger lengthUntil[[words count]];
    for (int i=0;i<[words count];i++)
    {
        if (i == 0)
        {
            lengthUntil[i] = 0;
        }
        else
        {
            lengthUntil[i] = [words[i-1] length] + lengthUntil[i-1] + 1;
        }
    }
    
    CGPoint drawPoint = CGPointMake(0, 0);
    CGRect rect = [label frame];
    
    NSMutableString *line = [[NSMutableString alloc] init];
    [line setString: @""];
    for (int i=0;i<[words count];i++)
    {
        CGSize size = [line sizeWithFont:label.font];
        [line appendString:words[i]];
        
        if ([line sizeWithFont:label.font].width > rect.size.width)
        {
            [line setString:words[i]];
            [line appendString:@" "];
            size = CGSizeMake(0, size.height);
            drawPoint = CGPointMake(0, drawPoint.y + size.height);
        }
        else
        {
            [line appendString:@" "];
        }
        
        // Check if current word is in a link and include the space if it's not the last word in the link
        if (
            (lengthUntil[i]>=_secondOptionFifthLabelFirstRange.location && lengthUntil[i]<_secondOptionFifthLabelFirstRange.location+_secondOptionFifthLabelFirstRange.length && lengthUntil[i+1]<_secondOptionFifthLabelFirstRange.location+_secondOptionFifthLabelFirstRange.length)
            ||
            (lengthUntil[i]>=_secondOptionFifthLabelSecondRange.location && lengthUntil[i]<_secondOptionFifthLabelSecondRange.location+_secondOptionFifthLabelSecondRange.length && lengthUntil[i+1]<_secondOptionFifthLabelSecondRange.location+_secondOptionFifthLabelSecondRange.length)
            )
        {
            [wordAreas addObject:[NSValue valueWithCGRect:CGRectMake(size.width, drawPoint.y, [[NSString stringWithFormat:@"%@ ",words[i]] sizeWithFont:label.font].width, [words[i] sizeWithFont:label.font].height)]];
        }
        else
        {
            [wordAreas addObject:[NSValue valueWithCGRect:CGRectMake(size.width, drawPoint.y, [words[i] sizeWithFont:label.font].width, [words[i] sizeWithFont:label.font].height)]];
        }
    }
    
    for (int i=0;i<[words count];i++)
    {
        CGRect area = [wordAreas[i] CGRectValue];
        if (CGRectContainsPoint(area, location)) {
            if (lengthUntil[i]>=_secondOptionFifthLabelFirstRange.location && lengthUntil[i]<_secondOptionFifthLabelFirstRange.location+_secondOptionFifthLabelFirstRange.length)
            {
                [self goPolitics: self];
            }
            if (lengthUntil[i]>=_secondOptionFifthLabelSecondRange.location && lengthUntil[i]<_secondOptionFifthLabelSecondRange.location+_secondOptionFifthLabelSecondRange.length)
            {
                [self goWifiTerms];
            }
            
            break;
        }
    }
}

-(void) textTappedThirdOptionFifthLabel:(UIGestureRecognizer *)recognizer
{
    UILabel *label = (UILabel *)recognizer.view;
    CGPoint location = [recognizer locationInView:label];
    NSMutableArray *wordAreas = [[NSMutableArray alloc] init];
    NSArray *words = [label.text componentsSeparatedByString: @" "];
    NSRange _thirdOptionFifthLabelFirstRange = NSRangeFromString(T(@"%wifiOptions.third.5.underlineRange"));
    NSRange _thirdOptionFifthLabelSecondRange = NSRangeFromString(T(@"%wifiOptions.third.5.underlineRange.1"));
    if ([words count] == 0) return;
    NSInteger lengthUntil[[words count]];
    for (int i=0;i<[words count];i++)
    {
        if (i == 0)
        {
            lengthUntil[i] = 0;
        }
        else
        {
            lengthUntil[i] = [words[i-1] length] + lengthUntil[i-1] + 1;
        }
    }
    
    CGPoint drawPoint = CGPointMake(0, 0);
    CGRect rect = [label frame];
    
    NSMutableString *line = [[NSMutableString alloc] init];
    [line setString: @""];
    for (int i=0;i<[words count];i++)
    {
        CGSize size = [line sizeWithFont:label.font];
        [line appendString:words[i]];
        
        if ([line sizeWithFont:label.font].width > rect.size.width)
        {
            [line setString:words[i]];
            [line appendString:@" "];
            size = CGSizeMake(0, size.height);
            drawPoint = CGPointMake(0, drawPoint.y + size.height);
        }
        else
        {
            [line appendString:@" "];
        }
        
        // Check if current word is in a link and include the space if it's not the last word in the link
        if (
            (lengthUntil[i]>=_thirdOptionFifthLabelFirstRange.location && lengthUntil[i]<_thirdOptionFifthLabelFirstRange.location+_thirdOptionFifthLabelFirstRange.length && lengthUntil[i+1]<_thirdOptionFifthLabelFirstRange.location+_thirdOptionFifthLabelFirstRange.length)
            ||
            (lengthUntil[i]>=_thirdOptionFifthLabelSecondRange.location && lengthUntil[i]<_thirdOptionFifthLabelSecondRange.location+_thirdOptionFifthLabelSecondRange.length && lengthUntil[i+1]<_thirdOptionFifthLabelSecondRange.location+_thirdOptionFifthLabelSecondRange.length)
            )
        {
            [wordAreas addObject:[NSValue valueWithCGRect:CGRectMake(size.width, drawPoint.y, [[NSString stringWithFormat:@"%@ ",words[i]] sizeWithFont:label.font].width, [words[i] sizeWithFont:label.font].height)]];
        }
        else
        {
            [wordAreas addObject:[NSValue valueWithCGRect:CGRectMake(size.width, drawPoint.y, [words[i] sizeWithFont:label.font].width, [words[i] sizeWithFont:label.font].height)]];
        }
    }
    
    for (int i=0;i<[words count];i++)
    {
        CGRect area = [wordAreas[i] CGRectValue];
        if (CGRectContainsPoint(area, location)) {
            if (lengthUntil[i]>=_thirdOptionFifthLabelFirstRange.location && lengthUntil[i]<_thirdOptionFifthLabelFirstRange.location+_thirdOptionFifthLabelFirstRange.length)
            {
                [self goPolitics: self];
            }
            if (lengthUntil[i]>=_thirdOptionFifthLabelSecondRange.location && lengthUntil[i]<_thirdOptionFifthLabelSecondRange.location+_thirdOptionFifthLabelSecondRange.length)
            {
                [self goWifiTerms];
            }
            
            break;
        }
    }
}


@end
