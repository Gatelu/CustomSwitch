//
//  ViewController.m
//  重写开关
//
//  Created by Gate on 16/1/9.
//  Copyright © 2016年 Gate. All rights reserved.
//

#import "ViewController.h"
#import "SwitchView.h"
@interface ViewController ()
@property (nonatomic, strong) SwitchView *ibSwitch;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // this will create the switch with default dimensions, you'll still need to set the position though
    // you also have the option to pass in a frame of any size you choose
    SwitchView *mySwitch = [[SwitchView alloc] initWithFrame:CGRectMake(0, 0,100, 30)];
    mySwitch.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5);
    [mySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mySwitch];
    [mySwitch setOn:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)switchChanged:(SwitchView *)sender {
    NSLog(@"Changed value to: %@", sender.on ? @"ON" : @"OFF");
}
@end
