// Copyright (c) 2013 Mutual Mobile (http://mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MMGridCell.h"

@interface MMGridCell ()

@property (nonatomic) UIColor *normalTextColor;
@property (nonatomic) UIColor *selectedTextColor;

@end

@implementation MMGridCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
        _textLabel = [[UILabel alloc] initWithFrame:rect];
        _textLabel.backgroundColor = [UIColor clearColor];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            _textLabel.font = [UIFont systemFontOfSize:11.0f];
        }
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _normalTextColor = _textLabel.textColor;
        _selectedTextColor = [UIColor whiteColor];
        _selectedBackgroundColor = [UIColor lightGrayColor];
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = _selectedBackgroundColor;
        [self.contentView addSubview:_textLabel];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (!self.selected) self.textLabel.textColor = highlighted ? self.selectedTextColor : self.normalTextColor;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.textLabel.textColor = selected ? self.selectedTextColor : self.normalTextColor;
}

@end
