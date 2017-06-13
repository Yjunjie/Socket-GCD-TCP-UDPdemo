
//
//  UDPServerCommunicationViewController.m
//  Socket-TCPdemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/13.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import "ClientViewController.h"
#import "UDPServerCommunicationViewController.h"

@interface UDPServerCommunicationViewController ()

@end

@implementation UDPServerCommunicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!_udpSocket)
    {
        _udpSocket=nil;
    }
    _udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSArray *nameArray=[NSArray arrayWithObjects:@"连接",@"发送",nil];
    for (int i=0;i<[nameArray count];i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:[nameArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(10+50*i, 30+64, 50, 30)];
        button.tag=100+i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    _ipText=[[UITextField alloc] initWithFrame:CGRectMake(10, 70+64, 300, 30)];
    _ipText.borderStyle = UITextBorderStyleRoundedRect;
    _ipText.text = HOST;
    [self.view addSubview:_ipText];
}

-(void)buttonClicked:(UIButton*)button
{
    if (button.tag==100){
        [self connectUDPTest];
    }else if(button.tag==101){
        [self sendUDPTouched];
    }
}

-(void)connectUDPTest
{
    NSError *error = nil;
    if(![_udpSocket connectedHost]){
        if (![_udpSocket connectToHost:HOST onPort:PORT error:&error]) {
            if (error==nil){
                NSLog(@"连接成功");
            }else{
                NSLog(@"连接失败：%@",error);
            }
        }else{
            NSLog(@"已经连接");
        }
    }else{
        NSLog(@"已经连接:%@",[_udpSocket connectedHost]);
    }
    
}

- (void)sendUDPTouched{
    
    [_udpSocket sendData:[_ipText.text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:1];
//    [_udpSocket sendData:[_ipText.text dataUsingEncoding:NSUTF8StringEncoding] toHost:HOST port:PORT withTimeout:-1 tag:1];
    NSLog(@"Udp Echo server started on port %hu", [_udpSocket localPort]);
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    NSError *error = nil;
    NSLog(@"Message didConnectToAddress: %@",[[NSString alloc]initWithData:address encoding:NSUTF8StringEncoding]);
    [_udpSocket beginReceiving:&error];
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    NSLog(@"Message didNotConnect: %@",error);
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"Message didNotSendDataWithTag: %@",error);
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSLog(@"Message didReceiveData :%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
     NSLog(@"Message 发送成功");
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
