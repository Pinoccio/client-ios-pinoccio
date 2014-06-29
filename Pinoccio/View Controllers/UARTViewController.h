//
//  UARTViewController.h
//  Bluefruit Connect
//
//  Created by Adafruit Industries on 2/5/14.
//  Copyright (c) 2014 Adafruit Industries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "UARTPeripheral.h"


@interface UARTViewController : UIViewController <UITextFieldDelegate, UARTPeripheralDelegate, CBCentralManagerDelegate>
typedef enum {
    ConnectionModeNone  = 0,
    ConnectionModePinIO,
    ConnectionModeUART,
} ConnectionMode;

typedef enum {
    ConnectionStatusDisconnected = 0,
    ConnectionStatusScanning,
    ConnectionStatusConnected,
} ConnectionStatus;

@property (nonatomic, assign) ConnectionMode                    connectionMode;
@property (nonatomic, assign) ConnectionStatus                  connectionStatus;

typedef enum {
    LOGGING,
    RX,
    TX,
} ConsoleDataType;

typedef enum {
    ASCII = 0,
    HEX,
} ConsoleMode;

@property (strong, nonatomic) IBOutlet UITextView               *consoleView;
@property (strong, nonatomic) IBOutlet UIView                   *inputView;
@property (strong, nonatomic) IBOutlet UITextField              *inputField;
@property (strong, nonatomic) IBOutlet UIButton                 *sendButton;
@property (strong, nonatomic) IBOutlet UIButton                 *consoleCopyButton;
@property (strong, nonatomic) IBOutlet UIButton                 *consoleClearButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl       *consoleModeControl;
@property (nonatomic, assign) BOOL                              keyboardIsShown;
@property (strong, nonatomic) NSAttributedString                *consoleAsciiText;
@property (strong, nonatomic) NSAttributedString                *consoleHexText;

- (IBAction)clearConsole:(id)sender;
- (IBAction)copyConsole:(id)sender;
- (IBAction)sendMessage:(id)sender;
- (void)receiveData:(NSData*)newData;
- (IBAction)consoleModeControlDidChange:(UISegmentedControl*)sender;
- (void)resetUI;
- (void)sendData:(NSData*)newData;

@end
