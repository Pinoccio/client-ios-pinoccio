//
//  UARTViewController.m
//  Bluefruit Connect
//
//  Created by Adafruit Industries on 2/5/14.
//  Copyright (c) 2014 Adafruit Industries. All rights reserved.
//

#import "UARTViewController.h"
#import "NSString+hex.h"
#import "NSData+hex.h"

#define kKeyboardAnimationDuration 0.3f

@interface UARTViewController(){
    CBCentralManager    *cm;
    UIAlertView         *currentAlertView;
    UARTPeripheral      *currentPeripheral;
    UARTViewController  *uartViewController;
    NSString    *unkownCharString;
    
}

@end

@implementation UARTViewController


#pragma mark - View Lifecycle


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //initialization
    //define unknown char
    cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    _connectionMode = ConnectionModeNone;
    _connectionStatus = ConnectionStatusDisconnected;
    currentAlertView = nil;
    unkownCharString = [NSString stringWithFormat:@"%C", (unichar)0xFFFD];   //diamond question mark
    //round corners on console
    self.consoleView.clipsToBounds = YES;
    self.consoleView.layer.cornerRadius = 4.0;
    
    [_inputField becomeFirstResponder];
    [self tryToConnect];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)updateConsoleWithIncomingData:(NSData*)newData {
    
    //Write new received data to the console text view
    
    
    NSString *newString = [[NSString alloc]initWithBytes:newData.bytes
                                                  length:newData.length
                                                encoding:NSUTF8StringEncoding];
    
    UIColor *color = [UIColor redColor];
    NSString *appendString = @"\n"; //each message appears on new line
    
    UIFont * consoleFont = [UIFont fontWithName:@"Menlo-Regular" size:15];
    NSAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", newString, appendString] //line breaks in ACII mode
                                                                            attributes: @{NSForegroundColorAttributeName : color,
                                                                                          NSFontAttributeName : consoleFont
                                                                                          }];
    NSMutableAttributedString *newASCIIText = [[NSMutableAttributedString alloc] initWithAttributedString:_consoleAsciiText];
    [newASCIIText appendAttributedString:attrString];
    _consoleAsciiText = newASCIIText;
    
    
    //Update Hex textx
    NSString *newHexString = [newData hexRepresentationWithSpaces:YES];
    attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", newHexString]];
    NSMutableAttributedString *newHexText = [[NSMutableAttributedString alloc] initWithAttributedString:_consoleHexText];
    [newHexText appendAttributedString:attrString];
    _consoleHexText = newHexText;
    
    //write string to console based on mode selection
    switch (_consoleModeControl.selectedSegmentIndex) {
        case 0:
            //ASCII
            self.consoleView.attributedText = _consoleAsciiText;
            NSLog(@"%@",self.consoleView.attributedText);
            break;
        case 1:
            //Hex
            self.consoleView.attributedText = _consoleHexText;
            break;
        default:
            self.consoleView.attributedText = _consoleAsciiText;
            break;
    }
    //scroll output to bottom
    [self.consoleView scrollRangeToVisible:NSMakeRange([self.consoleView.text length], 0)];
    [self.consoleView setScrollEnabled:NO];
    [self.consoleView setScrollEnabled:YES];
    
    
}


- (void)updateConsoleWithOutgoingString:(NSString*)newString{
    
    //Write new sent data to the console text view
    
    UIColor *color = [UIColor blueColor];
    NSString *appendString = @"\n"; //each message appears on new line
    
    
    //Update ASCII text
    UIFont * consoleFont = [UIFont fontWithName:@"Menlo-Regular" size:15];
    NSAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", newString, appendString] //line breaks in ACII mode
                                                                            attributes: @{NSForegroundColorAttributeName : color,
                                                                                          NSFontAttributeName : consoleFont
                                                                                          }];
    NSMutableAttributedString *newASCIIText = [[NSMutableAttributedString alloc] initWithAttributedString:_consoleAsciiText];
    [newASCIIText appendAttributedString:attrString];
    _consoleAsciiText = newASCIIText;
    
    
    //Update Hex text
    NSString *newHexString = [NSString stringToHexSpaceSeparated:newString];
    attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", newHexString]      //no line breaks in Hex mode
                                                        attributes: @{
                                                                      NSForegroundColorAttributeName : color,
                                                                      NSFontAttributeName : consoleFont
                                                                      }];
    NSMutableAttributedString *newHexText = [[NSMutableAttributedString alloc] initWithAttributedString:_consoleHexText];
    [newHexText appendAttributedString:attrString];
    _consoleHexText = newHexText;
    
    //write string to console based on mode selection
    switch (_consoleModeControl.selectedSegmentIndex) {
        case 0:
            //ASCII
            self.consoleView.attributedText = _consoleAsciiText;
            break;
        case 1:
            //Hex
            self.consoleView.attributedText = _consoleHexText;
            break;
        default:
            self.consoleView.attributedText = _consoleAsciiText;
            break;
    }
    //scroll output to bottom
    [self.consoleView scrollRangeToVisible:NSMakeRange([self.consoleView.text length], 0)];
    [self.consoleView setScrollEnabled:NO];
    [self.consoleView setScrollEnabled:YES];
    
}


