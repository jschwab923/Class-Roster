//
//  NAYStudentTeacherData.m
//  Class Roster
//
//  Created by Jeff Schwab on 1/14/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYStudentTeacherData.h"
#import "NAYPerson.h"

@implementation NAYStudentTeacherData

- (instancetype)init
{
    if (self = [super init]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Bootcamp" ofType:@"plist"];
        [self createArraysFromPlistAtPath:plistPath];
    }
    return self;
}

+ (id)sharedManager {
    static NAYStudentTeacherData *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)createArraysFromPlistAtPath:(NSString *)path {
    // Get plist from bundle and create arrays to be used with the NSKeyedArchiver
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *temporaryTeacherArray = [[NSMutableArray alloc] init];
    NSMutableArray *temporaryStudentArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *currentPerson in plistArray) {
        if ([currentPerson objectForKey:@"teacher"]) {
            NAYPerson *newTeacher = [[NAYPerson alloc] initWithName:currentPerson[@"name"]
                                                          imagePath:@"no image"
                                                            twitter:currentPerson[@"twitter"]
                                                             github:currentPerson[@"github"]];
            [temporaryTeacherArray addObject:newTeacher];
        } else {
            NAYPerson *newStudent = [[NAYPerson alloc] initWithName:currentPerson[@"name"]
                                                          imagePath:@"no image"
                                                            twitter:currentPerson[@"twitter"]
                                                             github:currentPerson[@"github"]];
            [temporaryStudentArray addObject:newStudent];
        }
    }
    
    // Create file paths for teacher list and student list
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    self.studentListPath = [documentsDirectory stringByAppendingPathComponent:@"Students"];
    self.teacherListPath = [documentsDirectory stringByAppendingPathComponent:@"Teachers"];
    
    if (![defaultManager fileExistsAtPath:self.teacherListPath]) {
        [NSKeyedArchiver archiveRootObject:temporaryTeacherArray toFile:self.teacherListPath];
    }
    if (![defaultManager fileExistsAtPath:self.studentListPath]) {
        [NSKeyedArchiver archiveRootObject:temporaryStudentArray toFile:self.studentListPath];
    }
    
    self.studentList = [NSKeyedUnarchiver unarchiveObjectWithFile:self.studentListPath];
    self.teacherList = [NSKeyedUnarchiver unarchiveObjectWithFile:self.teacherListPath];
    
}

@end
