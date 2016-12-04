//
//  ECalendarPickerCollectionViewCell.m
//  ECalendarPickerViewDemo
//
//  Created by measta on 2016/12/4.
//  Copyright © 2016年 meast. All rights reserved.
//

#import "ECalendarPickerCollectionViewCell.h"

@implementation ECalendarPickerCollectionViewCell

- (UILabel *)labelText {
    if(!_labelText) {
        _labelText = [[UILabel alloc] initWithFrame:self.bounds];
        [_labelText setTextAlignment:NSTextAlignmentCenter];
        [_labelText setFont:[UIFont systemFontOfSize:14.0f]];
        [_labelText setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:_labelText];
    }
    return _labelText;
}
@end
