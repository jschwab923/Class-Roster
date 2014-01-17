//
//  NAYPersonTableViewDataSource.m
//  Class Roster
//
//  Created by Jeff Schwab on 1/14/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYPersonTableViewDataSource.h"
#import "NAYStudentTeacherData.h"
#import "NAYPerson.h"
#import "NAYPersonTableViewCell.h"

@interface NAYPersonTableViewDataSource ()

@property (strong, nonatomic) NSArray *sectionTitles;

@property (strong, nonatomic) NSString *studentListPath;
@property (strong, nonatomic) NSString *teacherListPath;

@end

@implementation NAYPersonTableViewDataSource

- (id)init
{
    if (self = [super init]) {
        NSString *studentsSectionTitle = @"Students";
        NSString *teachersSectionTitle = @"Teachers";
        
        self.sectionTitles = @[studentsSectionTitle, teachersSectionTitle];
    }
    return self;
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
            return [[[NAYStudentTeacherData sharedManager] studentList] count];
            break;
        case 1:
            return [[[NAYStudentTeacherData sharedManager] teacherList] count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NAYPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    NAYPerson *selectedPerson;
    switch (indexPath.section) {
        case 0:
            selectedPerson = [[NAYStudentTeacherData sharedManager] studentList][indexPath.row];
            [cell setPerson:selectedPerson];
            break;
        case 1:
            selectedPerson = [[NAYStudentTeacherData sharedManager] teacherList][indexPath.row];
            [cell setPerson:selectedPerson];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Name"]) {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [[NAYStudentTeacherData sharedManager] setStudentList:
            [[[NAYStudentTeacherData sharedManager] studentList] sortedArrayUsingDescriptors:@[sort]]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STUDENT_LIST_CHANGE object:[[NAYStudentTeacherData sharedManager] studentList]];
}

@end
