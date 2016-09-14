//
//  ViewController.swift
//  adafruitBLEMinimized
//
//  Created by Alejandro Castillejo on 9/13/16.
//  Copyright © 2016 Alejandro Castillejo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Data
    private var peripheralList = PeripheralList()
    private let uartData = UartModuleManager()

  
    @IBOutlet var statusBLELabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Start scanning
        BleManager.sharedInstance.startScan()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        
        // Subscribe to Ble Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didDiscoverPeripheral(_:)), name: BleManager.BleNotifications.DidDiscoverPeripheral.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didDiscoverPeripheral(_:)), name: BleManager.BleNotifications.DidUnDiscoverPeripheral.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didDisconnectFromPeripheral(_:)), name: BleManager.BleNotifications.DidDisconnectFromPeripheral.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didConnectToPeripheral(_:)), name: BleManager.BleNotifications.DidConnectToPeripheral.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(willConnectToPeripheral(_:)), name: BleManager.BleNotifications.WillConnectToPeripheral.rawValue, object: nil)
        
//        let isFullScreen = UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact
//        if isFullScreen {
//            peripheralList.connectToPeripheral(nil)
//        }
//        
//        // Check that the peripheral is still connected
//        if BleManager.sharedInstance.blePeripheralConnected == nil {
//            peripheralList.disconnected()
//        }
//        
//        // Reload
//        reloadData()
        
    }
    
    func didDiscoverPeripheral(notification : NSNotification) {
        
//        if let list:PeripheralList = peripheralList {
//            list.connectToPeripheral("4B7754C0-5F9B-8CE3-EF73-322C585373DE")
//        }
        
        print(peripheralList.blePeripherals)
        
        //Connecting, not connected
        if(BleManager.sharedInstance.blePeripheralConnecting == nil){
            if(peripheralList.blePeripherals.contains("4B7754C0-5F9B-8CE3-EF73-322C585373DE")){
                peripheralList.connectToPeripheral("4B7754C0-5F9B-8CE3-EF73-322C585373DE")
            }
        }
        
        
        
        
//        dispatch_async(dispatch_get_main_queue(), {[weak self] in
        
            
            
  
    
//    Reload data
//                if  BleManager.sharedInstance.blePeripheralsCount() != self?.cachedNumOfTableItems  {
//                    self?.tableView.reloadData()
//                }
//    
//                // Select identifier if still available
//                if let selectedPeripheralRow = self?.peripheralList.selectedPeripheralRow {
//                    self?.tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedPeripheralRow, inSection: 0), animated: false, scrollPosition: .None)
//                }
//            })
        
    }
    
    func didDisconnectFromPeripheral(notification : NSNotification) {
        
        self.statusBLELabel.text = "Not connected"

//        dispatch_async(dispatch_get_main_queue(), {[unowned self] in
//            DLog("list: disconnection detected a")
//            self.peripheralList.disconnected()
//            if BleManager.sharedInstance.blePeripheralConnected == nil, let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow {
//                DLog("list: disconnection detected b")
//
//                // Unexpected disconnect if the row is still selected but the connected peripheral is nil and the time since the user selected a new peripheral is bigger than kMinTimeSinceUserSelection second
//                // let kMinTimeSinceUserSelection = 1.0    // in secs
//                // if self.peripheralList.elapsedTimeSinceSelection > kMinTimeSinceUserSelection {
//                self.tableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
//
//                DLog("list: disconnection detected c")
//
//                let isFullScreen = UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact
//                if isFullScreen {
//
//                    DLog("list: compact mode show alert")
//                    if self.presentedViewController != nil {
//                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
//                            self.showPeripheralDisconnectedDialog()
//                        })
//                    }
//                    else {
//                        self.showPeripheralDisconnectedDialog()
//                    }
//                    //   }
//                }
//                else {
//                    self.reloadData()
//                }
//            }
//            })
    }
    
    func didConnectToPeripheral(notification : NSNotification) {
        
        self.statusBLELabel.text = "Connected"
        
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
        
        
//
//        // Connection is managed here if the device is in compact mode
//        let isFullScreen = UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact
//        if isFullScreen {
//            DLog("list: connection on compact mode detected")
//            
//            let kTimeToWaitForPeripheralConnectionError : Double = 0.5
//            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(kTimeToWaitForPeripheralConnectionError * Double(NSEC_PER_SEC)))
//            dispatch_after(time, dispatch_get_main_queue()) { [unowned self] in
//                
//                if BleManager.sharedInstance.blePeripheralConnected != nil {
//                    
////                    // Deselect current row
////                    if let indexPathForSelectedRow = self.baseTableView.indexPathForSelectedRow {
////                        self.baseTableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
////                    }
//                    
//                    // Dismiss current dialog
//                    if self.presentedViewController != nil {
//                        self.dismissViewControllerAnimated(true, completion: { [unowned self] () -> Void in
//                            self.performSegueWithIdentifier("showDetailSegue", sender: self)
//                            })
//                    }
//                    else {
//                        self.performSegueWithIdentifier("showDetailSegue", sender: self)
//                    }
//                }
//                else {
//                    DLog("cancel push detail because peripheral was disconnected")
//                }
//            }
//        }
    }
    

    
    
    func willConnectToPeripheral(notification : NSNotification) {
//        let isFullScreen = UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Compact
//        if isFullScreen {
//            dispatch_async(dispatch_get_main_queue(), {[unowned self] in
//                let localizationManager = LocalizationManager.sharedInstance
//                let alertController = UIAlertController(title: nil, message: localizationManager.localizedString("peripheraldetails_connecting"), preferredStyle: .Alert)
//                
//                alertController.addAction(UIAlertAction(title: localizationManager.localizedString("dialog_cancel"), style: .Cancel, handler: { (_) -> Void in
//                    if let peripheral = BleManager.sharedInstance.blePeripheralConnecting {
//                        BleManager.sharedInstance.disconnect(peripheral)
//                    }
//                    else if let peripheral = BleManager.sharedInstance.blePeripheralConnected {
//                        BleManager.sharedInstance.disconnect(peripheral)
//                    }
//                }))
//                self.presentViewController(alertController, animated: true, completion:nil)
//                })
//        }
    }

    @IBAction func send(sender: AnyObject) {
        
        uartData.sendMessageToUart("hello")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK: - CBPeripheralDelegate
extension ViewController: CBPeripheralDelegate {
    // Pass peripheral callbacks to UartData
    
    func peripheral(peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        uartData.peripheral(peripheral, didModifyServices: invalidatedServices)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        uartData.peripheral(peripheral, didDiscoverServices:error)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        uartData.peripheral(peripheral, didDiscoverCharacteristicsForService: service, error: error)
        
//        // Check if ready
//        if uartData.isReady() {
//            // Enable input
//            dispatch_async(dispatch_get_main_queue(), { [unowned self] in
//                if self.inputTextField != nil {     // could be nil if the viewdidload has not been executed yet
//                    self.inputTextField.enabled = true
//                    self.inputTextField.backgroundColor = UIColor.whiteColor()
//                }
//                });
//        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        uartData.peripheral(peripheral, didUpdateValueForCharacteristic: characteristic, error: error)
    }
}

//// MARK: - UITableViewDataSource
//extension ViewController : UITableViewDataSource {
//    private static var dataFont = UIFont(name: "CourierNewPSMT", size: 14)! //Font.systemFontOfSize(Font.systemFontSize())
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (Preferences.uartIsEchoEnabled)  {
//            tableCachedDataBuffer = uartData.dataBuffer
//        }
//        else {
//            tableCachedDataBuffer = uartData.dataBuffer.filter({ (dataChunk : UartDataChunk) -> Bool in
//                dataChunk.mode == .RX
//            })
//        }
//        
//        return tableCachedDataBuffer!.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let reuseIdentifier = "TimestampCell"
//        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath:indexPath)
//        
//        // Data binding in cellForRowAtIndexPath to avoid problems with multiple-line labels and dyanmic tableview height calculation
//        let dataChunk = tableCachedDataBuffer![indexPath.row]
//        let date = NSDate(timeIntervalSinceReferenceDate: dataChunk.timestamp)
//        let dateString = timestampDateFormatter.stringFromDate(date)
//        let modeString = LocalizationManager.sharedInstance.localizedString(dataChunk.mode == .RX ? "uart_timestamp_direction_rx" : "uart_timestamp_direction_tx")
//        let color = dataChunk.mode == .TX ? txColor : rxColor
//        
//        let timestampCell = cell as! UartTimetampTableViewCell
//        
//        timestampCell.timeStampLabel.text = String(format: "%@ %@", arguments: [dateString, modeString])
//        
//        
//        if let attributedText = UartModuleManager.attributeTextFromData(dataChunk.data, useHexMode: Preferences.uartIsInHexMode, color: color, font: UartModuleViewController.dataFont) where attributedText.length > 0 {
//            timestampCell.dataLabel.attributedText = attributedText
//        }
//        else {
//            timestampCell.dataLabel.attributedText = NSAttributedString(string: " ")        // space to maintain height
//        }
//        
//        print(timestampCell.timeStampLabel.text)
//        
//        timestampCell.contentView.backgroundColor = indexPath.row%2 == 0 ? UIColor.whiteColor() : UIColor(hex: 0xeeeeee)
//        return cell
//    }
//}



// MARK: - UartModuleDelegate
extension ViewController: UartModuleDelegate {
    
    func addChunkToUI(dataChunk : UartDataChunk) {
//        // Check that the view has been initialized before updating UI
//        guard isViewLoaded() && view.window != nil &&  baseTableView != nil else {
//            return
//        }
//        
//        let displayMode = Preferences.uartIsDisplayModeTimestamp ? UartModuleManager.DisplayMode.Table : UartModuleManager.DisplayMode.Text
//        
//        switch(displayMode) {
//        case .Text:
//            addChunkToUIText(dataChunk)
//            self.enh_throttledReloadData()      // it will call self.reloadData without overloading the main thread with calls
//            
//        case .Table:
//            self.enh_throttledReloadData()      // it will call self.reloadData without overloading the main thread with calls
//            
//        }
//        
//        updateBytesUI()
    }
    
    func reloadData() {
//        let displayMode = Preferences.uartIsDisplayModeTimestamp ? UartModuleManager.DisplayMode.Table : UartModuleManager.DisplayMode.Text
//        switch(displayMode) {
//        case .Text:
//            baseTextView.attributedText = textCachedBuffer
//            
//            let textLength = textCachedBuffer.length
//            if textLength > 0 {
//                let range = NSMakeRange(textLength - 1, 1);
//                baseTextView.scrollRangeToVisible(range);
//            }
//            
//        case .Table:
//            baseTableView.reloadData()
//            if let tableCachedDataBuffer = tableCachedDataBuffer {
//                if tableCachedDataBuffer.count > 0 {
//                    let lastIndex = NSIndexPath(forRow: tableCachedDataBuffer.count-1, inSection: 0)
//                    baseTableView.scrollToRowAtIndexPath(lastIndex, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
//                }
//            }
//        }
    }
    
    private func addChunkToUIText(dataChunk : UartDataChunk) {
//        
//        if (Preferences.uartIsEchoEnabled || dataChunk.mode == .RX) {
//            let color = dataChunk.mode == .TX ? txColor : rxColor
//            
//            if let attributedString = UartModuleManager.attributeTextFromData(dataChunk.data, useHexMode: Preferences.uartIsInHexMode, color: color, font: UartModuleViewController.dataFont) {
//                textCachedBuffer.appendAttributedString(attributedString)
//            }
//        }
    }
    
    func mqttUpdateStatusUI() {
//        if let imageView = mqttBarButtonItemImageView {
//            let status = MqttManager.sharedInstance.status
//            let tintColor = self.view.tintColor
//            
//            switch (status) {
//            case .Connecting:
//                let imageFrames = [
//                    UIImage(named:"mqtt_connecting1")!.tintWithColor(tintColor),
//                    UIImage(named:"mqtt_connecting2")!.tintWithColor(tintColor),
//                    UIImage(named:"mqtt_connecting3")!.tintWithColor(tintColor)
//                ]
//                imageView.animationImages = imageFrames
//                imageView.animationDuration = 0.5 * Double(imageFrames.count)
//                imageView.animationRepeatCount = 0;
//                imageView.startAnimating()
//                
//            case .Connected:
//                imageView.stopAnimating()
//                imageView.image = UIImage(named:"mqtt_connected")!.tintWithColor(tintColor)
//                
//            default:
//                imageView.stopAnimating()
//                imageView.image = UIImage(named:"mqtt_disconnected")!.tintWithColor(tintColor)
//            }
//        }
    }
    
    func mqttError(message: String, isConnectionError: Bool) {
//        let localizationManager = LocalizationManager.sharedInstance
//        
//        let alertMessage = isConnectionError ? localizationManager.localizedString("uart_mqtt_connectionerror_title"): message
//        let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .Alert)
//        
//        let okAction = UIAlertAction(title: localizationManager.localizedString("dialog_ok"), style: .Default, handler:nil)
//        alertController.addAction(okAction)
//        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

