//
//  TaskViewController.swift
//  NSTasks
//
//  Created by LeeChan on 10/11/16.
//  Copyright © 2016 MarkiiimarK. All rights reserved.
//

import Cocoa

class TaskViewController: NSViewController, NSPathControlDelegate, NSTextViewDelegate {
    
    let projectLocation:NoneditableTextField = {
        let tf = NoneditableTextField()
        tf.stringValue = "Project Location"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let buildRepository:NoneditableTextField = {
        let tf = NoneditableTextField()
        tf.stringValue = "Build Repository"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let spinner:NSProgressIndicator = {
        let spr = NSProgressIndicator()
        spr.style = .spinningStyle
        spr.isDisplayedWhenStopped = false
        return spr
    }()
    
    let projectPath:CustomPathControl = {
        let pc = CustomPathControl()
        pc.url = URL(fileURLWithPath: myProjectPath)
        return pc
    }()
    
    var repoPath:CustomPathControl = {
        let pc = CustomPathControl()
        pc.url = URL(fileURLWithPath: myRepoPath)
        return pc
    }()
    
    lazy var buildButton:CustomButton = {
        let btn = CustomButton()
        btn.action = #selector(startTask)
        btn.title = "Build"
        btn.isEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var stopButton:CustomButton = {
        let btn = CustomButton()
        btn.action = #selector(stopTask)
        btn.title = "Stop"
        btn.isEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let stackView: NSStackView = {
        let sv = NSStackView()
        sv.orientation = .horizontal
        return sv
    }()
    
    let targetName:NSTextField = {
        let tf = NSTextField()
        tf.isEditable = true
        tf.isSelectable = true
        tf.wantsLayer = true
        tf.placeholderString = targetNamePlaceholderString
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let taskOutputArea:NSScrollView = {
        let sv = NSScrollView()
        sv.wantsLayer = true
        sv.hasVerticalScroller = true
        sv.autohidesScrollers = true
        sv.scrollerKnobStyle = .default
        sv.borderType = .bezelBorder
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let outputText:NSTextView = {
        let tv = NSTextView()
        tv.isEditable = false
        tv.isSelectable = true
        tv.isVerticallyResizable = true
        tv.isHorizontallyResizable = false
        tv.maxSize = NSSize(width: CGFloat(FLT_MAX), height: CGFloat(FLT_MAX))
        tv.isContinuousSpellCheckingEnabled = true
        tv.layoutManager?.allowsNonContiguousLayout = true
        tv.string = "SAMPLE TEXT"

        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    dynamic var isRunning: Bool = false {
        willSet {
//            print("About to set 'isRunning' status to:  \(newValue)")
        }
        
        didSet {
            if isRunning != oldValue {
                buildButton.isEnabled = !isRunning
                stopButton.isEnabled = isRunning
            }
        }
    }
    
    var outputPipe:Pipe!
    var buildTask:Process!
    
    override var nibName: String? {  return myViewNibName }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupCustomViews()
        
    }
    
    func setupViews() {
        view.addSubview(projectLocation)
        view.addSubview(buildRepository)
        view.addSubview(projectPath)
        view.addSubview(repoPath)
        view.addSubview(targetName)
        view.addSubview(taskOutputArea)
        view.addSubview(stackView)
        
        view.addConstraintsWithFormat("H:|-20-[v0]", views: projectLocation)
        view.addConstraintsWithFormat("H:|-20-[v0]", views: buildRepository)
        view.addConstraintsWithFormat("H:|-20-[v0]", views: projectPath)
        view.addConstraintsWithFormat("H:|-20-[v0]", views: repoPath)
        view.addConstraintsWithFormat("H:|-20-[v0]-20-|", views: targetName)
        view.addConstraintsWithFormat("H:|-20-[v0]-20-|", views: taskOutputArea)
        view.addConstraintsWithFormat("H:|-20-[v0]-20-|", views: stackView)
        
        view.addConstraintsWithFormat("V:|-20-[v0]-12-[v1]-12-[v2]-12-[v3]-12-[v4]-11-[v5(250)]-11-[v6]-22-|", views: projectLocation, projectPath, buildRepository, repoPath, targetName, taskOutputArea, stackView)
        
        taskOutputArea.documentView = outputText
        taskOutputArea.addConstraintsWithFormat("H:|[v0]|", views: outputText)
        taskOutputArea.addConstraintsWithFormat("V:|[v0(900)]", views: outputText)
//        taskOutputArea.
        
        
        // determine the height of
//        outputText.heightAnchor.constraint(equalToConstant: <#T##CGFloat#>)
    }
    func setupCustomViews() {
        stackView.addSubview(buildButton)
        stackView.addSubview(stopButton)
        stackView.addSubview(spinner)
        
        stackView.addConstraintsWithFormat("V:|-14-[v0]-14-|", views: buildButton)
        stackView.addConstraintsWithFormat("V:|-14-[v0(16)]-14-|", views: stopButton)
        stackView.addConstraintsWithFormat("V:|-14-[v0]-14-|", views: spinner)
        stackView.addConstraintsWithFormat("H:[v0]-8-[v1]-8-[v2(16)]|", views: buildButton, stopButton, spinner)
    }
    
    func startTask() {
        outputText.string = ""
        
        if let projectURL = projectPath.url, let repositoryURL = repoPath.url {
            
            //2.
            let projectLocation = projectURL.path
            let finalLocation = repositoryURL.path
            
            //3.
            let projectName = projectURL.lastPathComponent
            let xcodeProjectFile = projectLocation + "/\(projectName).xcodeproj"
            
            //4.
            let buildLocation = projectLocation + "/build"
            
            //5.
            var arguments:[String] = []
            arguments.append(xcodeProjectFile)
            arguments.append(targetName.stringValue)
            arguments.append(buildLocation)
            arguments.append(projectName)
            arguments.append(finalLocation)
            
            //6.
            spinner.startAnimation(self)
            runScript(arguments)
        }
    }
    
    func stopTask() {
        if isRunning {  buildTask.terminate()  }
    }
    
    func runScript(_ arguments: [String]) {
        isRunning = true
        
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        taskQueue.async {
            
            guard let path = Bundle.main.path(
                forResource: "BuildScript",
                ofType:"command") else {
                print("Unable to locate BuildScript.command")
                return
            }
            
            self.buildTask = Process()
            self.buildTask.launchPath = path
            self.buildTask.arguments = arguments
            
            self.buildTask.terminationHandler = {
                task in
                DispatchQueue.main.async(execute: {
                    self.buildButton.isEnabled = true
                    self.spinner.stopAnimation(self)
                    self.isRunning = false
                })
            }
            
            //TODO - Output Handling
            self.captureStandardOutputAndRouteToTextView(self.buildTask)
            self.buildTask.launch()
            self.buildTask.waitUntilExit()
        }
    }
    
    func captureStandardOutputAndRouteToTextView(_ task: Process) {
        
        outputPipe = Pipe()
        task.standardOutput = outputPipe
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) {
            notification in
            
            let output = self.outputPipe.fileHandleForReading.availableData
            let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
            
            DispatchQueue.main.async(execute: {
                let previousOutput = self.outputText.string ?? ""
                let nextOutput = previousOutput + "\n" + outputString
                self.outputText.string = nextOutput
                
                let range = NSRange(location:nextOutput.characters.count, length:0)
                self.outputText.scrollRangeToVisible(range)
            })
            
            self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }
    }
    
}
