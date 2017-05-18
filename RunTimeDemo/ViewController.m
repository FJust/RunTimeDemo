//
//  ViewController.m
//  RunTimeDemo
//
//  Created by PF on 2017/5/16.
//  Copyright © 2017年 PF. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "TestViewController.h"
#import "NSObject+Test.h"

@interface ViewController (){
    TestViewController *obj;
    ClassCustomClass *allobj;
}

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Method a = class_getClassMethod([TestViewController class], @selector(run));
    
    Method b = class_getClassMethod([TestViewController class], @selector(study));
    
    method_exchangeImplementations(a, b);
    
    TestViewController *vc = [TestViewController new];
    
    [TestViewController run];
    
    [TestViewController study];
    
    objc_setAssociatedObject(vc, @"key1", @(100), OBJC_ASSOCIATION_ASSIGN);
    
    NSLog(@"%@", objc_getAssociatedObject(vc, @"key1"));
    
    vc.name = @"一个假名字";
    
    NSLog(@"%@", vc.name);
    
    ;
    NSLog(@"对象的类 %@", object_getClass(vc));
    
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList(vc.class, &count);
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        NSLog(@"The property type: %s ,name: %s",type, name);
    }
    
    free(ivars);
    
   BOOL addMethod =  class_addMethod(vc.class, @selector(hello), (IMP)cfunction, "v@:@");
    
    if (addMethod) {
        [vc performSelector:@selector(hello) withObject:@"hehe"];
    }
    
    
    obj = [TestViewController new];
    [obj setName:@"反向映射"];
    NSLog(@"值 %@",obj.name);
    NSLog(@"反向 %@", [self valueOfInstance:@"反向映射"]);
    
//    allobj = [ClassCustomClass new];
//    allobj.varTest1 =@"varTest1String";
//    allobj.varTest2 =@"varTest2String";
//    allobj.varTest3 =@"varTest3String";
//    NSString *str = [self valueOfInstance:@"varTest1String"];
//    NSLog(@"反向:%@", str);
    [NSObject log];
    [[NSObject new] log];
    [self test];
}

int cfunction(id self, SEL _cmd, NSString *str) {
    NSLog(@"%@", str);
    return 10;//随便返回个值
}


// 自定义一个方法
void sayFunction(id self, SEL _cmd, id some) {
//    NSLog(@"%@岁的%@说：%@", object_getIvar(self, class_getInstanceVariable([self class], "_age")),[self valueForKey:@"name"],some);
    NSLog(@"%@岁的%@说：%@", object_getIvar(self, class_getInstanceVariable([self class], "_age")),objc_getAssociatedObject(self, @"name"),some);

}

- (void)test{
    
    Class People = objc_allocateClassPair([NSObject class], "People", 0);
//    class_addIvar([People class], "_name", sizeof(NSString *), sizeof(NSString *), @encode(NSString *));
    class_addIvar([People class], "_age", sizeof(int), sizeof(int), @encode(int));
    
    SEL s = sel_registerName("say:");
    
    class_addMethod(People, s, (IMP)sayFunction, "v@:@");
    
    objc_registerClassPair(People);
    
    unsigned int count;
    objc_copyClassList(&count);
    
    id p = [[People alloc]init];
    
    objc_setAssociatedObject(p, @"name", @"程序员", OBJC_ASSOCIATION_COPY_NONATOMIC);
//
//    [p valueForKey:@"name"];

//    [p setValue:@"苍老师" forKey:@"name"];
//    
//    objc_getAssociatedObject(p, @"name");
    
    Ivar ageIvar = class_getInstanceVariable(People, "_age");
    
    object_setIvar(p, ageIvar, @18);
    
    ((void (*)(id, SEL, id))objc_msgSend)(p, s, @"大家好");
    
    p = nil;
    
    objc_disposeClassPair(People);
    
//    id p1 = [[People alloc]init];
    
//    Ivar ivar0 = object_getInstanceVariable([p1 class], "_name");
//    
//    Ivar ivar1 = object_setInstanceVariable([People class], <#Ivar ivar#>, <#id value#>)
}

- (void)hello{
    NSLog(@"hello");
}

- (NSString *)valueOfInstance:(id)instance{
    
    NSString *keyName = nil;
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(obj.class, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSString *typeName = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        if (![typeName hasPrefix:@"@"]) {
            continue;
        }
                
        if (object_getIvar(obj, ivar) == instance) {
            keyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
            break;
        }
    }
    free(ivars);
    return keyName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation ClassCustomClass
@synthesize varTest1, varTest2, varTest3;
- (void) fun1 {
    NSLog(@"fun1");
}
@end

