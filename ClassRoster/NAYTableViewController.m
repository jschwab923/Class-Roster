//
//  NAYTableViewControllerNew.m
//  FirstDayDemo
//
//  Created by Jeff Schwab on 1/13/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYTableViewController.h"
#import "NAYDetailViewController.h"

@interface NAYTableViewController ()

@property (strong, nonatomic) NSArray *students;
@property (strong, nonatomic) NSArray *teachers;
@property (strong, nonatomic) NSArray *sectionTitles;

@property (strong, nonatomic) NSString *studentListPlistPath;

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

    NSString *teacher1 = @"Clem";
    NSString *teacher2 = @"Brad";
    
    NSString *studentsSectionTitle = @"Students";
    NSString *teachersSectionTitle = @"Teachers";
    
    self.sectionTitles = @[studentsSectionTitle, teachersSectionTitle];
    self.teachers = @[teacher1, teacher2];
    
    // Set the students array from a plist
    self.studentListPlistPath = [[NSBundle mainBundle] pathForResource:@"StudentList" ofType:@".plist"];
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:self.studentListPlistPath];
    NSArray *studentList = [plistDictionary objectForKey:@"Students"];
    self.students = studentList;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl targetForAction:@selector(refresh:) withSender:self];
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
    // Assume plist file has been changed and reload students array from plist
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:self.studentListPlistPath];
    NSArray *studentList = [plistDictionary objectForKey:@"Students"];
    self.students = studentList;
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

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.students count];
            break;
        case 1:
            return [self.teachers count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentCell" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.students[indexPath.row];
            break;
        case 1:
            cell.textLabel.text = self.teachers[indexPath.row];
            break;
        default:
            break;
    }
    return cell;
}

@end
