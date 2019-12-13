//
//  AppDelegate.swift
//  SwapWatcher
//
//  Created by user on 2019/12/13.
//  Copyright © 2019 rinsuki. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let menuItem = NSStatusBar.system.statusItem(withLength: 48)
    lazy var timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateSwapInfo), userInfo: nil, repeats: true)

    var usage: xsw_usage = .init()
    var size: Int = MemoryLayout<xsw_usage>.size
    let formatter = NumberFormatter()
    
    let swapUsedItem = NSMenuItem(title: "---", action: nil, keyEquivalent: "")
    let swapAllocatedItem = NSMenuItem(title: "---", action: nil, keyEquivalent: "")

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        menuItem.button?.font = .systemFont(ofSize: 10)
        menuItem.button?.alignment = .natural
        menuItem.button?.lineBreakMode = .byClipping
        
        let menu = NSMenu()
        menu.addItem(swapUsedItem)
        menu.addItem(swapAllocatedItem)
        menu.addItem(.separator())
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

}

