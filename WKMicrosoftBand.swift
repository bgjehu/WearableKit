//
//  WKMicrosoftBand.swift
//  WearableKit
//
//  Created by Jieyi Hu on 8/17/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit


public class WKMicrosoftBand: NSObject, WKDevice, MSBClientManagerDelegate {

    private let _name = "Microsoft Band"
    public var name : String {
        return _name
    }
    
    public var connected : Bool {
        get{
            if bandClient != nil {
                return bandClient.isDeviceConnected
            } else {
                return false
            }
        }
        set{
            if newValue == connected {
                //  no change
            } else {
                if newValue {
                    //  try to connect
                    if bandClient != nil {
                        MSBClientManager.sharedManager().connectClient(bandClient)
                        print("WKMicrosoftBand Log: Try to connected to Microsoft Band...")
                    } else {
                        //  Do nothing
                    }
                } else {
                    //  try to disconnect
                    if bandClient != nil {
                        MSBClientManager.sharedManager().cancelClientConnection(bandClient)
                        print("WKMicrosoftBand Log: Try to disconnected to Microsoft Band...")
                    } else {
                        //  Do nothing
                    }
                }
            }
        }
    }
    
    private var _accelerometerOn = false
    public var accelerometerOn : Bool {
        get{
            return _accelerometerOn
        }
        set{
            if newValue == _accelerometerOn {
                //  no change
            } else {
                if newValue {
                    //  try to turn on accelerometer
                    if handler != nil {
                        do{
                            try bandClient.sensorManager.startAccelerometerUpdatesToQueue(soloQueue, withHandler: { (data, error) -> Void in
                                if let data = data {
                                    //  there is data
                                    let dataf = [data.x,data.y,data.z]
                                    self.handler(dataf)
                                } else {
                                    //  Do nothing
                                }
                            })
                            _accelerometerOn = true
                        } catch let error as NSError {print(error)}
                    } else {
                        print("WKBand Error: Cannot set accelerometerOn = true, handler is not set yet")
                    }
                } else {
                    do{
                        try bandClient.sensorManager.stopAccelerometerUpdatesErrorRef()
                        _accelerometerOn = false
                    } catch let error as NSError {print(error)}
                }
            }
        }
    }
    
    private var _handler : ([Double] -> ())!
    public var handler : ([Double] -> ())! {
        get{
            return _handler
        }
        set{
            _handler = newValue
        }
    }
    
    private let connectedNotificationName = "WEARABLE_KIT_NOTIFICATION_DEVICE_MICROSOFT_BAND_CONNECTED"
    private let disconnectedNotificationName = "WEARABLE_KIT_NOTIFICATION_DEVICE_MICROSOFT_BAND_DISCONNECTED"
    public var connectedNotification : NSNotification {
        get{
            return NSNotification(name: connectedNotificationName, object: nil)
        }
    }
    
    public var disconnectedNotification : NSNotification {
        get{
            return NSNotification(name: disconnectedNotificationName, object: nil)
        }
    }
    
    public func registerConnectedNotification(observer: AnyObject, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: connectedNotificationName, object: nil)
    }
    
    public func deregisterConnectedNotification(observer: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: connectedNotificationName, object: nil)
    }

    public func registerDisconnectedNotification(observer: AnyObject, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: disconnectedNotificationName, object: nil)
    }
    
    public func deregisterDisconnectedNotification(observer: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: disconnectedNotificationName, object: nil)
    }

    
    public static var sharedWKDevice : WKDevice {
        get{
            return (UIApplication.sharedApplication().delegate as! WKAppDelegate).sharedWKDevice()
        }
    }
    
    public override init() {
        super.init()
        let clients = MSBClientManager.sharedManager().attachedClients()
        if clients.count > 0 {
            bandClient = clients[0] as? MSBClient
            MSBClientManager.sharedManager().delegate = self
        } else {
            print("WKBand Error: Cannot create WKBand instance with no MSBand attached")
        }
    }
    
    private var bandClient : MSBClient!
    private var soloQueue : NSOperationQueue {
        get{
            let soloQueue = NSOperationQueue()
            soloQueue.maxConcurrentOperationCount = 1
            return soloQueue
        }
    }

    
    public func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
        print(error)
    }
    public func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
        NSNotificationCenter.defaultCenter().postNotification(connectedNotification)
        print("WKMicrosoftBand Log: Microsoft Band is connected")
    }
    public func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
        NSNotificationCenter.defaultCenter().postNotification(disconnectedNotification)
        print("WKMicrosoftBand Log: Microsoft Band is disconnected")
    }
}
