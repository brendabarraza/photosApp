import SwiftUI
import Firebase

struct AddView: View {
    
    @State private var titulo = ""
    @State private var desc = ""
    var consolas = ["Travel", "Pets", "Food"]
    @State private var plataforma = "Travel"
    @StateObject var guardar = FirebaseViewModel()
    var device = UIDevice.current.userInterfaceIdiom
    @State private var imageData: Data = .init(capacity: 0)
    @State private var mostrarMenu = false
    @State private var imagePicker = false
    @State private var source: UIImagePickerController.SourceType = .camera
    @State private var progress = false
    @State private var idUser: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color("fondo").edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        Text("Elegir Imagen")
                            .font(.title)
                            .font(.system(size: device == .phone ? 25 : 35))
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.top, 40)
                    .padding()
                    .background(Color("fondo"))

                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: UIScreen.main.bounds.width - 40, height: 150)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        
                        if imageData.count != 0 {
                            Image(uiImage: UIImage(data: imageData)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width - 40, height: 150)
                                .cornerRadius(15)
                                .clipped()
                        }
                        
                        Button(action: {
                            mostrarMenu.toggle()
                        }) {
                            Text("Cargar imagen")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .padding()
                                .background(Color("fondo 1"))
                                .cornerRadius(10)
                                .opacity(imageData.count == 0 ? 1 : 0.7)
                        }
                        .actionSheet(isPresented: $mostrarMenu) {
                            ActionSheet(title: Text("Menu"), message: Text("Selecciona una opción"), buttons: [
                                .default(Text("Camara")) {
                                    source = .camera
                                    imagePicker.toggle()
                                },
                                .default(Text("Libreria")) {
                                    source = .photoLibrary
                                    imagePicker.toggle()
                                },
                                .cancel()
                            ])
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 40, height: 150)
                    .padding(.bottom)

                    TextField("Titulo", text: $titulo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    NavigationLink(destination: ImagePicker(show: $imagePicker, image: $imageData, source: source), isActive: $imagePicker) {
                        EmptyView()
                    }.navigationBarHidden(true)
                    
                    TextEditor(text: $desc)
                        .frame(height: 200)
                        .padding(.horizontal)
                    
                    Picker("Consolas", selection: $plataforma) {
                        ForEach(consolas, id: \.self) { item in
                            Text(item).foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)
                    
                    if imageData.count != 0 {
                        Button(action: {
                            if let userId = Auth.auth().currentUser?.uid {
                                idUser = userId
                                progress = true
                                guardar.save(titulo: titulo, desc: desc, plataforma: plataforma, portada: imageData, idUser: idUser) { (done) in
                                    if done {
                                        titulo = ""
                                        desc = ""
                                        imageData = .init(capacity: 0)
                                        progress = false
                                    }
                                }
                            } else {
                                print("No hay usuario autenticado")
                            }
                        }) {
                            Text("Guardar")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .padding()
                                .background(Color("fondo 1"))
                                .cornerRadius(10)
                        }

                        if progress {
                            Text("Espere un momento por favor...").foregroundColor(.black)
                            ProgressView()
                        }
                    }
                    
                    Spacer()
                }
                .padding(.all)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


