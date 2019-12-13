//
//  AppDelegate.swift
//  SwapWatcher
//
//  Created by user on 2019/12/13.
//  Copyright © 2019 rinsuki. All rights reserved.
//

import Cocoa
import ServiceManagement
import Ikemen

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let menuItem = NSStatusBar.system.statusItem(withLength: 48)
    lazy var timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateSwapInfo), userInfo: nil, repeats: true)

    var usage: xsw_usage = .init()
    var size: Int = MemoryLayout<xsw_usage>.size
    let formatter = NumberFormatter()
    
    let swapUsedItem = NSMenuItem(title: "---", action: nil, keyEquivalent: "")
    let swapAllocatedItem = NSMenuItem(title: "---", action: nil, keyEquivalent: "")
    
    let helperBundleId = "net.rinsuki.apps.mac.SwapWatcherLaunchHelper"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        menuItem.button?.font = .systemFont(ofSize: 10)
        menuItem.button?.alignment = .natural
        menuItem.button?.lineBreakMode = .byClipping
        
        let menu = NSMenu()
        menu.addItem(swapUsedItem)
        menu.addItem(swapAllocatedItem)
        menu.addItem(.separator())
        menu.addItem(.separator())
        menu.addItem(.init(title: "Launch at Login", action: #selector(toggleLaunchAtLogin), keyEquivalent: "") ※ { i in
            i.state = getHelperApplicationHasEnabled(helperBundleId) ? .on : .off
        })
        menu.addItem(.init(title: "Quit SwapWatcher", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        menuItem.menu = menu
        
        timer.fire()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func updateMenuItemLength() {
        guard let button = menuItem.button else { return }
        let size = button.sizeThatFits(.init(width: 9999, height: 22))
        menuItem.length = size.width + 8
    }

    @objc func updateSwapInfo() {
        let res = sysctlbyname("vm.swapusage", &usage, &size, nil, 0)
        guard res == 0 else {
            menuItem.button?.title = "Swap (Err)\nsysctl - \(res)"
            updateMenuItemLength()
            return
        }
        let newTitle = "Swap\n\(getBytesWithPrefix(bytes: usage.xsu_used))"
        if let button = menuItem.button, newTitle != menuItem.button?.title {
            button.title = newTitle
            updateMenuItemLength()
        }
        
        swapUsedItem.title = "Swap Used: \(getBytesWithPrefix(bytes: usage.xsu_used))"
        swapAllocatedItem.title = "Swap Allocated: \(getBytesWithPrefix(bytes: usage.xsu_total))"
    }
    
    @objc func toggleLaunchAtLogin(_ sender: NSMenuItem) {
        let current = sender.state == .on
        let new = !current
        if SMLoginItemSetEnabled(helperBundleId as CFString, new) {
            sender.state = new ? .on : .off
        } else {
            let alert = NSAlert()
            alert.messageText = "Failed to register as a Launch Item"
            alert.informativeText = "Please retry with watch Console.app"
            alert.runModal()
        }
    }
}

