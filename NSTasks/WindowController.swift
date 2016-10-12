//
//  WindowController.swift
//  NSTasks
//
//  Created by LeeChan on 10/11/16.
//  Copyright © 2016 MarkiiimarK. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
//    var taskVC: TaskViewController!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.contentViewController = TaskViewController()
        window?.title = appTitle
//        window?.makeFirstResponder(taskVC.outputText)
    }
    
    override var windowNibName: String? {
        return myWindowNibName
    }
    
}
