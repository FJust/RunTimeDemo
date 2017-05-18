//
//  TestViewController.m
//  RunTimeDemo
//
//  Created by PF on 2017/5/16.
//  Copyright © 2017年 PF. All rights reserved.
//

#import "TestViewController.h"
#import <objc/runtime.h>

@interface TestViewController ()

@property (nonatomic, assign)int testInt;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)run{
    NSLog(@"跑啊");
}

+ (void)study{
    NSLog(@"我渴望学习");
}

char* testName;

- (void)setName:(NSString *)name{
    objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name{
//    NSLog(@"cmd is %@", _cmd);
   return objc_getAssociatedObject(self, _cmd);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