- (void)resetUI{
    
    //Clear console & update buttons
    [self clearConsole:nil];
    
    //Dismiss keyboard
    
}


- (IBAction)clearConsole:(id)sender{
    
    [self.consoleView setText:@""];
    
    _consoleAsciiText = [[NSAttributedString alloc]init];
    _consoleHexText = [[NSAttributedString alloc]init];
    
}


- (IBAction)copyConsole:(id)sender{
    
    //Copy console text to clipboard w/o formatting
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.consoleView.text;
    
    //Notify user via color animation of text view
    UIColor *iosCyan = [UIColor colorWithRed:(32.0/255.0)
                                       green:(149.0/255.0)
                                        blue:(251.0/255.0)
                                       alpha:1.0];
    [self.consoleView setBackgroundColor:iosCyan];
    
    [UIView animateWithDuration:0.45
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.consoleView.backgroundColor = [UIColor whiteColor];
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
    
}


- (IBAction)sendMessage:(id)sender{
    
    //Respond to keyboard's Done button being tapped …
    
    //Disable send button
    
    //check for empty field
    if ([_inputField.text compare:@""] == NSOrderedSame) {
        return;
    }
    
    //Send inputField's string via UART
    NSString *newString = _inputField.text;
    NSData *data = [NSData dataWithBytes:newString.UTF8String length:newString.length];

    [self sendData:data];
    
    //Clear input field's text
    [_inputField setText:@""];
    
    //Reflect sent message in console
    [self updateConsoleWithOutgoingString:newString];
    
}


- (void)receiveData:(NSData*)newData{
    
    //Receive data from device
    
    [self updateConsoleWithIncomingData:newData];
    
}

#pragma mark - Text Field delegate methods


- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    
    //Keyboard's Done button was tapped
    [self sendMessage:nil];
    return YES;
}


- (IBAction)consoleModeControlDidChange:(UISegmentedControl*)sender{
    
    //Respond to console's ASCII/Hex control value changed
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.consoleView.attributedText = _consoleAsciiText;
            break;
        case 1:
            self.consoleView.attributedText = _consoleHexText;
            break;
        default:
            self.consoleView.attributedText = _consoleAsciiText;
            break;
    }
    
}



#pragma mark CBCentralManagerDelegate


- (void) centralManagerDidUpdateState:(CBCentralManager*)central{
    
    if (central.state == CBCentralManagerStatePoweredOn){
        
        //respond to powered on
    }
    
    else if (central.state == CBCentralManagerStatePoweredOff){
        
        //respond to powered off
    }
    
}


- (void) centralManager:(CBCentralManager*)central didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary*)advertisementData RSSI:(NSNumber*)RSSI{
    
    NSLog(@"Did discover peripheral %@", peripheral.name);
    
    [cm stopScan];
    
    [self connectPeripheral:peripheral];
}


- (void) centralManager:(CBCentralManager*)central didConnectPeripheral:(CBPeripheral*)peripheral{
    
    if ([currentPeripheral.peripheral isEqual:peripheral]){
        
        if(peripheral.services){
            NSLog(@"Did connect to existing peripheral %@", peripheral.name);
            [currentPeripheral peripheral:peripheral didDiscoverServices:nil]; //already discovered services, DO NOT re-discover. Just pass along the peripheral.
        }
        
        else{
            NSLog(@"Did connect peripheral %@", peripheral.name);
            [currentPeripheral didConnect];
        }
    }
    
}


- (void) centralManager:(CBCentralManager*)central didDisconnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error{
    
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    
    //respond to disconnected
    [self peripheralDidDisconnect];
    
    if ([currentPeripheral.peripheral isEqual:peripheral])
    {
        [currentPeripheral didDisconnect];
    }
}
- (void)scanForPeripherals{
    
    //Look for available Bluetooth LE devices
    
    //skip scanning if UART is already connected
    NSArray *connectedPeripherals = [cm retrieveConnectedPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID]];
    if ([connectedPeripherals count] > 0) {
        //connect to first peripheral in array
        [self connectPeripheral:[connectedPeripherals objectAtIndex:0]];
    }
    
    else{
        
        [cm scanForPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID]
                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
    }
    
}


