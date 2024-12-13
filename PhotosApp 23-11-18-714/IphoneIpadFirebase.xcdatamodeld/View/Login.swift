


import SwiftUI

struct Login: View {
    
    @State private var email = ""
    @State private var pass = ""
    @StateObject var login = FirebaseViewModel()
    @EnvironmentObject var loginShow : FirebaseViewModel
    var device = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        ZStack{
            Color("fondo 2").edgesIgnoringSafeArea(.all)
            VStack{
                Text("My Photos")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .frame(width: device == .pad ? 400 : nil)
                SecureField("Pass", text: $pass)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: device == .pad ? 400 : nil)
                    .padding(.bottom, 20)
                
                Button(action:{
                    login.login(email: email, pass: pass) { (done) in
                        if done{
                            UserDefaults.standard.set(true, forKey: "sesion")
                            loginShow.show.toggle()
                        }
                    }
                }){
                    Text("Entrar")
                        .font(.title)
                        .frame(width: 200 )
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                }.background(
                    Capsule()
                        .stroke(Color.white)
                )
                
                Divider()
                Button(action:{
                    login.createUser(email: email, pass: pass) { (done) in
                        if done{
                            UserDefaults.standard.set(true, forKey: "sesion")
                            loginShow.show.toggle()
                        }
                    }
                }){
                    Text("Registrarse")
                        .font(.title)
                        .frame(width: 200 )
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                }.background(
                    Capsule()
                        .stroke(Color.white)
                )
                
                
                
            }.padding(.all)
        }
    }
}


