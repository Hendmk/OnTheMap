//
//  LoginViewController.swift
//  On The Map
//
//  Created by Hend Alkabani on 27/01/2019.
//  Copyright © 2019 Hend Alkabani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

        @IBOutlet weak var email: UITextField!
        @IBOutlet weak var password: UITextField!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            email.delegate = self
            password.delegate = self
        }

        
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
        @IBAction func clickeLoginButton(_ sender: Any) {
            NetworkConnection.postTheSession(email: email.text!, password: password.text!){
                (errorMessage) in
                print("reeor\(errorMessage ?? "")")
                if errorMessage == nil{
                    DispatchQueue.main.async {
                        movieToMao()
                    }
                }
                    else {
                    DispatchQueue.main.async {
                       self.showAlert(title: "Error", message: errorMessage!)
                    }
                }
            }
            
            func movieToMao(){
                let TabViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! UITabBarController
                UIApplication.shared.keyWindow?.rootViewController = TabViewController
            }
    }
}



extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotificationsHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotificationsHide() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
}
