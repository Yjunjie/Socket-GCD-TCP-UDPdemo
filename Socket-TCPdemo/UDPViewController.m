//
//  UDPViewController.m
//  udp
//
//  Created by Jakey on 15/1/12.
//  Copyright (c) 2015年 jakey. All rights reserved.
//


#import "UDPViewController.h"

@interface UDPViewController ()

@end

@implementation UDPViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSocket];
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
    _ipText.delegate=self;
    _ipText.borderStyle = UITextBorderStyleRoundedRect;
    _ipText.text = @"192.168.1.21";
    [self.view addSubview:_ipText];
    
}

-(void)initSocket
{

    
//    _recvSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//    [_recvSocket bindToPort:recvPort error:nil];
//    if (![_recvSocket beginReceiving:nil]) {
//        [_recvSocket close];
//        NSLog(@"Error starting server");
//        return;
//    }
//    
//    _sendSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//    [_sendSocket bindToPort:sendPort error:nil];
    
}

-(void)buttonClicked:(UIButton*)button
{
    if (button.tag==100){
        [self connectUDPTest];
    }else if(button.tag==101){
        [self sendUDPTouched];
    }
}

- (void)connectUDPTest{
    
    NSError *error = nil;
    if (!_udpSocket)
    {
        _udpSocket=nil;
    }
    _udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    if (error!=nil) {
        NSLog(@"连接失败：%@",error);
    }else{
        NSLog(@"连接成功");
    }
    if (![_udpSocket bindToPort:PORT error:&error]) {
        NSLog(@"Error starting server (bind): %@", error);
        return;
    }
    if (![_udpSocket enableBroadcast:YES error:&error]) {
        NSLog(@"Error enableBroadcast (bind): %@", error);
        return;
    }
    if (![_udpSocket joinMulticastGroup:@"224.0.0.1"  error:&error]) {
        NSLog(@"Error joinMulticastGroup (bind): %@", error);
        return;
    }
    if (![_udpSocket beginReceiving:&error]) {
        [_udpSocket close];
        NSLog(@"Error starting server (recv): %@", error);
        return;
    }
    

    
    NSError *error2 = nil;
    if (![_udpSocket connectToHost:HOST onPort:PORT error:&error2]) {
        NSLog(@"Error starting server (bind): %@", error2);
        return;
    }else{
        NSLog(@"连接成功");
    }
    
    
}

- (void)sendUDPTouched
{
    NSString *sengStr = [NSString stringWithFormat:@"%@-发来消息",_ipText.text];
//    [_sendSocket sendData:[sengStr dataUsingEncoding:NSUTF8StringEncoding] toHost:_ipText.text port:recvPort withTimeout:-1 tag:1];
//
    
    
    [_udpSocket sendData:[sengStr dataUsingEncoding:NSUTF8StringEncoding] toHost:HOST port:PORT withTimeout:-1 tag:1];
    NSLog(@"localPort = %hu", [_udpSocket localPort]);
}


-(void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    NSError *error = nil;
    NSLog(@"Message didConnectToAddress: %@",[[NSString alloc]initWithData:address encoding:NSUTF8StringEncoding]);
    [_recvSocket beginReceiving:&error];
    
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
    NSLog(@"Message didSendDataWithTag=%li",tag);
}

-(void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"Message withError: %@",error);
}


@end
