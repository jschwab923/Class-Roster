//
//  NAYTableViewControllerNew.m
//  FirstDayDemo
//
//  Created by Jeff Schwab on 1/13/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYTableViewController.h"
#import "NAYDetailViewController.h"
#import "NAYPersonTableViewDataSource.h"

@interface NAYTableViewController ()

@property (weak, nonatomic) IBOutlet NAYPersonTableViewDataSource *dataSource;

@property (strong, nonatomic) NSArray *sectionTitles;


@end

@implementation NAYTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sectionTitles = @[@"Students", @"Teachers"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl targetForAction:@selector(refresh:) withSender:self];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"student_list_change_notification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.tableView reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[NAYDetailViewController class]]
        && [segue.identifier isEqualToString:@"StudentDetails"]) {
        NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
        
        NAYDetailViewController *desitinationViewController = (NAYDetailViewController *)segue.destinationViewController;
        desitinationViewController.selectedName = [self.tableView cellForRowAtIndexPath:selectedRow].textLabel.text;
    }
}

- (void)refresh:(id)sender
{
    [self.refreshControl endRefreshing];
}

- (IBAction)sortButton:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort"
                                                             delegate:self.dataSource
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:Nil
                                                    otherButtonTitles:@"Name", nil];
    [actionSheet showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate Methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *sectionLabel = [[UILabel alloc] init];
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    
    sectionLabel.text = self.sectionTitles[section];
    
    return sectionLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"students"]) {
        [self.tableView reloadData];
    }
}


@end
