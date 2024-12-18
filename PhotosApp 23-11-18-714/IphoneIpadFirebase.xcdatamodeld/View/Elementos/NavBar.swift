import SwiftUI
import Firebase


struct NavBar: View {
    
    var device = UIDevice.current.userInterfaceIdiom
    @Binding var index : String
    @Binding var menu : Bool
    var body: some View {
        HStack{
           Text("  My Photos")
                .font(.title)
                .font(.system(size: device == .phone ? 25 : 35))
                .bold()
                .foregroundColor(.white)
            Spacer()
            if device == .pad {
                HStack(spacing: 25){
                    ButtonView(index: $index, menu: $menu, title: "Travel")
                    ButtonView(index: $index, menu: $menu, title: "Pets")
                    ButtonView(index: $index, menu: $menu, title: "Food")
                }
            }else{
                Button(action:{
                    withAnimation{
                        menu.toggle()
                    }
                }){
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                }
            }
                
        }
        .padding(.top, 30)
        .padding()
        .background(Color("fondo 2"))
    }
}


