//
//  DeviceInfo.swift
//  VukkleExample
//
//  Created by Narek Dallakyan on 8/2/21.
//  Copyright © 2021 MAC_7. All rights reserved.
//

import UIKit

open class DeviceInfo {
    // List of device names that don't support advanced visual settings
    static let lowGraphicsQualityModels = ["iPad", "iPad1,1", "iPhone1,1", "iPhone1,2", "iPhone2,1", "iPhone3,1", "iPhone3,2", "iPhone3,3", "iPod1,1", "iPod2,1", "iPod2,2", "iPod3,1", "iPod4,1", "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4", "iPad3,1", "iPad3,2", "iPad3,3"]

    public static var specificModelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)
        var identifier = ""

        // Parses the string for the model name via NSUTF8StringEncoding, refer to
        // http://stackoverflow.com/questions/26028918/ios-how-to-determine-iphone-model-in-swift
        for child in mirror.children.enumerated() {
            if let value = child.1.value as? Int8, value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }
        return identifier
    }

    open class func deviceModel() -> String {
        return UIDevice.current.model
    }

    open class func isSimulator() -> Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_ROOT"] != nil
    }

    open class func isBlurSupported() -> Bool {
        // We've tried multiple ways to make this change visible on simulators, but we
        // haven't found a solution that worked:
        // 1. http://stackoverflow.com/questions/21603475/how-can-i-detect-if-the-iphone-my-app-is-on-is-going-to-use-a-simple-transparen
        // 2. https://gist.github.com/conradev/8655650
        // Thus, testing has to take place on actual devices.
        return !lowGraphicsQualityModels.contains(specificModelName)
    }

    // Reports portrait screen size regardless of the current orientation.
    open class func screenSizeOrientationIndependent() -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return CGSize(width: min(screenSize.width, screenSize.height), height: max(screenSize.width, screenSize.height))
    }
}


