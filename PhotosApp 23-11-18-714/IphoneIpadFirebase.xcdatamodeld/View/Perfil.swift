import SwiftUI
import FirebaseAuth
import Firebase

struct Perfil: View {
    
    var device = UIDevice.current.userInterfaceIdiom
    @State private var index = "Travel"
    @State private var menu = false
    @Environment(\.horizontalSizeClass) var width
    
    func getColumns() -> Int {
        return (device == .pad) ? 3 : ((device == .phone && width == .regular) ? 3 : 1)
    }
    
    @StateObject var datos = FirebaseViewModel()
    @State private var showEditar = false
    @EnvironmentObject var loginShow: FirebaseViewModel
    @State private var showPerfilInfo = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Perfil")
                    .font(.title)
                    .font(.system(size: device == .phone ? 25 : 35))
                    .bold()
                    .padding()
                    .foregroundColor(.white)
                Spacer()
                if let user = Auth.auth().currentUser, let email = user.email {
                    Button(action: {
                        showPerfilInfo.toggle()
                    }) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .padding()
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showPerfilInfo) {
                        PerfilInfo(userEmail: email, userId: user.uid)
                    }
                }
            }
            .padding(.top, 30)
            .padding(.horizontal)
            .background(Color("fondo 2"))
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: getColumns()), spacing: 20) {
                    ForEach(datos.datos) { item in
                        CardViewPerfil(titulo: item.titulo, portada: item.portada, index: item, plataforma: "imagenes")
                            .onTapGesture {
                                showEditar.toggle()
                            }
                            .sheet(isPresented: $showEditar) {
                                EditarView(plataforma: "imagenes", datos: item)
                            }
                            .padding(.all)
                    }
                }
            }
            .onAppear {
                if let userId = Auth.auth().currentUser?.uid {
                    datos.getUserImages(userId: userId)
                }
            }
        }
        .background(Color("fondo"))
    }
}

struct PerfilInfo: View {
    var userEmail: String
    var userId: String
    @EnvironmentObject var loginShow : FirebaseViewModel
    var body: some View {
        VStack {
            Text("Información del Perfil")
                .padding(.top)
                .font(.title)
                .bold()
                .foregroundColor(.black)
            
            Text("Correo:\(userEmail)")
                .font(.title2)
                .padding(.top)
            
            Text("ID del Usuario: \(userId)")
                .font(.title2)
                .padding(.top)
            
            Spacer()
            Button(action:{
                try! Auth.auth().signOut()
                UserDefaults.standard.removeObject(forKey: "sesion")
                loginShow.show = false
            }){
                Text("Salir")
                    .font(.title)
                    .frame(width: 200)
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                
            }.background(
                Capsule().stroke(Color.white)
            )
            Spacer()
        }
        .padding()
    }
}

struct Perfil_Previews: PreviewProvider {
    static var previews: some View {
        Perfil()
            .environmentObject(FirebaseViewModel())
    }
}







