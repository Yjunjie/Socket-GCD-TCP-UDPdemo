
//
//  ClientViewController.m
//  Socket-TCPdemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/10.
//  Copyright © 2017年 doublej. All rights reserved.
//
#import "ClientViewController.h"

@interface ClientViewController ()

@end

@implementation ClientViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // A(监听收对方发来的数据)  server（连接服务器）  B（对方）
    
    // 服务器socket
    serverSocket =[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //    serverSocket.delegate=self;
    // 本身
    listenSocket=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [listenSocket acceptOnPort:selfPort error:nil];
    // 点对点通讯时 对方的socket
    clientSocket=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSArray *nameArray=[NSArray arrayWithObjects:@"连接",@"断开",@"在线用户", nil];
    for (int i=0;i<[nameArray count];i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:[nameArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(10+100*i, 30+64, 100, 30)];
        button.tag=100+i;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius  = 3;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    clientTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 100+64, 320,380) style:UITableViewStylePlain];
    clientTableView.delegate=self;
    clientTableView.dataSource=self;
    [self.view addSubview:clientTableView];
    
    clientArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    messageTextField=[[UITextField alloc] initWithFrame:CGRectMake(10, 70+64, 300, 30)];
    messageTextField.delegate=self;
    messageTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:messageTextField];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// 发数据  结束编辑  就是键盘隐藏的时候  自动调用
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (clientSocket && [clientSocket isConnected]) {
        NSData *data=[textField.text dataUsingEncoding:NSUTF8StringEncoding];
        // 向socket写数据
        [clientSocket writeData:data withTimeout:-1 tag:100];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [clientArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"CellName";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.textLabel.text=[clientArray objectAtIndex:indexPath.row];
    
    return cell;
}

// 点击一行时   向该行对应的ip地址发起连接
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ipCopy = [clientArray objectAtIndex:indexPath.row];
    if (clientSocket ) {
        // 如果之前连接上了一个好友 那么先断开
        if ([clientSocket isConnected]) {
            [clientSocket disconnect];
        }
        // 向TableViewCell上指定ip发起TCP连接
        NSLog(@"ipCopy==%@",ipCopy);
        [clientSocket connectToHost:ipCopy onPort:selfPort error:nil];
        // clientSocket已经指向了好友 如果需要和好友发消息
        [clientSocket writeData:[@"sendTCPTouched" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:100];
        // clientSocket已经指向了好友 如果需要和好友发消息
    }
    
}

-(void)buttonClicked:(UIButton*)button
{
    if (button.tag==100)
    {
        // 连接服务器
        if (![serverSocket isConnected])
        {
            //[serverSocket disconnect];
            // 指定 ip 指定端口 发起一个TCP连接
            [serverSocket connectToHost:HOST onPort:PORT error:nil];
            // 向服务器写数据
            
        }else{
            NSLog(@"已经和服务器连接");
        }
    }
    // 断开与服务器连接
    else if(button.tag==101)
    {
        // 断开TCP连接
        [serverSocket disconnect];
    }
    // 获取在线用户
    else if(button.tag==102)
    {
        NSString *message=@"GetClientList";
        NSData *data=[message dataUsingEncoding:NSUTF8StringEncoding];
        // 向服务器获取在线用户信息
        // 向服务端写字符串 GetClientList
        [serverSocket writeData:data withTimeout:-1 tag:400];
        
    }else if(button.tag==103){
        
    }
}

// 接收到了一个新的socket连接 自动回调
// 接收到了新的连接  那么释放老的连接
-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    if (sock==listenSocket) {
        NSLog(@"收到用户%@的连接请求",[newSocket connectedHost]);
        if (clientSocket && [clientSocket isConnected]) {
            [clientSocket disconnect];
        }
        // 保存发起连接的客户端socket
        clientSocket = newSocket;
    }
    [newSocket readDataWithTimeout:-1 tag:250];
}

- (void)socket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"willDisconnectWithError");
    //[self logInfo:FORMAT(@"Client Disconnected: %@:%hu", [sock connectedHost], [sock connectedPort])];
    if (err) {
        NSLog(@"错误报告：%@",err);
    }else{
        NSLog(@"连接工作正常");
    }
    serverSocket = nil;
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 如果时服务器给的消息  必然是在线用户的消息
    if (sock==serverSocket) {
        NSString *message=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        // 将字符串以","分割 到数组中
        // 分割出IP地址
        NSArray *array=[message componentsSeparatedByString:@","];
        
        [clientArray removeAllObjects];
        [clientArray addObjectsFromArray:array];
        
        [clientTableView reloadData];
        
        NSLog(@"在线用户列表:%@",clientArray);
    }
    // 点对点通讯
    else if(sock==clientSocket){
        NSString *message=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"收到客户%@的消息:%@",[clientSocket connectedHost],message);
    }
    
    [sock readDataWithTimeout:-1 tag:300]; //一直监听网络
    
}
// 成功连接后自动回调
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    //    [sock readDataWithTimeout:-1 tag:200];
    // 获取用户列表
    if (sock==serverSocket) {
        NSLog(@"已经连接到服务器:%@",host);
    }
    // 客户端与客户端通讯
    else{
        NSLog(@"已经连接到客户端:%@",host);
    }
    
    [sock readDataWithTimeout:-1 tag:400];
}

// 写数据成功 自动回调
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    // 获取用户列表
    if (sock==serverSocket) {
        NSLog(@"向服务器%@发送消息成功",[sock connectedHost]);
    }
    // 客户端与客户端通讯
    else{
        NSLog(@"向客户%@发送消息成功",[sock connectedHost]);
    }
    // 继续监听
    [sock readDataWithTimeout:-1 tag:500];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
