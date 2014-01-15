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

@interface NAYPersonTableViewDataSource ()

@property (strong, nonatomic) NSArray *students;
@property (strong, nonatomic) NSArray *teachers;
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
        
        NSString *plistBundlePath = [[NSBundle mainBundle] pathForResource:@"Bootcamp" ofType:@".plist"];
        NAYStudentTeacherData *studentTeacherData = [[NAYStudentTeacherData alloc] init];
        [studentTeacherData createArraysFromPlistAtPath:plistBundlePath];
        
        self.students = studentTeacherData.studentList;
        self.teachers = studentTeacherData.teacherList;
        
        self.studentListPath = studentTeacherData.studentListPath;
        self.teacherListPath = studentTeacherData.teacherListPath;
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
    NAYPerson *selectedPerson;
    switch (indexPath.section) {
        case 0:
            selectedPerson = self.students[indexPath.row];
            cell.textLabel.text = selectedPerson.name;
            break;
        case 1:
            selectedPerson = self.teachers[indexPath.row];
            cell.textLabel.text = selectedPerson.name;
            break;
        default:
            break;
    }
    return cell;
}

@end
