

//
//  UIViewControllerBase.m
//  Socket-TCPdemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/12.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import "UIViewControllerBase.h"
#import "ClientViewController.h"
#import "ServerViewController.h"
#import "UDPViewController.h"
#import "UDPServerCommunicationViewController.h"
#import "UDPServerViewController.h"

@interface UIViewControllerBase ()
{
    NSArray *nameArray;
}
@end

@implementation UIViewControllerBase

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    /**
     TCP相关类
     **/
    NSString *className1=@"ServerViewController";//服务器类
    NSString *className2=@"ClientViewController";//客户端类
    /**
     UDP相关类
     **/
    NSString *className3=@"UDPViewController";//客户端类
    NSString *className4=@"UDPServerCommunicationViewController";//客户端类
    NSString *className5=@"UDPServerViewController";//服务器类

    nameArray=[NSArray arrayWithObjects:className1,className2,className3,className4,className5, nil];
    
    for (int i=0;i<[nameArray count];i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:[nameArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(50,100+100*i,Screen_Width-100, 30)];
        button.tag=i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)buttonClicked:(UIButton*)button
{
    UIViewController *vc=[[NSClassFromString([nameArray objectAtIndex:button.tag]) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
