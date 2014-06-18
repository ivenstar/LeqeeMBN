//
//  TipsDetailsViewController.m
//  Flatland
//
//  Created by Magdalena Kamrowska on 29.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "TipsDetailsViewController.h"
#import "User.h"
#import "Tips.h"
#import "AlertView.h"
#import "Address.h"

@interface TipsDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollInnerView;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (strong, nonatomic) Address *userAddress;
@end

@implementation TipsDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!IS_WIDESCREEN){
        _webView.frame = CGRectMake(20, 94, 270, 300);
    }else{
        _webView.frame = CGRectMake(20, 94, 270, 400);
    }
    [self setContent];
    
}

- (void)setContent {
    _titleLabel.text = _tip.title;
    switch (_tip.ageStep.integerValue) {
        case 0:
            _colorIndicator.backgroundColor = [UIColor colorWithRGBString:@"C666E5"];
            _titleLabel.textColor = [UIColor colorWithRGBString:@"C666E5"];
            break;
        case 4:
            _colorIndicator.backgroundColor = [UIColor colorWithRGBString:@"C7B2B8"];
            _titleLabel.textColor = [UIColor colorWithRGBString:@"C7B2B8"];
            break;
        case 6:
            _colorIndicator.backgroundColor = [UIColor colorWithRGBString:@"A4D3E7"];
            _titleLabel.textColor = [UIColor colorWithRGBString:@"A4D3E7"];
            break;
        case 8:
            _colorIndicator.backgroundColor = [UIColor colorWithRGBString:@"EFD95C"];
            _titleLabel.textColor = [UIColor colorWithRGBString:@"EFD95C"];
            break;
        case 12:
            _colorIndicator.backgroundColor = [UIColor colorWithRGBString:@"C3D29B"];
            _titleLabel.textColor = [UIColor colorWithRGBString:@"C3D29B"];
            break;
        case 18:
            _colorIndicator.backgroundColor = [UIColor colorWithRGBString:@"91B8A6"];
            _titleLabel.textColor = [UIColor colorWithRGBString:@"91B8A6"];
            break;
        default:
            break;
    }
    NSMutableString *html = [[NSMutableString alloc] initWithString:@"<html><head><title></title></head><body>"];
    [html appendString:_tip.text];
    [html appendString:@"</body></html>"];
    [_webView loadHTMLString:html baseURL:nil];

    if([[User activeUser] favoriteTips].count > 0) {
        [_loveButton setEnabled:([[[User activeUser] favoriteTips] indexOfObject:_tip.week] == NSNotFound)];
    } else {
        [_loveButton setEnabled:YES];
    }
}

