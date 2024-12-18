import SwiftUI
import FirebaseAuth

struct Likes: View {
    
    var device = UIDevice.current.userInterfaceIdiom
    @Environment(\.horizontalSizeClass) var width
    
    func getColumns() -> Int {
        return (device == .pad) ? 3 : ((device == .phone && width == .regular) ? 3 : 1)
    }
    
    @StateObject var datos = FirebaseViewModel()
    @State private var showEditar = false
    @EnvironmentObject var loginShow: FirebaseViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Favoritos")
                    .font(.title)
                    .font(.system(size: device == .phone ? 25 : 35))
                    .bold()
                    .padding()
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.top, 30)
            .padding(.horizontal)
            .background(Color("fondo 2"))
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: getColumns()), spacing: 20) {
                    ForEach(datos.datos) { item in
                        CardViewFavoritos(titulo: item.titulo, portada: item.portada, index: item, plataforma: "favoritos")
                            .onTapGesture {
                                showEditar.toggle()
                            }
                            .sheet(isPresented: $showEditar) {
                                EditarView(plataforma: "favoritos", datos: item)
                            }
                            .padding(.all)
                    }
                }
            }
        }
        .onAppear {
            if let userId = Auth.auth().currentUser?.uid {
                datos.getUserFav(userId: userId)
            }
        }
        .background(Color("fondo")) 
    }
}

struct Likes_Previews: PreviewProvider {
    static var previews: some View {
        Likes()
            .environmentObject(FirebaseViewModel())
    }
}

