//
//  ECalendarPickerView.m
//  ECalendarPickerViewDemo
//
//  Created by measta on 2016/12/4.
//  Copyright © 2016年 meast. All rights reserved.
//

#import "ECalendarPickerView.h"
#import "ECalendarPickerCollectionViewCell.h"

@interface ECalendarPickerView()

@property (nonatomic, strong) NSString *cellIdText;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UIView *actionView;
@property (nonatomic, strong) UIView *cvBackView;

@property (nonatomic, strong) UIColor *titleBGColor;
@property (nonatomic, strong) UIColor *titleTextColor;

@property (nonatomic, strong) UIButton *btnOK;
@property (nonatomic, strong) UIButton *btnCancel;

@property (nonatomic, strong) UIButton *btnLastMonth;
@property (nonatomic, strong) UIButton *btnNextMonth;

@property (nonatomic, strong) UILabel *labelCurrentMonth;

@property (nonatomic, strong) NSArray *weekDayArray;

@property (nonatomic) CGFloat cellWidth;

@property NSInteger selectedDay;

@end

@implementation ECalendarPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    
}

- (instancetype)initOnView:(UIView *)view {
    CGFloat width = view.bounds.size.width * 0.8;
    CGFloat height = view.bounds.size.height * 0.8;
    CGFloat x = view.bounds.size.width * 0.1;
    CGFloat y = view.bounds.size.height * 0.1;
    CGRect rect = CGRectMake(x, y, width, height);
    self = [super initWithFrame:rect];
    [self setBackgroundColor:[UIColor colorWithRed:0xfe/255.0f green:0xfe/255.0f blue:0xfe/255.0f alpha:1.0f]];
    self.weekDayArray = @[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"];
    self.titleBGColor = [UIColor colorWithRed:95/255.0f green:183/255.0f blue:255/255.0f alpha:1.0f];
    self.titleTextColor = [UIColor whiteColor];
    self.cellIdText = @"cellIdText";
    
    self.maskView = [[UIView alloc] initWithFrame:view.bounds];
    [self.maskView setBackgroundColor:[UIColor blackColor]];
    [self.maskView setAlpha:0.3f];
    
    
    
    
    self.topView = [[UIView alloc] init];
    CGRect rectTop = rect;
    rectTop.size.height = 50;
    rectTop.origin.x = 0;
    rectTop.origin.y = 0;
    [self.topView setFrame:rectTop];
    [self.topView setBackgroundColor:self.titleBGColor];
    
    self.actionView = [[UIView alloc] init];
    //[self.actionView setBackgroundColor:[UIColor lightGrayColor]];
    CGFloat xOK = self.cellWidth * 4;
    CGFloat xCancel = self.cellWidth * 1;
    CGRect rectOK = CGRectMake(xOK, 0, self.cellWidth * 2, self.cellWidth);
    CGRect rectCancel = CGRectMake(xCancel, 0, self.cellWidth * 2, self.cellWidth);
    
    self.btnOK = [[UIButton alloc] initWithFrame:rectOK];
    [self.btnOK setTitle:@"OK" forState:UIControlStateNormal];
    [self.btnOK setTitleColor:self.titleBGColor forState:UIControlStateNormal];
    [self.btnOK addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnCancel = [[UIButton alloc] initWithFrame:rectCancel];
    [self.btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:self.titleBGColor forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    [self.actionView addSubview:self.btnCancel];
    [self.actionView addSubview:self.btnOK];
    
    CGRect rectLable = CGRectMake(100, 0, 100, 40);
    self.statusView = [[UIView alloc] initWithFrame:rectLable];
    
    self.labelCurrentMonth = [[UILabel alloc] init];
    [self.labelCurrentMonth setTextAlignment:NSTextAlignmentCenter];
    [self.labelCurrentMonth setFont:[UIFont systemFontOfSize:14]];
    [self.labelCurrentMonth setAdjustsFontSizeToFitWidth:YES];
    [self.labelCurrentMonth setTextColor:[UIColor blackColor]];
    
    self.btnLastMonth = [[UIButton alloc] init];
    self.btnNextMonth = [[UIButton alloc] init];
    [self.btnLastMonth setTitle:@"<" forState:UIControlStateNormal];
    [self.btnNextMonth setTitle:@">" forState:UIControlStateNormal];
    [self.btnLastMonth addTarget:self action:@selector(previouseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnNextMonth addTarget:self action:@selector(nexAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLastMonth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnNextMonth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    [self.statusView addSubview:self.labelCurrentMonth];
    [self.statusView addSubview:self.btnLastMonth];
    [self.statusView addSubview:self.btnNextMonth];
    
    self.cvBackView = [[UIView alloc] init];
    [self.cvBackView setBackgroundColor:[UIColor grayColor]];
    
    
    CGFloat maxWidth = (view.frame.size.width > view.frame.size.height) ? view.frame.size.height : view.frame.size.width;
    self.cellWidth = maxWidth * 0.8 / 7;
    
    CGRect cvRect = CGRectMake(20, 20, self.cellWidth * 7, self.cellWidth * 7);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(self.cellWidth, self.cellWidth)];
    [layout setMinimumLineSpacing:1];
    [layout setMinimumInteritemSpacing:0];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 1, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:cvRect collectionViewLayout:layout];
    [self.collectionView registerClass:[ECalendarPickerCollectionViewCell class] forCellWithReuseIdentifier:self.cellIdText];
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:0xfe/255.0f green:0xfe/255.0f blue:0xfe/255.0f alpha:0.9]];
    
    
    [self.cvBackView addSubview:self.collectionView];
    [self addSubview:self.topView];
    [self addSubview:self.actionView];
    [self addSubview:self.statusView];
    [self addSubview:self.cvBackView];
    
    [view addSubview:self.maskView];
    [view addSubview:self];
    
    [self addTap];
    [self addSwipe];
    
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.maskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.topView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.statusView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.actionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.cvBackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.labelCurrentMonth setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.btnOK setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.btnCancel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.btnLastMonth setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.btnNextMonth setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.maskView attribute:NSLayoutAttributeTop multiplier:1 constant:50]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.maskView attribute:NSLayoutAttributeLeading multiplier:1 constant:5]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:40]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:40]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.actionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.actionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.actionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.actionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:40]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cvBackView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cvBackView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cvBackView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.statusView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cvBackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.actionView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.cvBackView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cvBackView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:self.cellWidth*7+8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.cvBackView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [self.statusView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelCurrentMonth attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.statusView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.statusView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelCurrentMonth attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.statusView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //[self.statusView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelCurrentMonth attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.statusView attribute:NSLayoutAttributeWidth multiplier:0.4 constant:0]];
    //[self.statusView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelCurrentMonth attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.statusView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [self.statusView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLastMonth attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.statusView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.statusView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnLastMonth attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.statusView attribute:NSLayoutAttributeLeading multiplier:1 constant:20]];
    
    [self.statusView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnNextMonth attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.statusView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.statusView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnNextMonth attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.statusView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20]];
    
    
    
    
    [self.actionView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnOK attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.actionView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.actionView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnOK attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.actionView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-40]];
    [self.actionView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnOK attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.actionView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.actionView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnOK attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.actionView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.actionView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnCancel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.actionView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.actionView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnCancel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.actionView attribute:NSLayoutAttributeLeading multiplier:1 constant:40]];
    [self.actionView addConstraint:[NSLayoutConstraint constraintWithItem:self.btnCancel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.actionView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
     
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.today = [NSDate date];
    self.date = self.today;
    
    return self;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    [self.labelCurrentMonth setText:[NSString stringWithFormat:@"%ld-%.2ld", [self year:date], (long)[self month:date]]];
    [self.collectionView reloadData];
}

- (void)hide {
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
        self.maskView.alpha = 0;
    } completion:^(BOOL isFinished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)show {
    self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
    }];
}

- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.maskView addGestureRecognizer:tap];
}


- (void)addSwipe {
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nexAction:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseAction:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}

- (IBAction)okAction:(id)sender {
    if(self.callbackOK) {
        NSInteger year = [self year:self.date];
        NSInteger month = [self month:self.date];
        NSInteger day = self.selectedDay;
        if(!day || day <= 0 || day > [self totaldaysInMonth:self.date]) {
            day = [self day:self.date];
        }
        self.callbackOK(year, month, day);
    }
    [self hide];
}

- (IBAction)previouseAction:(UIButton *)sender {
    [UIView transitionWithView:self.cvBackView duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.date = [self lastMonth:self.date];
    } completion:nil];
}

- (IBAction)nexAction:(UIButton *)sender {
    [UIView transitionWithView:self.cvBackView duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.date = [self nextMonth:self.date];
    } completion:nil];
}

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Tues. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInThisMonth:(NSDate *)date {
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date {
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma mark - collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 0) {
        return 7;
    }
    return 42;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECalendarPickerCollectionViewCell *cell = (ECalendarPickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if(indexPath.section == 0) {
        return NO;
    }
    if(indexPath.section == 1) {
        if(cell.labelText.isEnabled) {
            return YES;
        }
    }
    return YES;
}


- (CGSize) collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(self.cellWidth, self.cellWidth);
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(section == 0) {
        return UIEdgeInsetsMake(0.0f, 1.0f, 1.0f, 0.0f);
    }
    return UIEdgeInsetsMake(1.0f, 0.0f, 1.0f, 0.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECalendarPickerCollectionViewCell *cell = (ECalendarPickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(indexPath.section == 1) {
        NSLog(@"selected: %@", cell.labelText.text);
        if(cell.labelText.isEnabled) {
            self.selectedDay = cell.tag;
            [cell setBackgroundColor:self.titleBGColor];
            [cell.labelText setTextColor:[UIColor whiteColor]];
            [cell.layer setCornerRadius:self.cellWidth/2];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECalendarPickerCollectionViewCell *cell = (ECalendarPickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    if(indexPath.section == 1) {
        if(cell.labelText.isEnabled) {
            [cell.labelText setTextColor:[UIColor blackColor]];
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.layer setCornerRadius:0];
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECalendarPickerCollectionViewCell *cell = (ECalendarPickerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdText forIndexPath:indexPath];
    CGRect rect = cell.frame;
    rect.size.width = rect.size.width * 0.9;
    rect.origin.x = 0;
    rect.origin.y = 0;
    [cell.labelText setFrame:rect];
    [cell.layer setCornerRadius:0];
    [cell setSelected:NO];
    [cell setHighlighted:NO];
    if(indexPath.section == 0) {
        [cell setBackgroundColor:self.titleBGColor];
        [cell.labelText setTextColor:self.titleTextColor];
        NSString *strTitle = @"";
        if(self.weekDayArray.count > indexPath.row) {
            strTitle = self.weekDayArray[indexPath.row];
        } else {
            strTitle = [NSString stringWithFormat:@"%ld", indexPath.row];
        }
        [cell.labelText setText:strTitle];
        [cell.labelText setEnabled:YES];
    }
    if(indexPath.section == 1) {
        [cell setBackgroundColor:[UIColor whiteColor]];
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        NSInteger dayOfWeek = i % 7;
        if(i < firstWeekday) {
            [cell.labelText setText:@""];
            [cell.labelText setEnabled:NO];
        } else if (i > firstWeekday + daysInThisMonth - 1) {
            [cell.labelText setText:@""];
            [cell.labelText setEnabled:NO];
        } else {
            day = i - firstWeekday + 1;
            cell.tag = day;
            [cell.labelText setText:[NSString stringWithFormat:@"%ld", day]];
        }
        
        if(self.enableAllDay) {
            
        } else {
            [cell.labelText setEnabled:NO];
            
            if(self.enableDayOfWeek && self.enableDayOfWeek.count > 0) {
                
                if([self.enableDayOfWeek containsObject:[NSString stringWithFormat:@"%ld", dayOfWeek]]) {
                    [cell.labelText setEnabled:YES];
                } else {
                    if(dayOfWeek == 7) {
                        if([self.enableDayOfWeek containsObject:@"0"]) {
                            if(cell.tag > 0) {
                                [cell.labelText setEnabled:YES];
                            }
                        }
                    }
                }
            }
        }
        
        if(cell.labelText.isEnabled) {
            [cell.labelText setTextColor:[UIColor blackColor]];
        } else {
            [cell.labelText setTextColor:[UIColor lightGrayColor]];
        }
    }
    return cell;
}

@end
