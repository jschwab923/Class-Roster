//
//  NAYPersonTableViewCell.m
//  Class Roster
//
//  Created by Jeff Schwab on 1/16/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYPersonTableViewCell.h"
#import <FaceAwareFill/UIImageView+UIImageView_FaceAwareFill.h>

@implementation NAYPersonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setPerson:(NAYPerson *)person
{
    _person = person;
    if ([[NSFileManager defaultManager] fileExistsAtPath:_person.imagePath]) {
        NSData *imageData = [NSData dataWithContentsOfFile:_person.imagePath];
        UIImage *personImage = [UIImage imageWithData:imageData];
        self.imageView.image = personImage;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 22;
    } else {
        self.imageView.image = nil;
    }
    self.textLabel.text = _person.name;
}

@end
