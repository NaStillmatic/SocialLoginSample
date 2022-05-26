//
//  ViewController.swift
//  SocialLoginSample
//
//  Created by HwangByungJo  on 2022/05/26.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
  
  @IBOutlet weak var label: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configure()
  }
  
  func configure() {
    guard let user = Auth.auth().currentUser else {
      return self.performSegue(withIdentifier: "showLoginVC", sender: nil)
    }
    
    label.text = user.email
  }
  
  @IBAction func onClickLogout(_ sender: Any) {
    
    let firebaseAuth  = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      return print("\(signOutError.localizedDescription)")
    }
    configure()
  }
}

