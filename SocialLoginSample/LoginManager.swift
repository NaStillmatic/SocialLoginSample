//
//  LoginManager.swift
//  SocialLoginSample
//
//  Created by HwangByungJo  on 2022/05/26.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit

class LoginManager: NSObject {
  
  static let shared = LoginManager()
  
  private var currentNonce: String?
  
  var appleCompletion: ((Bool, String) -> Void)?
      
  // MARK: - Email
  
  func loginEmailUser(email: String?, password: String?, completion: @escaping (Bool, String) -> Void) {
    guard let email = email,
          let password = password else { return completion(false, "email or password is nil") }
    
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
      if let error = error {
        completion(false, error.localizedDescription)
      } else {
        completion(true, "Success")
      }
    }
  }
  
  func createUser(email: String?, password: String?, completion: @escaping (Bool, String) -> Void) {
    
    guard let email = email,
          let password = password else { return completion(false, "email or password is nil") }
    
    Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
      guard let self = self else { return completion(false, "self is nil") }
      
      if let error = error {
        let code = (error as NSError).code
        switch code {
        case 17007: // 이미 가입한 계정일 때
          print("이미 가입된 계정입니다.")
          self.loginEmailUser(email: email, password: password, completion: completion)
        default:
          completion(false, error.localizedDescription)
        }
      } else {
        completion(true, "Success")
      }
    }
  }
  
  // MARK: - Google
  
  func loginGoogle(presenting: UIViewController,  completion: @escaping (Bool, String) -> Void) {
    
    guard let clientID = FirebaseApp.app()?.options.clientID else { return completion(false, "clientID is nil") }
    
    let signInConfig = GIDConfiguration(clientID: clientID)
    
    GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: presenting) { user, error in
      
      if let error = error {
        return completion(false, error.localizedDescription)
      }
      
      guard let auth = user?.authentication,
            let idToken = auth.idToken else { return completion(false, "authentication or idToken is nil") }
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: auth.accessToken)
      
      Auth.auth().signIn(with: credential) { result , error in
        if let error = error {
          return completion(false, error.localizedDescription)
        } else {
          completion(true, "Success")
        }
      }
    }
  }
  
  // MARK: - facebook
  
  func loginFacebook(presenting: UIViewController,  completion: @escaping (Bool, String) -> Void) {
    
    let fbLogin = FBSDKLoginKit.LoginManager()
        
    fbLogin.logIn(permissions: ["email"], from: presenting) { result, error in
      
      if let error = error {
        print("error.localizedDescription")
        completion(false, error.localizedDescription)
      } else {
        guard let tokenString = AccessToken.current?.tokenString else { return completion(false, "tokenString is nil") }
        let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
        
        Auth.auth().signIn(with: credential) { authResult, error in
          
          if let error = error {
            completion(false, error.localizedDescription)
          } else {
            completion(true, "Success")
          }
        }
      }
    }
  }
}
  
// MARK: - Apple
extension LoginManager: ASAuthorizationControllerDelegate {
    
  func loginApple(completion: @escaping (Bool, String) -> Void) {
    
    appleCompletion = nil
    let nonce = String.randomNonceString()
    currentNonce = nonce
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = nonce.sha256
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
    
    appleCompletion = completion
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    
    guard let completion = appleCompletion else { return }
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      /*
       Nonce 란?
       - 암호화된 임의의 난수
       - 단 한번만 사용할 수 있는 값
       - 주로 암호화 통신을 할 때 활용
       - 동일한 요청을 짧은 시간에 여러번 보내는 릴레이 공격 방지
       - 정보 탈취 없이 안전하게 인증 정보 전달을 위한 안전장치
       */
      guard let nonce = currentNonce else {
        return completion(false, "Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        return completion(false, "Unable to fetch identity token")
        
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        return completion(false, "Unable to serialize token string from data: \(appleIDToken.debugDescription)")
      }
      
      let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
      Auth.auth().signIn(with: credential) { authResult, error in
        if let error = error {
          completion(false,"Error Apple sign in: \(error)")
        } else {
          completion(true, "Success")
        }
      }
    }
  }
}

extension LoginManager: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    let app = UIApplication.shared.delegate as! AppDelegate
    return app.window!
  }
}


