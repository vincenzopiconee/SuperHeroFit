import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Security")) {
                    NavigationLink(destination: SecuritySettingsView()) {
                        Text("Security")
                    }
                }
                
                Section(header: Text("Assistance").foregroundColor(.red)) {
                    NavigationLink(destination: HelpView()) {
                        Text("Help")
                            .foregroundColor(.red)
                    }
                    
                    NavigationLink(destination: SupportView()) {
                        Text("Support")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct HelpView: View {
    var body: some View {
        Form {
            Section(header: Text("Common Issues")) {
                Button(action: { /* FAQ */ }) {
                    Text("FAQ")
                }
                
                Button(action: { /* Contact Support */ }) {
                    Text("Contact Support")
                }
            }
            
            Section(header: Text("Guides")) {
                Button(action: { /* User Guide */ }) {
                    Text("User Guide")
                }
            }
        }
        .navigationTitle("Help")
    }
}

struct SupportView: View {
    var body: some View {
        Form {
            Section(header: Text("Contact Us")) {
                Button(action: { /* Email Support */ }) {
                    Text("Email Support")
                }
                
                Button(action: { /* Call Support */ }) {
                    Text("Call Support")
                }
            }
            
            Section(header: Text("Feedback")) {
                Button(action: { /* Send Feedback */ }) {
                    Text("Send Feedback")
                }
            }
        }
        .navigationTitle("Support")
    }
}

#Preview {
    SettingsView()
}
