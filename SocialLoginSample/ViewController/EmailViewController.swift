//
//  EmailViewController.swift
//  SocialLoginSample
//
//  Created by HwangByungJo  on 2022/05/26.
//

import UIKit

class EmailViewController: UIViewController {
  
  @IBOutlet weak var tfEmail: UITextField!
  @IBOutlet weak var tfPassword: UITextField!
  
  @IBOutlet weak var labelError: UILabel!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func onClickBtn(_ sender: Any) {
    labelError.text = nil
    LoginManager.shared.createUser(email: tfEmail.text, password: tfPassword.text) { [weak self] isSuccess, result in
      guard let self = self else { return }
      if isSuccess {
        self.dismiss(animated: true)
      } else {
        self.labelError.text = result
      }
    }
  }
}

extension EmailViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == tfEmail {
      tfPassword.becomeFirstResponder()
    } else {
      onClickBtn(self)
    }
    return true
  }
}
