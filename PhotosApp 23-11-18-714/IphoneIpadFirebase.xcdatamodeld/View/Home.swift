
import SwiftUI
import Firebase
struct Home: View {
    @State private var index = "Travel"
    @State private var menu = false
    @State private var widthMenu = UIScreen.main.bounds.width
    @EnvironmentObject var loginShow : FirebaseViewModel
    
    var body: some View {
        ZStack{
            VStack{
                NavBar(index: $index, menu: $menu)
                ZStack{
                    if index == "Travel" {
                       ListView(plataforma: "Travel")
                    }else if index == "Pets"{
                        ListView(plataforma: "Pets")
                    }else if index == "Food" {
                        ListView(plataforma: "Food")
                    }
                }
            }
            if menu {
                HStack{
                    Spacer()
                    VStack{
                        HStack{
                            Spacer()
                            Button(action:{
                                withAnimation{
                                    menu.toggle()
                                }
                            }){
                                Image(systemName: "xmark")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }.padding()
                        .padding(.top, 50)
                        VStack(alignment: .trailing){
                            ButtonView(index: $index, menu: $menu, title: "Travel")
                            ButtonView(index: $index, menu: $menu, title: "Pets")
                            ButtonView(index: $index, menu: $menu, title: "Food")
                        }
                        Spacer()
                    }
                    .frame(width: widthMenu - 200)
                    .background(Color("fondo 2"))
                }
            }
        }.background(Color("fondo"))
    }
}


