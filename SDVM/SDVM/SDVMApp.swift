import SwiftUI
import Firebase

/**
 * App Delegate
 */

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct SDVMApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionService = SessionServiceImpl()
    
    var body: some Scene {
        WindowGroup {
            switch sessionService.state {
                
            case .loggedIn:
                if (sessionService.userDetails?.types == "Çevirmen") {
                    
                    TabView {
                        cevirmenView()
                            .tabItem {
                                Label("Ana Sayfa", systemImage: "house.fill")
                            }
                        
                        HomeView()
                            .environmentObject(sessionService)
                            .tabItem {
                                Label("Profil", systemImage: "person")
                            }
                        
                    }
                }
                
                if (sessionService.userDetails?.types == "Engelli") {
                    TabView {
                        engelliView()
                            .tabItem {
                                Label("Ana Sayfa", systemImage: "house.fill")
                            }
                        
                        HomeView()
                            .environmentObject(sessionService)
                            .tabItem {
                                Label("Profil", systemImage: "person")
                            }
                        
                    }
                }
                
                if (sessionService.userDetails?.types == "Takipçi") {
                    TabView {
                        takipciView()
                            .tabItem {
                                Label("Ana Sayfa", systemImage: "house.fill")
                            }
                        
                        HomeView()
                            .environmentObject(sessionService)
                            .tabItem {
                                Label("Profil", systemImage: "person")
                            }
                        
                    }
                }
                
                
                
            case .loggedOut:
                LoginView()
                
            }
        }
    }
}
    
    // HomeView()
    //    .environmentObject(sessionService)

