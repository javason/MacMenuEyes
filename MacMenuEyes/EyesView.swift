import SwiftUI
import AppKit

struct EyesView: View {
    let controller: StatusBarController
    
    @State private var leftEyeOffset: CGSize = .zero
    @State private var rightEyeOffset: CGSize = .zero
    @State private var monitor: Any?
    @State private var lastMouseLocation: CGPoint = .zero
    @State private var lastMouseMoveTime: Date = Date()
    @State private var fastMovementStartTime: Date?
    @State private var eyeColorState: Int = 1 // 1: 흰색, 2: 분홍색, 3: 붉은색
    @State private var movementCheckTimer: Timer?
    @State private var lastSpeedCheckTime: Date = Date()
    
    var eyeBackgroundColor: Color {
        switch eyeColorState {
        case 1: return .white
        case 2: return Color(red: 1.0, green: 0.8, blue: 0.8) // 분홍색
        case 3: return Color(red: 1.0, green: 0.6, blue: 0.6) // 붉은색
        default: return .white
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            EyeView(pupilOffset: leftEyeOffset, backgroundColor: eyeBackgroundColor)
            EyeView(pupilOffset: rightEyeOffset, backgroundColor: eyeBackgroundColor)
        }
        .frame(width: 60, height: 22)
        .onAppear {
            startTracking()
            startMovementCheckTimer()
        }
        .onDisappear {
            stopTracking()
            stopMovementCheckTimer()
        }
    }
    
    private func startMovementCheckTimer() {
        movementCheckTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            let currentTime = Date()
            let timeSinceLastCheck = currentTime.timeIntervalSince(lastSpeedCheckTime)
            
            // 0.1초 동안 마우스 움직임이 없으면 1단계로 복귀
            if timeSinceLastCheck > 0.1 {
                if eyeColorState != 1 {
                    eyeColorState = 1
                    fastMovementStartTime = nil
                }
            }
        }
    }
    
    private func stopMovementCheckTimer() {
        movementCheckTimer?.invalidate()
        movementCheckTimer = nil
    }
    
    private func startTracking() {
        lastMouseLocation = NSEvent.mouseLocation
        lastMouseMoveTime = Date()
        lastSpeedCheckTime = Date()
        
        monitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
            DispatchQueue.main.async {
                updateEyePositions()
                checkMouseSpeed()
            }
        }
    }
    
    private func stopTracking() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
    }
    
    private func checkMouseSpeed() {
        let currentLocation = NSEvent.mouseLocation
        let currentTime = Date()
        
        let distance = hypot(currentLocation.x - lastMouseLocation.x,
                           currentLocation.y - lastMouseLocation.y)
        let timeInterval = currentTime.timeIntervalSince(lastMouseMoveTime)
        
        if timeInterval > 0 {
            let speed = distance / CGFloat(timeInterval)
            
            if speed > 500 {
                lastSpeedCheckTime = currentTime
                
                if fastMovementStartTime == nil {
                    fastMovementStartTime = currentTime
                }
                
                if let startTime = fastMovementStartTime {
                    let duration = currentTime.timeIntervalSince(startTime)
                    
                    if duration >= 1.5 {
                        if eyeColorState != 3 {
                            eyeColorState = 3 // 붉은색
                        }
                    } else if duration >= 1.0 {
                        if eyeColorState != 2 {
                            eyeColorState = 2 // 분홍색
                        }
                    }
                }
            }
        }
        
        lastMouseLocation = currentLocation
        lastMouseMoveTime = currentTime
    }
    
    private func updateEyePositions() {
        guard let button = controller.statusItem.button else { return }
        
        let windowFrame = button.window?.frame ?? .zero
        let buttonFrame = NSRect(
            x: windowFrame.minX,
            y: windowFrame.minY,
            width: button.frame.width,
            height: button.frame.height
        )
        
        let mouseLocation = NSEvent.mouseLocation
        
        let leftEyeCenter = CGPoint(x: buttonFrame.minX + 16, y: buttonFrame.midY)
        let rightEyeCenter = CGPoint(x: buttonFrame.minX + 44, y: buttonFrame.midY)
        
        let leftDelta = CGPoint(x: mouseLocation.x - leftEyeCenter.x,
                              y: mouseLocation.y - leftEyeCenter.y)
        let rightDelta = CGPoint(x: mouseLocation.x - rightEyeCenter.x,
                               y: mouseLocation.y - rightEyeCenter.y)
        
        let maxDistance: CGFloat = 4.0
        
        leftEyeOffset = calculateOffset(delta: leftDelta, maxDistance: maxDistance)
        rightEyeOffset = calculateOffset(delta: rightDelta, maxDistance: maxDistance)
    }
    
    private func calculateOffset(delta: CGPoint, maxDistance: CGFloat) -> CGSize {
        let distance = sqrt(delta.x * delta.x + delta.y * delta.y)
        if distance == 0 { return .zero }
        
        let scale = min(maxDistance / distance, 1.0)
        return CGSize(
            width: delta.x * scale,
            height: -delta.y * scale
        )
    }
}

struct EyeView: View {
    let pupilOffset: CGSize
    let backgroundColor: Color
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: 20, height: 20)
            
            Circle()
                .stroke(Color.black, lineWidth: 1.5)
                .frame(width: 20, height: 20)
            
            Circle()
                .fill(Color.black)
                .frame(width: 8, height: 8)
                .offset(pupilOffset)
        }
    }
} 