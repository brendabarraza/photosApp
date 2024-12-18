import SwiftUI
import Firebase

struct CardViewPerfil: View {
    
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
                datos.delete(index: index, plataforma: plataforma)
                
            }){
                Text("Eliminar")
                    .foregroundColor(.red)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)
                    .background(Capsule().stroke(Color.red))
            }
        }.padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}


