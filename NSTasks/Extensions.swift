//
//  Extensions.swift
//  NSTasks
//
//  Created by LeeChan on 10/11/16.
//  Copyright © 2016 MarkiiimarK. All rights reserved.
//

import Cocoa

extension NSView {
    func addConstraintsWithFormat(_ format: String, views: NSView... ) {
        var viewsDictionary = [String: NSView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


class NoneditableTextField: NSTextField {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.isSelectable = false
        self.isEditable = false
        self.isBordered = false
        self.drawsBackground = false
        self.textColor = .controlTextColor
        self.font = NSFont.systemFont(ofSize: 11)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CustomPathControl: NSPathControl {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.pathStyle = .popUp
        self.isEditable = true
        self.wantsLayer = true
        self.font = .systemFont(ofSize: 11)
        self.controlSize = .small
        self.lineBreakMode = .byWordWrapping
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomButton: NSButton {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.bezelStyle = .rounded
        self.font = NSFont.systemFont(ofSize: 13)
        self.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
