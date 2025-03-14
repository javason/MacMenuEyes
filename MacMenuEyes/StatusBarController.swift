import SwiftUI
import AppKit

class StatusBarController {
    var statusItem: NSStatusItem
    private var hostingView: NSHostingView<EyesView>?
    private var aboutWindow: NSWindow?
    
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.frame = NSRect(x: 0, y: 0, width: 62, height: 22)
            button.wantsLayer = true
            button.layer?.backgroundColor = .clear
            
            let menu = NSMenu()
            
            let aboutItem = NSMenuItem(title: "About", action: #selector(showAbout), keyEquivalent: "")
            aboutItem.target = self
            menu.addItem(aboutItem)
            
            menu.addItem(NSMenuItem.separator())
            
            menu.addItem(NSMenuItem(title: "종료", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            
            statusItem.menu = menu
            
            let eyesView = EyesView(controller: self)
            hostingView = NSHostingView(rootView: eyesView)
            hostingView?.frame = button.bounds
            hostingView?.autoresizingMask = [.width, .height]
            
            if let hostingView = hostingView {
                button.addSubview(hostingView)
            }
        }
    }
    
    @objc private func showAbout() {
        if aboutWindow == nil {
            aboutWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 200, height: 160),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            aboutWindow?.title = "About Menu Eyes"
            aboutWindow?.center()
            
            let aboutView = AboutView(onClose: { [weak self] in
                self?.aboutWindow?.close()
            })
            aboutWindow?.contentView = NSHostingView(rootView: aboutView)
            aboutWindow?.isReleasedWhenClosed = false
        }
        
        aboutWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
} 