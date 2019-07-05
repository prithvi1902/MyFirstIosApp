//
//  LoginController.swift
//  MyFirstApp
//
//  Created by Prithvi on 04/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import UIKit
import Stevia

class LoginController: ViewController {
    
    lazy var userNameTextField = UITextField().then {
        $0.delegate = self
        $0.setLeftPadding(16)
        $0.style(placeHolder: "User name")
        $0.border(.orange)
    }
    
    lazy var passwordTextField = UITextField().then {
        $0.style(placeHolder: "Password")
        $0.delegate = self
        $0.setLeftPadding(16)
        $0.border(.orange)
    }
    
    lazy var loginButton = UIButton().then {
        $0.style("Login", font: UIFont.systemFont(ofSize: 16, weight: .medium), color: .black, bgColor: .white)
        $0.onTap { [weak self] button in
            if(!(self?.isTextFieldsEmpty() ?? false)) {
                self?.login()
            }
        }
    }
    
    let activityIndicator = UIActivityIndicatorView().then{
        $0.color = .black
        $0.hidesWhenStopped = true
    }
    
    override func render() {
        view.backgroundColor = UIColor.white
        view.sv(userNameTextField, passwordTextField, loginButton, activityIndicator)
        userNameTextField.width(300).roundedEdges(50).centerHorizontally().top(300)
        passwordTextField.width(300).roundedEdges(50).centerHorizontally()
        passwordTextField.Top == userNameTextField.Bottom + 20
        passwordTextField.isSecureTextEntry = true
        loginButton.width(200).roundedEdges(44).centerHorizontally()
        loginButton.Top == passwordTextField.Bottom + 20
        activityIndicator.centerInContainer()
    }
    
    func isTextFieldsEmpty() -> Bool {
        if(userNameTextField.text?.isEmpty ?? true){
            showAlert(alertMessage: "enter the user name")
            return true
        }else if(passwordTextField.text?.isEmpty ?? true){
            showAlert(alertMessage: "enter the password")
            return true
        }else{
            return false
        }
    }
    
    func login(){
        let delay = 3 // seconds
        self.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
            self?.navigate(to: .home, transition: .push)
        }
    }
    
    func showAlert(alertMessage: String){
        let alert = UIAlertController(title: "Login Error", message: "Please \(alertMessage)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
