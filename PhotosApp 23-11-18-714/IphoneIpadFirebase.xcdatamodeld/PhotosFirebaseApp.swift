import SwiftUI

@main
struct IphoneIpadFirebaseApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelelgate
    
    var body: some Scene {
        let login = FirebaseViewModel()
        WindowGroup {
            ContentView().environmentObject(login)
        }
    }
}
