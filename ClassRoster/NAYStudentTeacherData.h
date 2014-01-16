//
//  NAYStudentTeacherData.h
//  Class Roster
//
//  Created by Jeff Schwab on 1/14/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAYStudentTeacherData : NSObject


+ (NAYStudentTeacherData *)sharedManager;
- (void)createArraysFromPlistAtPath:(NSString *)path;

@property (nonatomic) NSString* studentListPath;
@property (nonatomic) NSString* teacherListPath;

@property (nonatomic) NSArray *teacherList;
@property (nonatomic) NSArray *studentList;

@end
