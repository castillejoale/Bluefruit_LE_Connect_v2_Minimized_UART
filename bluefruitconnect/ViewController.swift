//
//  ViewController.swift
//  adafruitBLEMinimized
//
//  Created by Alejandro Castillejo on 9/13/16.
//  Copyright © 2016 Alejandro Castillejo. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    //Your BLE UUID
//    private let yourUUID = "4B7754C0-5F9B-8CE3-EF73-322C585373DE"
    private let yourUUID = "BD55E1A5-9E0B-F7B8-A113-6EA26EDBF2B1"

    //UI
    @IBOutlet var statusBLELabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var connectDisconnectButton: UIButton!
    
    // Data
    private var peripheralList = PeripheralList()
    private let uartData = UartModuleManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Start scanning
        BleManager.sharedInstance.startScan()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Subscribe to Ble Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didDiscoverPeripheral(_:)), name: BleManager.BleNotifications.DidDiscoverPeripheral.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didDiscoverPeripheral(_:)), name: BleManager.BleNotifications.DidUnDiscoverPeripheral.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didDisconnectFromPeripheral(_:)), name: BleManager.BleNotifications.DidDisconnectFromPeripheral.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didConnectToPeripheral(_:)), name: BleManager.BleNotifications.DidConnectToPeripheral.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(willConnectToPeripheral(_:)), name: BleManager.BleNotifications.WillConnectToPeripheral.rawValue, object: nil)
        
        let isFullScreen = UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact
        if isFullScreen {
            peripheralList.connectToPeripheral(nil)
        }

        // Check that the peripheral is still connected
        if BleManager.sharedInstance.blePeripheralConnected == nil {
            peripheralList.disconnected()
        }
        
    }
    
    @IBAction func connectDisconnectTapped(sender: AnyObject)
    {
        if(sender as! UIButton == self.connectDisconnectButton){
            if (sender.selected == true) {
                //Disconnect
                if let peripheral = BleManager.sharedInstance.blePeripheralConnected {
                    BleManager.sharedInstance.disconnect(peripheral)
                }
//                let mqttManager = MqttManager.sharedInstance
//                mqttManager.disconnect()
            } else if (sender.selected == false) {
                // Start scanning
                BleManager.sharedInstance.startScan()
            }
        }
    }
    
    @IBAction func send(sender: AnyObject)
    {
        uartData.sendMessageToUart(self.messageTextField.text!)
        
    }
    
    func didDiscoverPeripheral(notification : NSNotification)
    {
        //Connecting, not connected
        if(BleManager.sharedInstance.blePeripheralConnecting == nil){
//            print(peripheralList)
            if(peripheralList.blePeripherals.contains(yourUUID)){
                peripheralList.connectToPeripheral(yourUUID)
            }
        }
    }
    
    func willConnectToPeripheral(notification : NSNotification)
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.statusBLELabel.text = "Connecting"
        })
        
        let isFullScreen = UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact
        if isFullScreen {
            dispatch_async(dispatch_get_main_queue(), {[unowned self] in
                let localizationManager = LocalizationManager.sharedInstance
                let alertController = UIAlertController(title: nil, message: localizationManager.localizedString("peripheraldetails_connecting"), preferredStyle: .Alert)
                
                alertController.addAction(UIAlertAction(title: localizationManager.localizedString("dialog_cancel"), style: .Cancel, handler: { (_) -> Void in
                    if let peripheral = BleManager.sharedInstance.blePeripheralConnecting {
                        BleManager.sharedInstance.disconnect(peripheral)
                    }
                    else if let peripheral = BleManager.sharedInstance.blePeripheralConnected {
                        BleManager.sharedInstance.disconnect(peripheral)
                    }
                }))
                self.presentViewController(alertController, animated: true, completion:nil)
            })
        }
    }
    
    func didConnectToPeripheral(notification : NSNotification)
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.statusBLELabel.text = "Connected"
            self.connectDisconnectButton.selected = true
        })
        
        //1
        let blePeripheral = BleManager.sharedInstance.blePeripheralConnected!
        blePeripheral.peripheral.delegate = self
        //        startUpdatesCheck()
        
        //2
        // Peripheral should be connected
        uartData.delegate = self
        uartData.blePeripheral = BleManager.sharedInstance.blePeripheralConnected       // Note: this will start the service discovery
        guard uartData.blePeripheral != nil else {
            DLog("Error: Uart: blePeripheral is nil")
            return
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didDisconnectFromPeripheral(notification : NSNotification)
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.statusBLELabel.text = "Not connected"
            self.connectDisconnectButton.selected = false
        })

        dispatch_async(dispatch_get_main_queue(), {[unowned self] in
            DLog("list: disconnection detected a")
            self.peripheralList.disconnected()
        })
    }

}

// MARK: - CBPeripheralDelegate
extension ViewController: CBPeripheralDelegate
{
    // Pass peripheral callbacks to UartData
    
    func peripheral(peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService])
    {
        uartData.peripheral(peripheral, didModifyServices: invalidatedServices)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?)
    {
        uartData.peripheral(peripheral, didDiscoverServices:error)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?)
    {
        uartData.peripheral(peripheral, didDiscoverCharacteristicsForService: service, error: error)
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?)
    {
        uartData.peripheral(peripheral, didUpdateValueForCharacteristic: characteristic, error: error)
    }
}


// MARK: - UartModuleDelegate
extension ViewController: UartModuleDelegate {
    
    func addChunkToUI(dataChunk : UartDataChunk)
    {
        //If the message is received (RX) and not (sent) TX
        if(dataChunk.mode == UartDataChunk.TransferMode.RX){
            if let receivedMessage = NSString(data: dataChunk.data, encoding: NSUTF8StringEncoding) {
                self.lastMessageLabel.text = receivedMessage as String;
            }
        }
    }

    func mqttUpdateStatusUI()
    {
        //Needed for the protocol, I decided not to use this method. I didn't get rid of it because I didn't want to make any changes to the original code
    }
    
    func mqttError(message: String, isConnectionError: Bool)
    {
        let localizationManager = LocalizationManager.sharedInstance
        
        let alertMessage = isConnectionError ? localizationManager.localizedString("uart_mqtt_connectionerror_title"): message
        let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: localizationManager.localizedString("dialog_ok"), style: .Default, handler:nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
