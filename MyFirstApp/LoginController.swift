//
//  LoginController.swift
//  MyFirstApp
//
//  Created by Prithvi on 04/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import UIKit

class LoginController: ViewController {
    
    lazy var userNameTextField = UITextField().then {
        $0.delegate = self
        $0.setLeftPadding(16)
        $0.style(placeHolder: "User name")
        $0.border(.orange, width: 1)
    }
    
    lazy var passwordTextField = UITextField().then {
        $0.style(placeHolder: "Password")
        $0.delegate = self
        $0.setLeftPadding(16)
        $0.border(.orange, width: 1)
    }
    
    lazy var loginButton = UIButton().then {
        $0.style("Login", font: UIFont.systemFont(ofSize: 16, weight: .medium), color: .black, bgColor: .white)
        $0.onTap { [weak self] button in
            if(!(self?.isTextFieldsEmpty() ?? false)){
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
        userNameTextField.width(300).roundedEdges(50).centerHorizontally().top(380)
        passwordTextField.width(300).roundedEdges(50).centerHorizontally().top(440)
        passwordTextField.isSecureTextEntry = true
        loginButton.width(200).roundedEdges(44).centerHorizontally().top(500)
        activityIndicator.centerHorizontally().size(50).top(550)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.navigate(to: .home, transition: .push)
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
