//
//  AppDelegate.swift
//  THPredicateEditorSwift
//
//  Created by thierryH24 on 29/11/2018.
//  Copyright © 2018 thierryH24. All rights reserved.
//

import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    var mainWindowController : MainWindowController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        initializeLibraryAndShowMainWindow()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed (_ sender: NSApplication) -> Bool
    {
        return true
    }
    
    func initializeLibraryAndShowMainWindow() {
        
        mainWindowController = MainWindowController()
        mainWindowController?.showWindow(self)
    }
    
    
}

