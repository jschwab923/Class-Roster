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
    
    // Listen for a change to the list of students 
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_STUDENT_LIST_CHANGE object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.tableView reloadData];
    }];
    
// TODO: Try to find a cleaner way to do this. Don't want to abuse notification center.
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_IMAGE_ADDED
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock: ^(NSNotification *note) {
                                                      
        NAYPerson *updatedPerson = [[note userInfo] objectForKey:USER_INFO_KEY_UPDATED_PERSON];
                                                      NSUInteger objectIndex = [[[NAYStudentTeacherData sharedManager] studentList] indexOfObject:updatedPerson];
        NSIndexPath *updatedPath = [NSIndexPath indexPathForRow:objectIndex inSection:0];
        NSInteger cellImageViewHeight = CGRectGetHeight([self.tableView cellForRowAtIndexPath:updatedPath].layer.bounds);
        UITableViewCell *updatedCell = [self.tableView cellForRowAtIndexPath:updatedPath];
        updatedCell.imageView.layer.cornerRadius = cellImageViewHeight/2;
        updatedCell.imageView.layer.masksToBounds = YES;
        
        [self.tableView reloadRowsAtIndexPaths:@[updatedPath] withRowAnimation:UITableViewRowAnimationLeft];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[NAYDetailViewController class]]
        && [segue.identifier isEqualToString:@"StudentDetails"]) {
        NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
        
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
    [self.refreshControl endRefreshing];
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

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}


@end
