//
//  ViewController.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 08/01/26.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passowordTF: UITextField!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func btnLoginAction(_ sender: UIButton) {
        guard let username = emailTF.text, let password = passowordTF.text else { return }
        if !validateInputs(username: username, password: password) {
            return
        }
        viewModel.loginRequest(username: username, password: password)
        KeychainService.save(username: username, password: password)
    }
    
}

extension ViewController {
    func setupUI() {
        emailTF.tag = 1 // Email
        passowordTF.tag = 2 // Username
        viewModel.delegate = self
    }
    
    func openTabbar() {
        let tabbarView = TabbarView()
        let hostingVC = UIHostingController(rootView: tabbarView)

        self.navigationController?.pushViewController(hostingVC, animated: true)
    }
}

extension ViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.validateInput(range: range, replacementString: string, in: self)
    }
}


extension ViewController: LoginViewModelProtocol {
    func validateInputs(username: String, password: String) -> Bool {
        if username.isEmpty {
            showAlert(message: StringConstants.Login.email)
            return false
        }
        
//           let emailPredicate = NSPredicate(
//               format: StringConstants.Common.format,
//               StringConstants.Regex.emailRegEx
//           )
//           
//           if !emailPredicate.evaluate(with: username) {
//               showAlert(message: StringConstants.SignUp.validEmail)
//               return false
//           }
        
        if password.isEmpty {
            showAlert(message: StringConstants.Login.password)
            return false
        }
        if password.count < 6 {
            showAlert(message: StringConstants.Login.strongPassword)
            return false
        }
        return true
    }
    
    func loginSuccessful(message: String) {
        showAlert(message: message) {
//            appDelegate.moveToHome()
//            appDelegate.moveToTabbar()
            self.openTabbar()
        }
    }
    
    func loginFailure(message: String) {
        showAlert(message: message) {}
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = StringConstants.Regex.emailRegEx
        return NSPredicate(format: StringConstants.Common.format, emailRegEx).evaluate(with: email)
    }
}
