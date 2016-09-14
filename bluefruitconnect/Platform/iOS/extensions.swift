////
////  extensions.swift
////  Bluefruit Connect
////
////  Created by Alejandro Castillejo on 9/13/16.
////  Copyright © 2016 Adafruit. All rights reserved.
////
//
//import Foundation
//
//// MARK: - UartModuleDelegate
//extension UartModuleViewController: UartModuleDelegate {
//    
//    func addChunkToUI(dataChunk : UartDataChunk) {
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
//    }
//    
//    func reloadData() {
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
//    }
//    
//    private func addChunkToUIText(dataChunk : UartDataChunk) {
//        
//        if (Preferences.uartIsEchoEnabled || dataChunk.mode == .RX) {
//            let color = dataChunk.mode == .TX ? txColor : rxColor
//            
//            if let attributedString = UartModuleManager.attributeTextFromData(dataChunk.data, useHexMode: Preferences.uartIsInHexMode, color: color, font: UartModuleViewController.dataFont) {
//                textCachedBuffer.appendAttributedString(attributedString)
//            }
//        }
//    }
//    
//    func mqttUpdateStatusUI() {
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
//    }
//    
//    func mqttError(message: String, isConnectionError: Bool) {
//        let localizationManager = LocalizationManager.sharedInstance
//        
//        let alertMessage = isConnectionError ? localizationManager.localizedString("uart_mqtt_connectionerror_title"): message
//        let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .Alert)
//        
//        let okAction = UIAlertAction(title: localizationManager.localizedString("dialog_ok"), style: .Default, handler:nil)
//        alertController.addAction(okAction)
//        self.presentViewController(alertController, animated: true, completion: nil)
//    }
//}
//
//// MARK: - CBPeripheralDelegate
//extension UartModuleViewController: CBPeripheralDelegate {
//    // Pass peripheral callbacks to UartData
//    
//    func peripheral(peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
//        uartData.peripheral(peripheral, didModifyServices: invalidatedServices)
//    }
//    
//    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
//        uartData.peripheral(peripheral, didDiscoverServices:error)
//    }
//    
//    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
//        
//        uartData.peripheral(peripheral, didDiscoverCharacteristicsForService: service, error: error)
//        
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
//    }
//    
//    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
//        uartData.peripheral(peripheral, didUpdateValueForCharacteristic: characteristic, error: error)
//    }
//}
//
//// MARK: - KeyboardPositionNotifierDelegate
//extension UartModuleViewController: KeyboardPositionNotifierDelegate {
//    
//    func onKeyboardPositionChanged(keyboardFrame : CGRect, keyboardShown : Bool) {
//        var spacerHeight = keyboardFrame.height
//        /*
//         if let tabBarHeight = self.tabBarController?.tabBar.bounds.size.height {
//         spacerHeight -= tabBarHeight
//         }
//         */
//        spacerHeight -= StyleConfig.tabbarHeight;     // tabbarheight
//        keyboardSpacerHeightConstraint.constant = max(spacerHeight, 0)
//        
//    }
//}
//
//// MARK: - UIPopoverPresentationControllerDelegate
//extension UartModuleViewController : UIPopoverPresentationControllerDelegate {
//    
//    func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
//        // This *forces* a popover to be displayed on the iPhone
//        return .None
//    }
//    
//    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
//        
//        // MQTT
//        let mqttManager = MqttManager.sharedInstance
//        if (MqttSettings.sharedInstance.isConnected) {
//            mqttManager.delegate = uartData
//        }
//        mqttUpdateStatusUI()
//    }
//}
