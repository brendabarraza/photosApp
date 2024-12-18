import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginShow: FirebaseViewModel
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white 
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        return Group {
            if loginShow.show {
                TabView {
                    Home()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    
                    AddView()
                        .tabItem {
                            Image(systemName: "plus.circle.fill")
                            Text("Add")
                        }
                    
                    Likes()
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("Favorites")
                        }
                    
                    Perfil()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
                .accentColor(Color("fondo 3"))
            } else {
                Login()
            }
        }
        .onAppear {
            if (UserDefaults.standard.object(forKey: "sesion")) != nil {
                loginShow.show = true
            }
        }
    }
}




        
     


