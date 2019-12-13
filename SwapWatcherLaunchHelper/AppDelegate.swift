//
//  AppDelegate.swift
//  SwapWatcherLaunchHelper
//
//  Created by user on 2019/12/14.
//  Copyright © 2019 rinsuki. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        defer {
            NSApp.terminate(nil)
        }
        
        let bundleId = "net.rinsuki.apps.mac.SwapWatcher"
        let applications = NSRunningApplication.runningApplications(withBundleIdentifier: bundleId)
        guard applications.count == 0 else { return }

        print(NSWorkspace.shared.launchApplication(withBundleIdentifier: bundleId, additionalEventParamDescriptor: nil, launchIdentifier: nil))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

