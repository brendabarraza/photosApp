//
//  ContentView.swift
//  IphoneIpadFirebase
//
//  Created by brenda on 10/09/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginShow: FirebaseViewModel
    
    init() {
        // Personalizar la apariencia de la barra de pestañas
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white // Fondo blanco
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
                .accentColor(Color("fondo 3")) // Color de los iconos y textos
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




        
     


