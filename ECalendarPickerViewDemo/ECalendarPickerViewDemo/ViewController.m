//
//  ViewController.m
//  ECalendarPickerViewDemo
//
//  Created by measta on 2016/12/4.
//  Copyright © 2016年 meast. All rights reserved.
//

#import "ViewController.h"
#import "ECalendarPickerView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *switch1;
@property (weak, nonatomic) IBOutlet UISwitch *switch2;
@property (weak, nonatomic) IBOutlet UISwitch *switch3;
@property (weak, nonatomic) IBOutlet UISwitch *switch4;
@property (weak, nonatomic) IBOutlet UISwitch *switch5;
@property (weak, nonatomic) IBOutlet UISwitch *switch6;
@property (weak, nonatomic) IBOutlet UISwitch *switch7;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UIButton *btnPickDate;
- (IBAction)actPickDate:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actPickDate:(id)sender {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if(self.switch1.isOn) { [arr addObject:@"0"]; }
    if(self.switch2.isOn) { [arr addObject:@"1"]; }
    if(self.switch3.isOn) { [arr addObject:@"2"]; }
    if(self.switch4.isOn) { [arr addObject:@"3"]; }
    if(self.switch5.isOn) { [arr addObject:@"4"]; }
    if(self.switch6.isOn) { [arr addObject:@"5"]; }
    if(self.switch7.isOn) { [arr addObject:@"6"]; }
    
    
    ECalendarPickerView *picker = [[ECalendarPickerView alloc] initOnView:self.view];
    picker.enableDayOfWeek = [arr copy];
    picker.callbackOK = ^(NSInteger year, NSInteger month, NSInteger day){
        [self.labelDate setText:[NSString stringWithFormat:@"%ld-%.2ld-%.2ld", year, month, day]];
        NSLog(@"ok: %ld, %ld, %ld", year, month, day);
    };
}
@end
