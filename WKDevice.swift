//
//  WKDevice.swift
//  WearableKit
//
//  Created by Jieyi Hu on 8/15/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

public protocol WKDevice : NSObjectProtocol {
    var name : String {get}
    var connected : Bool {get set}
    var accelerometerOn : Bool {get set}
    var handler : ([Double] -> ())! {get set}
    var connectedNotification : NSNotification {get}
    var disconnectedNotification : NSNotification {get}
    func registerConnectedNotification(observer:AnyObject, selector: Selector)
    func deregisterConnectedNotification(observer:AnyObject)
    func registerDisconnectedNotification(observer:AnyObject, selector: Selector)
    func deregisterDisconnectedNotification(observer:AnyObject)
    static var sharedWKDevice : WKDevice {get}
}
