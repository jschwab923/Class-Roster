//
//  NAYStudent.h
//  Class Roster
//
//  Created by Jeff Schwab on 1/13/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAYPerson : NSObject <NSCoding>

- (instancetype)initWithName:(NSString *)name imagePath:(NSString *)imagePath twitter:(NSString *)twitter github:(NSString *)github;

@property (nonatomic) NSString *name;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *imagePath;
@property (nonatomic) NSString *twitter;
@property (nonatomic) NSString *github;

@end
