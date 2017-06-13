//
//  UDPServerViewController.h
//  Socket-TCPdemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/13.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CocoaAsyncSocket;

@interface UDPServerViewController : UIViewController<GCDAsyncUdpSocketDelegate>
{
    GCDAsyncUdpSocket *serverSocket;
}
@end
