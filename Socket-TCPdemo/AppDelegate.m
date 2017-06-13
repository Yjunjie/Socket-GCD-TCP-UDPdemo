//
//  AppDelegate.m
//  Socket-TCPdemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/10.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import "AppDelegate.h"
#import "ClientViewController.h"
#import "ServerViewController.h"
#import "UIViewControllerBase.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString *className=@"UIViewControllerBase";//客户端类
    //用指定的类名获这个类
    //NSClassFromString(@"")
    UIViewController *vc=[[NSClassFromString(className) alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.window setRootViewController:nav];
    /*
     1.连接服务器
     2.获取服务器的好友列表（IP）
     3.输入文本 点击Cell中得一行（建立一个客户端之间的TCP连接） 点击键盘的return键 消息就会发送到对方
     
     TCP交互
     1.先和服务器建立TCP连接 [serverSocket connectToHost:@"服务器IP" onPort:0x1234 error:nil];  serverSocket就会指向服务器 向服务器发请求只需要往serverSocket对象中写数据
     2.向服务器写数据 [serverSocket writeData:data withTimeout:-1 tag:400];
     3.服务器代理监听数据接受 onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
     行参sock谁向服务器发消息 那么sock就会指向谁 data发送内容对应的二进制
     4.服务器根据data内容对客户端做出响应
     data内容自定义协议
     [sock writeData:newData withTimeout:-1 tag:300]
     其中newData就是服务器需要响应客户端的二进制内容
     5.客户端通过代理接受服务器的响应数据
     onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
     其中data就是服务器响应客户端请求的数据
     */
    
    [self.window makeKeyAndVisible];
    return YES;
}





@end
