
//
//  ServerViewController.m
//  Socket-TCPdemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/10.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import "ServerViewController.h"
#import "ClientViewController.h"

@interface ServerViewController ()

@end

@implementation ServerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    clientTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,100+64,Screen_Width,Screen_Height-164) style:UITableViewStylePlain];
    clientTableView.delegate=self;
    clientTableView.dataSource=self;
    [self.view addSubview:clientTableView];
    
    
    socketArray =[[NSMutableArray alloc] initWithCapacity:0];
    // 服务器socket实例化  在0x1234端口监听数据
    serverSocket=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [serverSocket acceptOnPort:PORT error:nil];

}

// 有新的socket向服务器链接自动回调
-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    [socketArray addObject:newSocket];
    
    [clientTableView reloadData];
    
    // 如果下面的方法不写 只能接收一次socket链接
    [newSocket readDataWithTimeout:-1 tag:100];
}

// 网络连接成功后  自动回调
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"已连接到用户:ip:%@",host);
}

// 接收到了数据 自动回调  sock客户端
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *message=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"收到%@发来的消息:%@",[sock connectedHost],message);
    
    // 相当与向服务起索取  在线用户数据
    // 将连上服务器的所有ip地址 组成一个字符串 将字符串回写到客户端
    if ([message isEqualToString:@"GetClientList"]) {
        NSMutableString *clientList=[[NSMutableString alloc] initWithCapacity:0];
        int i=0;
        // 每一个客户端连接服务器成功后 socketArray保存客户端的套接字
        // [newSocket connectedHost] 获取套接字对应的IP地址
        for (GCDAsyncSocket *newSocket in socketArray) {
            // 以字符串形式分割ip地址  192..,192...,
            if (i!=0) {
                [clientList appendFormat:@",%@",[newSocket connectedHost]];
            }
            else{
                [clientList appendFormat:@"%@",[newSocket connectedHost]];
            }
            i++;
        }
        // 将服务端所有的ip连接成一个字符串对象
        NSData *newData=[clientList dataUsingEncoding:NSUTF8StringEncoding];
        // 将在线的所有用户  以字符串的形式一次性发给客户端
        // 哪个客户端发起数据请求sock就表示谁
        [sock writeData:newData withTimeout:-1 tag:300];
    }
    else{
        // 将数据回写给发送数据的用户
        NSLog(@"debug >>>> %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        [sock writeData:data withTimeout:-1 tag:300];
    }
    
    // 继续读取socket数据
    [sock readDataWithTimeout:-1 tag:200];
    
}

/*重连
 
 实现代理方法
 
 -(void)onSocketDidDisconnect:(GCDAsyncSocket *)sock
 {
 NSLog(@"sorry the connect is failure %ld",sock.userData);
 if (sock.userData == SocketOfflineByServer) {
 // 服务器掉线，重连
 [self socketConnectHost];
 }
 else if (sock.userData == SocketOfflineByUser) {
 // 如果由用户断开，不进行重连
 return;
 }
 
 }*/
// 连接断开时  服务器自动回调
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock
{
    [socketArray removeObject:sock];
    
    [clientTableView reloadData];
    
}

// 向用户发出的消息  自动回调
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"向用户%@发出消息",[sock connectedHost]);
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [socketArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"CellName";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    GCDAsyncSocket *socket=[socketArray objectAtIndex:indexPath.row];
    // 根据连接服务端套接字socket对象 获取对应的客户端IP地址
    cell.textLabel.text=[NSString stringWithFormat:@"用户:%@",[socket connectedHost]];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
