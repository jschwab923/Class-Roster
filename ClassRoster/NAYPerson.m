//
//  NAYStudent.m
//  Class Roster
//
//  Created by Jeff Schwab on 1/13/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYPerson.h"

@implementation NAYPerson

- (instancetype)initWithName:(NSString *)name imagePath:(NSString *)imagePath twitter:(NSString *)twitter github:(NSString *)github
{
    if (self = [super init]) {
        self.name = name;
        self.imagePath = imagePath;
        self.twitter = twitter;
        self.github = github;
        
        NSNumber *redValue = [NSNumber numberWithFloat:1];
        NSNumber *greenValue = [NSNumber numberWithFloat:1];
        NSNumber *blueColor = [NSNumber numberWithFloat:1];
        self.favoriteColor = @[redValue, greenValue, blueColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.imagePath = [decoder decodeObjectForKey:@"imagePath"];
        self.twitter = [decoder decodeObjectForKey:@"twitterUsername"];
        self.github = [decoder decodeObjectForKey:@"githubUsername"];
        self.favoriteColor = [decoder decodeObjectForKey:@"favoriteColor"];
    };
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.imagePath forKey:@"imagePath"];
    [encoder encodeObject:self.twitter forKey:@"twitterUsername"];
    [encoder encodeObject:self.github forKey:@"githubUsername"];
    [encoder encodeObject:self.favoriteColor forKey:@"favoriteColor"];
}

@end
