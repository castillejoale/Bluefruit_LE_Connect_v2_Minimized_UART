# Bluefruit LE Connect v2 MINIMIZED!

Hola everyone!

This is a super simplified version of the Bluefruit LE Connect v2 iOS app from Adafruit. https://github.com/adafruit/Bluefruit_LE_Connect_v2

## Make it work

To connect to your BLE module from your iOS device you only need to:

**1.** Find the UUID of your desired BLE module just by running this app on your iPhone or iPad (with bluetooth on), the UUIDs will appear printed on the console. **Important:** Open this project in Xcode by using the .xcworkspace file and not the .xcodeproj file.

**2.** Set the desired UUID (yourUUID variable) on the viewDidLoad method of the ViewController.swift file.

## Questions

Any questions I will try my best to respond in less than 24 hours. I don't care how stupid you think your questions could be, I want to help you make this work.

- Current version: Xcode 7.3.1, Swift 2.2