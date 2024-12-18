import SwiftUI
import FirebaseAuth
import Firebase

struct CardView: View {
    var titulo: String
    var portada: String
    var index: FirebaseModel
    var plataforma: String
    var device = UIDevice.current.userInterfaceIdiom
    @StateObject var datos = FirebaseViewModel()
    @State private var isFavorite = false
    
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ImagenFirebase(imageUrl: portada)
            Text(titulo)
                .font(.system(size: device == .phone ? 25 : 35))
                .bold()
                .foregroundColor(.black)
            Button(action: {
                isFavorite.toggle()
                if isFavorite {
                    addToFavorites()
                } else {
                    removeFromFavorites()
                }
            }) {
                Spacer()
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isFavorite ? .red : .gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .onAppear {
            checkIfFavorite()
        }
    }
    
    private func addToFavorites() {
        guard let userId = userId else {
            print("Usuario no autenticado")
            return
        }
        
        let db = Firestore.firestore()
        let favoritesRef = db.collection("usuarios").document(userId).collection("favoritos").document(index.id)
        
        favoritesRef.setData([
            "titulo": index.titulo,
            "portada": index.portada,
            "idUser": index.idUser
        ]) { error in
            if let error = error {
                print("Error al agregar a favoritos: \(error.localizedDescription)")
            } else {
                print("Elemento agregado a favoritos")
            }
        }
    }
    
    private func removeFromFavorites() {
        guard let userId = userId else {
            print("Usuario no autenticado")
            return
        }
        
        let db = Firestore.firestore()
        let favoritesRef = db.collection("usuarios").document(userId).collection("favoritos").document(index.id)
        
        favoritesRef.delete { error in
            if let error = error {
                print("Error al eliminar de favoritos: \(error.localizedDescription)")
            } else {
                print("Elemento eliminado de favoritos")
            }
        }
    }
    
    private func checkIfFavorite() {
        guard let userId = userId else {
            print("Usuario no autenticado")
            return
        }
        
        let db = Firestore.firestore()
        let favoritesRef = db.collection("usuarios").document(userId).collection("favoritos").document(index.id)
        
        favoritesRef.getDocument { document, error in
            if let document = document, document.exists {
                isFavorite = true
            } else {
                isFavorite = false
            }
        }
    }
}

