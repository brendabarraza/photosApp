//
//  FirebaseViewModel.swift
//  IphoneIpadFirebase
//
//  Created by brenda on 10/09/2024.
//


import Foundation
import Firebase
import FirebaseStorage


class FirebaseViewModel: ObservableObject {
    
    @Published var show = false
    @Published var datos = [FirebaseModel]()
    
    func login(email:String, pass: String, completion: @escaping (_ done: Bool) -> Void ){
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if user != nil {
                print("Entro")
                completion(true)
            }else{
                if let error = error?.localizedDescription {
                    print("Error en firebase", error)
                }else{
                    print("Error en la app")
                }
            }
        }
    }
    
    func createUser(email: String, pass: String, completion: @escaping (_ done: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: pass) { (result, error) in
            if let user = result?.user {
                let userId = user.uid
                let db = Firestore.firestore()
                
                // Guardar solo el userId en la colección "usuarios"
                db.collection("usuarios").document(userId).setData([
                    "userId": userId
                ]) { error in
                    if let error = error {
                        print("Error al guardar el userId en Firestore: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("UserId guardado en Firestore exitosamente")
                        completion(true)
                    }
                }
            } else {
                if let error = error?.localizedDescription {
                    print("Error en Firebase de registro", error)
                } else {
                    print("Error en la app")
                }
                completion(false)
            }
        }
    }

    
    /// BASE DE DATOS
    
    func save(titulo: String, desc: String, plataforma: String, portada: Data, idUser: String, completion: @escaping (_ done: Bool) -> Void) {
        let storage = Storage.storage().reference()
        let nombrePortada = UUID().uuidString
        let directorio = storage.child("imagenes/\(nombrePortada)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        metadata.customMetadata = ["userId": idUser]
        
        // Subir la imagen al almacenamiento
        directorio.putData(portada, metadata: metadata) { _, error in
            if let error = error {
                print("Error al subir la imagen al almacenamiento: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            print("Imagen guardada exitosamente")
            
            // Obtener la URL de descarga de la imagen
            directorio.downloadURL { url, error in
                if let error = error {
                    print("Error al obtener la URL de descarga: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let downloadURL = url?.absoluteString else {
                    print("No se pudo obtener la URL de descarga")
                    completion(false)
                    return
                }
                
                // Guardar los datos en la colección principal
                let db = Firestore.firestore()
                let id = UUID().uuidString
                guard let email = Auth.auth().currentUser?.email else {
                    print("No se pudo obtener el email del usuario")
                    completion(false)
                    return
                }
                
                let campos: [String: Any] = [
                    "titulo": titulo,
                    "desc": desc,
                    "portada": downloadURL,
                    "idUser": idUser,
                    "email": email
                ]
                
                // Guardar en la colección principal
                let mainCollection = db.collection(plataforma).document(id)
                mainCollection.setData(campos) { error in
                    if let error = error {
                        print("Error al guardar en Firestore: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    
                    print("Datos guardados en la colección principal")
                    
                    // Guardar en la subcolección 'imagenes' dentro del documento del usuario
                    let userCollection = db.collection("usuarios").document(idUser).collection("imagenes").document(id)
                    userCollection.setData(campos) { error in
                        if let error = error {
                            print("Error al guardar en la subcolección 'imagenes': \(error.localizedDescription)")
                            completion(false)
                        } else {
                            print("Datos guardados en la subcolección 'imagenes' del usuario")
                            completion(true)
                        }
                    }
                }
            }
        }
    }








    
    // MOSTRAR
    
    func getData(plataforma: String){
        let db = Firestore.firestore()
        db.collection(plataforma).addSnapshotListener { (QuerySnapshot, error) in
            if let error = error?.localizedDescription{
                print("error al mostrar datos ", error)
            }else{
                self.datos.removeAll()
                for document in QuerySnapshot!.documents {
                    let valor = document.data()
                    let id = document.documentID
                    let titulo = valor["titulo"] as? String ?? "sin titulo"
                    let desc = valor["desc"] as? String ?? "sin desc"
                    let portada = valor["portada"] as? String ?? "sin portada"
                    let idUser = valor["idUser"] as? String ?? "sin idUser"
                    DispatchQueue.main.async {
                        let registros = FirebaseModel(id: id, titulo: titulo, desc: desc, portada: portada, idUser: idUser)
                        self.datos.append(registros)
                    }
                }
            }
        }
        
    }
    
    func getUserImages(userId: String) {
            let db = Firestore.firestore()
            db.collection("usuarios").document(userId).collection("imagenes").addSnapshotListener { (QuerySnapshot, error) in
                if let error = error?.localizedDescription {
                    print("Error al mostrar datos ", error)
                } else {
                    self.datos.removeAll()
                    for document in QuerySnapshot!.documents {
                        let valor = document.data()
                        let id = document.documentID
                        let titulo = valor["titulo"] as? String ?? "sin titulo"
                        let desc = valor["desc"] as? String ?? "sin desc"
                        let portada = valor["portada"] as? String ?? "sin portada"
                        let idUser = valor["idUser"] as? String ?? "sin idUser"
                        DispatchQueue.main.async {
                            let registros = FirebaseModel(id: id, titulo: titulo, desc: desc, portada: portada, idUser: idUser)
                            self.datos.append(registros)
                        }
                    }
                }
            }
        }
    
    func getUserFav(userId: String) {
            let db = Firestore.firestore()
            db.collection("usuarios").document(userId).collection("favoritos").addSnapshotListener { (QuerySnapshot, error) in
                if let error = error?.localizedDescription {
                    print("Error al mostrar datos ", error)
                } else {
                    self.datos.removeAll()
                    for document in QuerySnapshot!.documents {
                        let valor = document.data()
                        let id = document.documentID
                        let titulo = valor["titulo"] as? String ?? "sin titulo"
                        let desc = valor["desc"] as? String ?? "sin desc"
                        let portada = valor["portada"] as? String ?? "sin portada"
                        let idUser = valor["idUser"] as? String ?? "sin idUser"
                        DispatchQueue.main.async {
                            let registros = FirebaseModel(id: id, titulo: titulo, desc: desc, portada: portada, idUser: idUser)
                            self.datos.append(registros)
                        }
                    }
                }
            }
        }
    
    //ELIMINAR
    
    func delete(index: FirebaseModel, plataforma: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No hay usuario autenticado")
            return
        }
        
        // Verifica si el usuario actual es el dueño de la imagen
        if index.idUser == currentUserId {
            // Eliminar del Firestore en la colección principal
            let id = index.id
            let db = Firestore.firestore()
            
            // Eliminar de la colección principal (categoría general)
            db.collection(plataforma).document(id).delete { error in
                if let error = error {
                    print("Error al eliminar de la colección principal: \(error.localizedDescription)")
                } else {
                    print("Imagen eliminada de la colección principal")
                }
            }

            // Eliminar la imagen del Storage
            let imagen = index.portada
            let borrarImagen = Storage.storage().reference(forURL: imagen)
            borrarImagen.delete { error in
                if let error = error {
                    print("Error al eliminar la imagen del Storage: \(error.localizedDescription)")
                } else {
                    print("Imagen eliminada del Storage")
                }
            }

            // Intentar eliminar de la subcolección en la colección usuarios
            db.collection("usuarios").document(currentUserId).collection("imagenes").document(id).delete { error in
                if let error = error {
                    print("Error al eliminar de la subcolección 'imagenes': \(error.localizedDescription)")
                } else {
                    print("Imagen eliminada de la subcolección 'imagenes'")
                }
            }
            

            // Intentar eliminar de todas las categorías
            let categorias = ["Travel", "Pets", "Food"]
            for categoria in categorias {
                db.collection(categoria).document(id).delete { error in
                    if let error = error {
                        print("Error al eliminar de la categoría \(categoria): \(error.localizedDescription)")
                    } else {
                        print("Imagen eliminada de la categoría \(categoria)")
                    }
                }
            }
        } else {
            
            print("No tienes permisos para eliminar esta imagen")
        }
    }
    
    func deleteFromFavorites(index: FirebaseModel) {
            guard let currentUserId = Auth.auth().currentUser?.uid else {
                print("No hay usuario autenticado")
                return
            }

            let id = index.id
            let db = Firestore.firestore()

            // Eliminar de la subcolección 'favoritos' del usuario actual
            db.collection("usuarios").document(currentUserId).collection("favoritos").document(id).delete { error in
                if let error = error {
                    print("Error al eliminar de la subcolección 'favoritos': \(error.localizedDescription)")
                } else {
                    print("Elemento eliminado de la subcolección 'favoritos'")
                }
            }
        }


    
    func edit(titulo: String, desc: String, plataforma: String, id: String, index: FirebaseModel, completion: @escaping (_ done: Bool) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No se pudo obtener el ID del usuario actual.")
            completion(false)
            return
        }

        // Imprime el ID del usuario que intenta editar
        print("Usuario que intenta editar: \(currentUserId)")

        // Imprime el ID del usuario que subió la imagen
        print("ID del usuario que subió la imagen: \(index.idUser)")

        // Verifica si el usuario actual es el dueño de la imagen
        if index.idUser == currentUserId {
            let db = Firestore.firestore()
            let documentRef = db.collection(plataforma).document(id)
            
            // Verifica si el documento existe antes de actualizarlo
            documentRef.getDocument { document, error in
                if let error = error {
                    print("Error al obtener el documento: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                if let document = document, document.exists {
                    let campos: [String: Any] = ["titulo": titulo, "desc": desc]
                    documentRef.updateData(campos) { error in
                        if let error = error {
                            print("Error al actualizar el documento: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            print("Documento actualizado en la colección \(plataforma)")
                            completion(true)
                        }
                    }
                } else {
                    print("Documento no encontrado en la colección \(plataforma) con ID \(id)")
                    completion(false)
                }
            }
        } else {
            print("No tienes permisos para editar esta imagen")
            // Imprime también el ID del usuario que está intentando editar
            print("ID del usuario que intentó editar: \(currentUserId)")
            completion(false)
        }
    }




    
    // EDITAR CON IMAGEN
    func editWithImage(titulo: String, desc: String, plataforma: String, id: String, index: FirebaseModel, portada: Data, completion: @escaping (_ done: Bool) -> Void) {
        // Eliminar la imagen anterior
        let imagen = index.portada
        let borrarImagen = Storage.storage().reference(forURL: imagen)
        borrarImagen.delete { error in
            if let error = error {
                print("Error al eliminar la imagen del Storage: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            print("Imagen eliminada del Storage")

            // Subir la nueva imagen
            let storage = Storage.storage().reference()
            let nombrePortada = UUID().uuidString
            let directorio = storage.child("imagenes/\(nombrePortada)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            
            directorio.putData(portada, metadata: metadata) { _, error in
                if let error = error {
                    print("Error al subir la nueva imagen al Storage: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                print("Nueva imagen guardada exitosamente")

                // Obtener la URL de descarga de la nueva imagen
                directorio.downloadURL { url, error in
                    if let error = error {
                        print("Error al obtener la URL de descarga de la nueva imagen: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    
                    guard let downloadURL = url?.absoluteString else {
                        print("No se pudo obtener la URL de descarga de la nueva imagen")
                        completion(false)
                        return
                    }
                    
                    // Actualizar el texto y la URL de la imagen en Firestore
                    let db = Firestore.firestore()
                    let campos: [String: Any] = [
                        "titulo": titulo,
                        "desc": desc,
                        "portada": downloadURL
                    ]
                    
                    db.collection(plataforma).document(id).getDocument { document, error in
                        if let error = error {
                            print("Error al obtener el documento: \(error.localizedDescription)")
                            completion(false)
                            return
                        }
                        if let document = document, document.exists {
                            print("Documento encontrado. Procediendo a actualizar...")
                            // Llama a la función para actualizar el documento aquí
                        } else {
                            print("Documento no encontrado.")
                            completion(false)
                        }
                    }


                    // Actualizar en la colección principal
                    db.collection(plataforma).document(id).updateData(campos) { error in
                        if let error = error {
                            print("Error al actualizar el documento en Firestore: \(error.localizedDescription)")
                            completion(false)
                            return
                        }
                        
                        print("Documento actualizado en la colección principal")
                        
                        // Actualizar en la subcolección 'imagenes' dentro del documento del usuario
                        db.collection("usuarios").document(index.idUser).collection("imagenes").document(id).updateData(campos) { error in
                            if let error = error {
                                print("Error al actualizar en la subcolección 'imagenes': \(error.localizedDescription)")
                                completion(false)
                            } else {
                                print("Datos actualizados en la subcolección 'imagenes' del usuario")
                                completion(true)
                            }
                        }
                    }
                }
            }
        }
    }

    
}
