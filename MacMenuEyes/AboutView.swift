import SwiftUI

struct AboutView: View {
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Mac Menu Eyes")
                .font(.title)
                .bold()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Developer: Javason")
                Text("Version: \(getVersion())")
                Text("Build: \(getBuildNumber())")
            }
            
            Button("닫기") {
                onClose()
            }
            .padding(.top)
        }
        .padding(20)
        .frame(width: 200)
        .onAppear {
            // 최상위로 표시
            if let window = NSApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                window.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    private func getVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
    }
    
    private func getBuildNumber() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
    }
} 
