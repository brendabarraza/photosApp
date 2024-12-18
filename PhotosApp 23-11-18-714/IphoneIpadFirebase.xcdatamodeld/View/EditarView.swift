import SwiftUI

struct EditarView: View {
    @State private var titulo: String = ""
    @State private var desc: String = ""
    @State private var imageData: Data = .init(capacity: 0)
    @State private var mostrarMenu: Bool = false
    @State private var imagePicker: Bool = false
    @State private var source: UIImagePickerController.SourceType = .camera
    @State private var progress: Bool = false
    
    @EnvironmentObject var guardar: FirebaseViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var plataforma: String
    var datos: FirebaseModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("fondo 1").edgesIgnoringSafeArea(.all)
                VStack {
                    NavigationLink(destination: ImagePicker(show: $imagePicker, image: $imageData, source: source), isActive: $imagePicker) {
                        EmptyView()
                    }
                    .navigationBarHidden(true)
                    
                    TextField("Título", text: $titulo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onAppear {
                            titulo = datos.titulo
                        }
                    
                    TextEditor(text: $desc)
                        .frame(height: 200)
                        .onAppear {
                            desc = datos.desc
                        }
                    
                    Button(action: {
                        mostrarMenu.toggle()
                    }) {
                        Text("Cargar imagen")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding()
                            .background(Color("fondo 2"))
                            .cornerRadius(10)
                    }
                    .actionSheet(isPresented: $mostrarMenu) {
                        ActionSheet(title: Text("Menú"), message: Text("Selecciona una opción"), buttons: [
                            .default(Text("Cámara")) {
                                source = .camera
                                imagePicker.toggle()
                            },
                            .default(Text("Librería")) {
                                source = .photoLibrary
                                imagePicker.toggle()
                            },
                            .cancel()
                        ])
                    }
                    
                    if !imageData.isEmpty {
                        Image(uiImage: UIImage(data: imageData)!)
                            .resizable()
                            .frame(width: 250, height: 250)
                            .cornerRadius(15)
                    }
                    
                    Button(action: {
                        if imageData.isEmpty {
                            guardar.edit(titulo: titulo, desc: desc, plataforma: plataforma, id: datos.id, index: datos) { done in
                                if done {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        } else {
                            progress = true
                            guardar.editWithImage(titulo: titulo, desc: desc, plataforma: plataforma, id: datos.id, index: datos, portada: imageData) { done in
                                if done {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }) {
                        Text("Editar")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding()
                            .background(Color("fondo 2"))
                            .cornerRadius(10)
                    }
                    
                    if progress {
                        Text("Espere un momento por favor...").foregroundColor(.black)
                        ProgressView()
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


