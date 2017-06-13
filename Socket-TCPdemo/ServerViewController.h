//
//  ServerViewController.h
//  Socket-TCPdemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/10.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CocoaAsyncSocket;

@interface ServerViewController : UIViewController<GCDAsyncSocketDelegate,UITableViewDataSource,UITableViewDelegate>
{
    GCDAsyncSocket *serverSocket;
    
    UITableView *clientTableView;
    NSMutableArray *socketArray;
}
@end
