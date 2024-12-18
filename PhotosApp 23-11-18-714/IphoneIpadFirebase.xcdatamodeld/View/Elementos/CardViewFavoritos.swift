import SwiftUI

struct CardViewFavoritos: View {
    
    var titulo : String
    var portada : String
    var index : FirebaseModel
    var plataforma : String
    var device = UIDevice.current.userInterfaceIdiom
    @StateObject var datos = FirebaseViewModel()
    
    var body: some View {
        VStack(spacing: 20){
            ImagenFirebase(imageUrl: portada)
            Text(titulo)
                .font(.system(size: device == .phone ? 25 : 35))
                .bold()
                .foregroundColor(.black)
            Button(action:{
                datos.deleteFromFavorites(index: index)
            }){
                Spacer()
                Image(systemName: "heart.fill" ) 
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.red)
            }
        }.padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}

