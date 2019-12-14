//
//  AboutViewController.swift
//  SwapWatcher
//
//  Created by user on 2019/12/14.
//  Copyright © 2019 rinsuki. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {
    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var copyrightLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Failed to load Bundle.main.infoDictionary")
        }
        versionLabel.stringValue = "Version \(infoDictionary["CFBundleShortVersionString"]!) (\(infoDictionary["CFBundleVersion"]!))"
        copyrightLabel.stringValue = infoDictionary["NSHumanReadableCopyright"] as! String
    }
    
    @IBAction func openGitHubRepository(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://github.com/rinsuki/SwapWatcher")!)
    }
}
