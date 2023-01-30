//
//  LoginView.swift
//  Agenda
//
//  Created by Álvaro Pérez on 26/1/23.
//

import SwiftUI

struct LoginView: View {
    
    @State var user = ""
    @State var pass = ""
    @State var isRegister = true
    @State var loginSuccessful = false
    
    var body: some View {
        VStack {
            Spacer()
            Text(isRegister ? "¡Bienvenido!" : "¡Hola otra vez!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            TextField("Nombre de usuario", text: $user)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.bottom, 20)
            SecureField("Contraseña", text: $pass)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.bottom, 20)
            Button(action: {
                let userObject = User(user: user, pass: pass)
                
                if (isRegister) {
                    register(userObject)
                } else {
                    login(userObject)
                }
            }) {
                Text(isRegister ? "Registrarme" : "Iniciar sesión")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 60)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            Spacer()
            Button(action: {
                isRegister = !isRegister
            }) {
                Text(isRegister ? "¿Ya tienes cuenta? Inicia sesión" : "¿No tienes cuenta? Regístrate")
            }
            .foregroundColor(Color.red)
            
            NavigationLink(destination: EventsView(), isActive: $loginSuccessful) {
                EmptyView()
            }
        }
        .padding()
    }
    
    func login(_ user: User) {
        guard let jsonData = try? JSONEncoder().encode(user) else {
            return
        }
        
        print(String(decoding: jsonData, as: UTF8.self))
        
        guard let url = URL(string: "https://superapi.netlify.app/api/login") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse {
                loginSuccessful = httpResponse.statusCode == 200
            }
        }.resume()
    }
    
    func register(_ user: User) {
        guard let jsonData = try? JSONEncoder().encode(user) else {
            return
        }
        
        print(String(decoding: jsonData, as: UTF8.self))
        
        guard let url = URL(string: "https://superapi.netlify.app/api/register") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse {
                loginSuccessful = httpResponse.statusCode == 200
            }
        }.resume()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
