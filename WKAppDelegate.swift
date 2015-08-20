//
//  WKAppDelegate.swift
//  WearableKit
//
//  Created by Jieyi Hu on 8/20/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

public protocol WKAppDelegate: UIApplicationDelegate {
    func sharedWKDevice() -> WKDevice
}
