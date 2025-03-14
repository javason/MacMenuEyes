import SwiftUI

struct ContentView: View {
    @State private var showAbout = false

    var body: some View {
        VStack {
            Button("About") {
                showAbout.toggle()
            }
            .sheet(isPresented: $showAbout) {
                AboutView {
                    showAbout = false
                }
            }
        }
    }
} 