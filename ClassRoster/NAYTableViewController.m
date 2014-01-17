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
#import "NAYStudentTeacherData.h"

@interface NAYTableViewController ()

{
    NSIndexPath *_lastSelectedRow;
}

@property (weak, nonatomic) IBOutlet NAYPersonTableViewDataSource *dataSource;
@property (strong, nonatomic) NSArray *sectionTitles;

@end

@implementation NAYTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //Allocates the singleton and sets up data
        [NAYStudentTeacherData sharedManager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up local variable to store last selected row
    _lastSelectedRow = [[NSIndexPath alloc] init];
    
    self.sectionTitles = @[@"Students", @"Teachers"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
   
    // Listen for a change to the list of students
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_STUDENT_LIST_CHANGE object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_lastSelectedRow) {
        [self.tableView reloadRowsAtIndexPaths:@[_lastSelectedRow] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[NAYDetailViewController class]]
        && [segue.identifier isEqualToString:@"StudentDetails"]) {
        NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
        
        // Store for when viewDidAppear is called when user comes back to table view
        _lastSelectedRow = selectedRow;
        
        NAYDetailViewController *desitinationViewController = (NAYDetailViewController *)segue.destinationViewController;
        
        NSArray *studentList = [[NAYStudentTeacherData sharedManager] studentList];
        NSArray *teacherList = [[NAYStudentTeacherData sharedManager] teacherList];
        
        if (selectedRow.section == 0) {
            desitinationViewController.selectedPerson = [studentList objectAtIndex:selectedRow.row];
        } else if (selectedRow.section == 1) {
            desitinationViewController.selectedPerson = [teacherList objectAtIndex:selectedRow.row];
        }
    }
}

- (void)refresh:(id)sender
{
    [self.tableView reloadData];
    [sender endRefreshing];
}

- (IBAction)sortButton:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:Nil
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

@end
