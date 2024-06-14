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
                        HStack(alignment : .top) {
                            Image(category.image).resizable().renderingMode(.template).foregroundColor(category.color).frame(width: 40,height: 40)
                            Text("   \(category.title)").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(.white)
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
            
            var index = 0
            for category in healthManager.getCategoriesDetails() {
                index += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.6) {
                    withAnimation(.spring(.smooth(duration: 0.3))){
                        categories.append(category)
                        if categories.count == 5 {
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
        }
    }
    
    private func loginSuccessHandler(with authorization: ASAuthorization) {
        if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print(userCredential.user)
            if userCredential.authorizedScopes.contains(.fullName) {
                print(userCredential.fullName?.givenName ?? "No given name")
            }
            if userCredential.authorizedScopes.contains(.email) {
                print(userCredential.email ?? "No email")
            }
        }
    }
    
    private func loginFailedHandler(with error: Error) {
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
