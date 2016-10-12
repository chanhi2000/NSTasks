//
//  AppDelegate.swift
//  NSTasks
//
//  Created by LeeChan on 10/11/16.
//  Copyright © 2016 MarkiiimarK. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var windowController: WindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let wc = WindowController()
        wc.showWindow(self)
        self.windowController = wc
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

