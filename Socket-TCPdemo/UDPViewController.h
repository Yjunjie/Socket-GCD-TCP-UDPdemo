//
//  UDPViewController.h
//  Socket-TCPdemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/13.
//  Copyright © 2017年 doublej. All rights reserved.
//


#import <UIKit/UIKit.h>
@import CocoaAsyncSocket;
@interface UDPViewController : UIViewController<UITextFieldDelegate,GCDAsyncUdpSocketDelegate>
{
    GCDAsyncUdpSocket *_udpSocket;
    GCDAsyncUdpSocket *_sendSocket;
    GCDAsyncUdpSocket *_recvSocket;
    
    
}
@property (strong, nonatomic)  UITextField *ipText;
@end
