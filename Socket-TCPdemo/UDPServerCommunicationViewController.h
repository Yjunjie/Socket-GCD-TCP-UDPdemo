//
//  UDPServerCommunicationViewController.h
//  Socket-TCPdemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/13.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"
@interface UDPServerCommunicationViewController : UIViewController<GCDAsyncUdpSocketDelegate>
{
    GCDAsyncUdpSocket *_udpSocket;
}

@property (strong, nonatomic)  UITextField *ipText;

@end
