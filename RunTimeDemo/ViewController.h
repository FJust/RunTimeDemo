//
//  ViewController.h
//  RunTimeDemo
//
//  Created by PF on 2017/5/16.
//  Copyright © 2017年 PF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end


@interface ClassCustomClass :NSObject{
    __unsafe_unretained NSString *varTest1;
    __unsafe_unretained NSString *varTest2;
    __unsafe_unretained NSString *varTest3;
}
@property (nonatomic,assign)NSString *varTest1;
@property (nonatomic,assign)NSString *varTest2;
@property (nonatomic,assign)NSString *varTest3;
- (void) fun1;
@end
