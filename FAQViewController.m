//
//  FAQViewController.m
//  Flatland
//
//  Created by Pirlitu Vasilica on 12/6/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "FAQViewController.h"
#import "FAQTableViewCell.h"
#import "WebViewViewController.h"
#import "FaqSection.h"


@interface FAQViewController ()
{
    UIFont *fontForAllLabels;
}
@property (weak, nonatomic) IBOutlet UITableView *sectionsTableView;

@end

@implementation FAQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self.sectionsTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.sectionsTableView  setSeparatorInset:UIEdgeInsetsZero];
    }
    
    self.sectionsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.sectionsTableView.bounds.size.width, 0.01f)];
    
    self.sectionsTableView.dataSource = self;
    self.sectionsTableView.delegate = self;
    
    //find the longest category and fit the text
    FAQTableViewCell  *cell = [self.sectionsTableView dequeueReusableCellWithIdentifier:@"FAQSection"];
    UIFont *font = cell.titleLabel.font;
    
    NSArray* sections = FAQSectionsJSON();
    GLfloat maxW = 0;
    int posMax = 0;
    
    for (int i=0;i<[sections count];i++)
    {
        FaqSection *section = [sections objectAtIndex:i];
        if ([section.title sizeWithFont:font].width > maxW)
        {
            maxW = [section.title sizeWithFont:font].width;
            posMax = i;
        }
    }
    //calc the font size needed to fit
    NSString* longestTitle = [(FaqSection*)[sections objectAtIndex:posMax] title];
    while ([longestTitle sizeWithFont:font].width > cell.titleLabel.frame.size.width)
    {
        font = [UIFont fontWithName:font.fontName size:font.pointSize - 1];
    }
    
    fontForAllLabels = font;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FAQTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"FAQSection"];
    [cell changeSystemFontToApplicationFont];
    
    [cell setSection:[FAQSectionsJSON() objectAtIndex:indexPath.row]];
    [cell.titleLabel setFont:fontForAllLabels];
    
    return cell;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [FAQSectionsJSON() count];
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FaqSection* section = [FAQSectionsJSON() objectAtIndex:indexPath.row];
    WebViewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    vc.title = section.title;
    vc.viewName = section.page;
    
    [self.navigationController pushViewController:vc animated:YES];
}
    
    

@end