- (IBAction)share:(id)sender {
    [[User activeUser] loadPersonalInformation:^(Address *personalAddress) {
        NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@"<html><head><title>Le stock de capsules de "];
        [emailBody appendString:_baby.name];
        [emailBody appendString:@"s’épuise !</title><style type=\"text/css\">body{width:100% !important; -webkit-text-size-adjust:100%; -ms-text-size-adjust:100%; margin:0; padding:0;}.ExternalClass {width:100%;}.ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div {line-height: 100%;}img {outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;} a img {border:none;} .image_fix {display:block;} p {margin: 1em 0;} h1, h2, h3, h4, h5, h6 {color: #908cc1 !important;} h1 a, h2 a, h3 a, h4 a, h5 a, h6 a {color: #62646d !important;} h1 a:active, h2 a:active, h3 a:active, h4 a:active, h5 a:active, h6 a:active {color: #62646d !important;} h1 a:visited, h2 a:visited,  h3 a:visited, h4 a:visited, h5 a:visited, h6 a:visited { color: #62646d !important;} table td {border-collapse: collapse;} a {color: #7671b3;} </style></head><body>"];
        [emailBody appendString:@"<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" id=\"backgroundTable\" style=\"background-color: #fff;\"><tr><td valign=\"top\"><table border=\"0\" width=\"600\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" bgcolor=\"#FFFFFF\"><tr><td><a href=\"https://www.babynes.fr/\"><img src=\"https://www.babynes.ch/_layouts/ANS/Images/mail/email_header.jpg\" alt=\"BabyNes Advanced Nutrition\" width=\"600\" height=\"112\" border=\"0\" /></a></td></tr></table><table id=\"mainnavigation\"  border=\"0\" width=\"600\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" bgcolor=\"#FFFFFF\"><tr valign=\"middle\"><td width=\"20\" height=\"20\">&nbsp;</td><td align=\"center\"><a style=\"color: #8e8d98; font-size: 9px; font-family: Helvetica, Arial, sans-serif; text-decoration: none;\" href=\"\">LA&nbsp;NUTRITION&nbsp;IDÉALE</a></td><td align=\"center\"><a style=\"color: #8e8d98; font-size: 9px; font-family: Helvetica, Arial, sans-serif; text-decoration: none;\" href=\"\">LE&nbsp;SYSTÈME&nbsp;BABYNES</a></td><td align=\"center\"><a style=\"color: #8e8d98; font-size: 9px; font-family: Helvetica, Arial, sans-serif; text-decoration: none;\" href=\"\">LA&nbsp;MACHINE</a></td><td align=\"center\"><a style=\"color: #8e8d98; font-size: 9px; font-family: Helvetica, Arial, sans-serif; text-decoration: none;\" href=\"\">LES&nbsp;CAPSULES</a></td><td align=\"center\"><a style=\"color: #8e8d98; font-size: 9px; font-family: Helvetica, Arial, sans-serif; text-decoration: none;\" href=\"\">LES&nbsp;SERVICES</a></td><td align=\"center\"><a style=\"color: #8e8d98; font-size: 9px; font-family: Helvetica, Arial, sans-serif; text-decoration: none;\" href=\"\">BOUTIQUE&nbsp;EN&nbsp;LIGNE</a></td><td width=\"20\" height=\"20\">&nbsp;</td></tr><tr valign=\"middle\"><td width=\"20\" height=\"20\">&nbsp;</td><td colspan=\"6\"><img src=\"https://www.babynes.ch/emailimages/grey_line_560.png\" alt=\"line\" width=\"560\" height=\"1\" border=\"0\" /></td><td width=\"20\" height=\"20\">&nbsp;</td></tr></table><table border=\"0\" width=\"600\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" bgcolor=\"#FFFFFF\"><tr><td width=\"20\" height=\"20\">&nbsp;</td><td valign=\"top\"><h1 style=\"margin: 40px 0 20px 0; padding: 0; font-size: 26px; color: #908cc1; font-weight: normal; font-family: Helvetica, Arial, sans-serif;\">Bonjour,</h1></td><td width=\"20\" height=\"20\">&nbsp;</td></tr><tr><td width=\"20\" height=\"20\">&nbsp;</td><td valign=\"top\"><p style=\"margin: 0 0 10px 0; padding: 0; font-size: 12px; color: #565862; font-weight: normal; font-family: Helvetica, Arial, sans-serif;\"><strong>"];
        [emailBody appendString:personalAddress.firstName];
        [emailBody appendString:@" "];
        [emailBody appendString:personalAddress.lastName];
        [emailBody appendString:@"</strong> souhaite partager la consommation de " ];
        [emailBody appendString:_baby.name];
        [emailBody appendString:@"avec vous.</p><p style=\"margin: 0 0 20px 0; padding: 0;  font-size: 12px; color: #565862; font-weight: bold; font-family: Helvetica, Arial, sans-serif;\">Son message&nbsp;: <span style=\"color: #8e8d98;\">"];
                [emailBody appendString:_tip.text];
        [emailBody appendString:@"</span></p><p style=\"margin: 0 0 20px 0; padding: 0;  font-size: 12px; color: #8e8d98; font-weight: normal; font-family: Helvetica, Arial, sans-serif;\">Ce message vous a été adressé depuis le site <a style=\"color: #908cc1; font-weight: bold; text-decoration: underline;\" href=\"https://www.babynes.ch/\">BabyNes.ch</a>.</p></td><td width=\"20\" height=\"20\">&nbsp;</td></tr></table>"];
        [emailBody appendString:@"<table border=\"0\" width=\"600\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" bgcolor=\"#FFFFFF\"><tr><td height=\"10\" width=\"100\">&nbsp;</td><td width=\"400\"><table border=\"0\" width=\"400\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" bgcolor=\"#FFFFFF\"><tr><td valign=\"middle\"><img src=\"https://www.babynes.fr/PublishingImages/mail/nutritionist.jpg\" alt=\"A votre écoute\" width=\"150\" height=\"114\" border=\"0\" /></td><td valign=\"middle\"><p style=\"margin: 0; padding: 30px 20px 30px 0; font-size: 14px; color: #565862; font-weight: bold; font-family: Helvetica, Arial, sans-serif;\">À votre écoute 7j/7, 24h/24.<br /><span style=\"font-size: 12px; color: #8e8d98; font-weight: normal;\">Appelez-nous au</span>  0 800 800 036 <br /><span style=\"font-size: 12px; color: #8e8d98; font-weight: normal;\">Ou</span> <br /><a style=\"font-weight: bold; color: #908cc1; text-decoration: underline; font-family: Helvetica, Arial, sans-serif;\" href=\"https://www.babynes.fr/FR/services-mybabynes/Pages/etre-rappele.aspx\">Demandez à être rappelé(e)</a></p></td></tr></table></td><td height=\"10\" width=\"100\">&nbsp;</td></tr></table>"];
        [emailBody appendString:@"<table border=\"0\" width=\"600\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" bgcolor=\"#ffffff\"><tr><td height=\"20\">&nbsp;</td></tr></table><table  border=\"0\" width=\"600\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" bgcolor=\"#FFFFFF\"><tr><td width=\"100\">&nbsp;</td><td width=\"200\" align=\"center\"><table><tr><td><a href=\"http://www.facebook.com/sharer.php?u=https://www.babynes.fr&t=D%C3%A9couvrez%20BabyNes%20de%20Nestl%C3%A9%20%3A%20un%20syst%C3%A8me%20%C3%A9volutif%20de%20lait%20infantile\"><img src=\"https://www.babynes.fr/_layouts/ANS/Images/mail/facebook_icon.png\" alt=\"facebook\" width=\"16\" height=\"17\" border=\"0\" align=\"left\" /></a></td><td><a style=\"font-size: 11px; font-weight: normal; color: #908cc1; text-decoration: none; font-family: Helvetica, Arial, sans-serif;\" href=\"http://www.facebook.com/sharer.php?u=https://www.babynes.fr&t=D%C3%A9couvrez%20BabyNes%20de%20Nestl%C3%A9%20%3A%20un%20syst%C3%A8me%20%C3%A9volutif%20de%20lait%20infantile\">Partagez BabyNes sur Facebook</a></td></tr></table></td><td width=\"200\" align=\"center\"><table><tr><td><a href=\"https://www.babynes.fr/7911CC27-96C0-4086-9961-B68789160EC0/11B6B5B0-FF85-47f1-8FB9-BCE1A9D377A9/redirect/doi.ashx\"><img src=\"https://www.babynes.fr/_layouts/ANS/Images/mail/envelope_icon.png\" alt=\"facebook\" width=\"16\" height=\"17\" border=\"0\" align=\"left\" /></a></td><td><a style=\"font-size: 11px; font-weight: normal; color: #908cc1; text-decoration: none; font-family: Helvetica, Arial, sans-serif;\"  href=\"https://www.babynes.fr/7911CC27-96C0-4086-9961-B68789160EC0/11B6B5B0-FF85-47f1-8FB9-BCE1A9D377A9/redirect/doi.ashx\">Faites découvrir BabyNes à un ami</a></td></tr></table></td><td width=\"100\">&nbsp;</td></tr></table><table border=\"0\" width=\"600\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" bgcolor=\"#ffffff\"><tr><td height=\"20\">&nbsp;</td></tr></table><table border=\"0\" width=\"600\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" bgcolor=\"#FFFFFF\"><tr><td><img src=\"https://www.babynes.fr/_layouts/ANS/Images/mail/spacer_structure.jpg\" alt=\"\" width=\"600\" height=\"32\" border=\"0\" /></td></tr></table><table border=\"0\" width=\"600\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" bgcolor=\"#FFFFFF\"><tr valign=\"middle\"><td width=\"20\" height=\"20\">&nbsp;</td><td colspan=\"6\"><p style=\"margin: 20px 0 20px 0; font-size: 11px; color: #808289; font-weight: normal; font-family: Helvetica, Arial, sans-serif;\">Si vous souhaitez modifier votre adresse e-mail, <a style=\"color: #8e8d98; font-family: Helvetica, Arial, sans-serif; text-decoration: underline;\" href=\"https://www.babynes.fr/FR/votre-compte-mybabynes/Pages/VosInformationsPersonelles.aspx\">cliquez ici</a> ou allez directement dans «&nbsp;Mon compte&nbsp;», rubrique «&nbsp;Vos informations personnelles&nbsp;» afin d´y enregistrer votre nouvelle adresse e-mail. Si vous ne souhaitez plus recevoir d´informations de la part de BabyNes, <a style=\"color: #8e8d98; font-family: Helvetica, Arial, sans-serif; text-decoration: underline;\" href=\"https://www.babynes.fr/FR/votre-compte-mybabynes/Pages/PreferencesDAlerte.aspx\">cliquez ici</a>ou alle directement dans «&nbsp;Mon compte&nbsp;» rubrique «&nbsp;Préférences de contact&nbsp;» afin de modifier vos abonnements.</p></td><td width=\"20\" height=\"20\">&nbsp;</td></tr></table>"];
        [emailBody appendString:_baby.name];
        [emailBody appendString:@"</body></html>"];
        
        // Compose dialog
        MFMailComposeViewController *emailDialog = [[MFMailComposeViewController alloc] init];
        emailDialog.mailComposeDelegate = self;
        
        [emailDialog setToRecipients:[NSArray arrayWithObject:@""]];
        
        // Set subject
        [emailDialog setSubject:@""];
        
        // Set body
        [emailDialog setMessageBody:emailBody isHTML:YES];
        
        // Show mail
        [self presentViewController:emailDialog animated:YES completion:^{}];
    }];

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        NSString *emailString = [[alertView textFieldAtIndex:0] text];
        if(ValidateEmailAddress(emailString)) {
            [[AlertView alertViewFromString:T(@"%tips.alert.set") buttonClicked:nil] show];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:T(@"%tips.alert.enterValid.header") message:T(@"%tips.alert.enterValid.text") delegate:self cancelButtonTitle:T(@"%general.cancel") otherButtonTitles:T(@"%general.ok") , nil];
            [av setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [av show];
        }
    }
}

- (IBAction)love:(id)sender {
    if([[User activeUser] addTip:_tip.week]) {
        [[AlertView alertViewFromString:T(@"%tips.alert.saved") buttonClicked:nil] show];
        [_loveButton setEnabled:NO];
    } else {
        [[AlertView alertViewFromString:T(@"%tips.alert.alreadySaved") buttonClicked:nil] show];
    }
}
@end
