//
//  ClientViewController.h
//  Socket-TCPdemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/10.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CocoaAsyncSocket;

@interface ClientViewController : UIViewController<GCDAsyncSocketDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    GCDAsyncSocket *serverSocket;
    GCDAsyncSocket *listenSocket;
    GCDAsyncSocket *clientSocket;
    
    UITableView *clientTableView;
    NSMutableArray *clientArray;
    UITextField* messageTextField;
    NSString *ipCopy;
}
@end
