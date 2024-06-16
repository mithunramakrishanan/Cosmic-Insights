//
//  AppleSignInView.swift
//  CosmicInsights
//
//  Created by Mithun on 14/06/24.
//

import SwiftUI
import AuthenticationServices

struct AppleSignInView: View {
    
    @EnvironmentObject var healthManager : HealthStoreManager
    @State var categories : [HealthCategoriesData] = []
    @State var showLoginButton = false
    @State var showLoading = false

    var body: some View {
        
        ZStack {
            
            Image("login_screen").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
            Rectangle().foregroundColor(.black.opacity(0.8)).ignoresSafeArea()
            
            if showLoginButton {
                LoadingHeaderView()
            }
            
            HStack {
                VStack(alignment:.leading, spacing: 35) {
                    ForEach(categories, id:\.id) { category in
                        
                        if category.animate {
                            
                            HStack(alignment : .top) {
                                Image(category.image).resizable().renderingMode(.template).foregroundColor(category.color).frame(width: 40,height: 40)
                                Text("   \(category.title)").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(.white)
                            }
                        }
                    }
                }.padding()
                Spacer()
            }.padding(.leading,50)
            
            if showLoginButton {
                
                AppleSignInButtonView(healthManager: healthManager, showLoading: $showLoading)
            }
            if showLoading {
                
                LoadingView().onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        //As of now shown logged in screen after 2 sec of loading
                        healthManager.loginSuccess = true
                    }
                }
            }
            
        }.onAppear {
            
            categories = healthManager.getCategoriesDetails()
            
            // Animation for data loading
            for(index,_) in categories.enumerated() {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                    withAnimation(.interactiveSpring(response: 0.8,dampingFraction: 0.8,blendDuration: 0.8)) {
                        categories[index].animate = true
                        if index == 4 {
                            showLoginButton = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LoadingView()
}

struct AppleSignInButtonView: View {
    
    var healthManager : HealthStoreManager
    @Binding var showLoading : Bool
    @State var showAlert : Bool = false
    var body: some View {
        VStack {
            Spacer()
            SignInWithAppleButton(.signUp) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    loginSuccessHandler(with: authorization)
                case .failure(let error):
                    showLoading = true
                    loginFailedHandler(with: error)
                }
            }
            .frame(width: 300, height: 50)
            . background(RoundedRectangle(cornerRadius: 8)
                .fill(Color(.darkGray)))
            .shadow(color: .blue, radius: 8, x: 0, y: 5).padding(.bottom, 50)
        }.alert(isPresented: $showAlert, content: {
            Alert(title: Text("LOGIN"), message: Text(" Your account not support sign in with Apple capability"), primaryButton: .default(Text("Login as guest")) {
                healthManager.loginSuccess = true
            }, secondaryButton: .cancel())
        })
    }
    
    private func loginSuccessHandler(with authorization: ASAuthorization) {
        if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            UserDefaults.standard.set(userCredential.fullName?.givenName ?? "Guest", forKey: "userName")
            healthManager.loginSuccess = true
            if userCredential.authorizedScopes.contains(.fullName) {
                print(userCredential.fullName?.givenName ?? "")
            }
            if userCredential.authorizedScopes.contains(.email) {
                print(userCredential.email ?? "No email")
            }
        }
    }
    
    private func loginFailedHandler(with error: Error) {
//        showAlert = true
        UserDefaults.standard.set("Mithun", forKey: "userName")
        print("Could not authenticate: \(error.localizedDescription)")
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.black.opacity(0.6)).ignoresSafeArea()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(2.5, anchor: .center)
        }
    }
}

struct LoadingHeaderView: View {
    var body: some View {
        VStack {
            
            Text("Login").font(.system(size: 40,weight: .bold)).foregroundColor(.white).padding(.top, 50)
            Text("To know your").font(.system(size: 20,weight: .semibold)).foregroundColor(.white).padding(.top, -15)
            Spacer()
        }
    }
}