- (void)connectPeripheral:(CBPeripheral*)peripheral{
    
    //Connect Bluetooth LE device
    
    //Clear off any pending connections
    [cm cancelPeripheralConnection:peripheral];
    
    //Connect
    currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    [cm connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
    
}


- (void)disconnect{
    
    //Disconnect Bluetooth LE device
    
    _connectionStatus = ConnectionStatusDisconnected;
    _connectionMode = ConnectionModeNone;
    
    [cm cancelPeripheralConnection:currentPeripheral.peripheral];
    
}
#pragma mark UARTPeripheralDelegate


- (void)didReadHardwareRevisionString:(NSString*)string{
    
    //Once hardware revision string is read, connection to Bluefruit is complete
    
    NSLog(@"HW Revision: %@", string);
    
    //Bail if we aren't in the process of connecting
    if (currentAlertView == nil){
        return;
    }
    
    _connectionStatus = ConnectionStatusConnected;
    
    
    
    //Dismiss Alert view & update main view
    [currentAlertView dismissWithClickedButtonIndex:-1 animated:NO];
    
    currentAlertView = nil;
    
    
}


- (void)uartDidEncounterError:(NSString*)error{
    
    //Dismiss "scanning …" alert view if shown
    if (currentAlertView != nil) {
        [currentAlertView dismissWithClickedButtonIndex:0 animated:NO];
    }
    
    //Display error alert
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                   message:error
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    [alert show];
    
}


- (void)didReceiveData:(NSData*)newData{
    
    //Data incoming from UART peripheral, forward to current view controller
    
    //Debug
    //    NSString *hexString = [newData hexRepresentationWithSpaces:YES];
    //    NSLog(@"Received: %@", newData);
    
    if (_connectionStatus == ConnectionStatusConnected || _connectionStatus == ConnectionStatusScanning) {
        //UART
        if (_connectionMode == ConnectionModeUART) {
            //send data to UART Controller
            [self receiveData:newData];
        }
    }
}


- (void)peripheralDidDisconnect{
    
    //respond to device disconnecting
    
    //if we were in the process of scanning/connecting, dismiss alert
    if (currentAlertView != nil) {
        [self uartDidEncounterError:@"Peripheral disconnected"];
    }
    
    //if status was connected, then disconnect was unexpected by the user, show alert
    
    
    //display disconnect alert
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Disconnected"
                                                   message:@"BLE peripheral has disconnected"
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles: nil];
    
    [alert show];
    
    
    _connectionStatus = ConnectionStatusDisconnected;
    _connectionMode = ConnectionModeNone;
    
    //dereference mode controllers
    
    //make reconnection available after short delay
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (void)alertBluetoothPowerOff{
    
    //Respond to system's bluetooth disabled
    
    NSString *title     = @"Bluetooth Power";
    NSString *message   = @"You must turn on Bluetooth in Settings in order to connect to a device";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


- (void)alertFailedConnection{
    
    //Respond to unsuccessful connection
    
    NSString *title     = @"Unable to connect";
    NSString *message   = @"Please check power & wiring,\nthen reset your Arduino";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}


#pragma mark UartViewControllerDelegate / PinIOViewControllerDelegate


- (void)sendData:(NSData*)newData{
    //Output data to UART peripheral
    
    NSUInteger length = [newData length];
    NSUInteger chunkSize = 20;
    NSUInteger offset = 0;
    do {
        NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
        NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[newData bytes] + offset
                                             length:thisChunkSize
                                       freeWhenDone:NO];
        offset += thisChunkSize;
        NSString *hexString = [chunk hexRepresentationWithSpaces:YES];
        NSLog(@"Sending: %@", hexString);
        [currentPeripheral writeRawData:chunk];
        
        // do something with chunk
    } while (offset < length);
    const char bytes[] = {0x1B};
    NSData *chunk = [NSData dataWithBytesNoCopy:(char *)bytes
                                         length:sizeof(bytes)
                                   freeWhenDone:NO];
    
    [currentPeripheral writeRawData:chunk];

    
}
-(void)tryToConnect {
    //Called by Pin I/O or UART Monitor connect buttons
    
    if (currentAlertView != nil && currentAlertView.isVisible) {
        NSLog(@"ALERT VIEW ALREADY SHOWN");
        return;
    }
    
    NSLog(@"Starting UART Mode …");
    _connectionStatus = ConnectionStatusScanning;
    _connectionMode = ConnectionModeUART;
    
    
    [self scanForPeripherals];
    
    currentAlertView = [[UIAlertView alloc]initWithTitle:@"Scanning …"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:nil];
    
    [currentAlertView show];
}


@end
