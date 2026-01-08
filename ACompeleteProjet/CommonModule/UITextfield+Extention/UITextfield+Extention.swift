//
//  UITextfield+Extention.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 08/01/26.
//



import Foundation
import Foundation
import UIKit
extension UITextField {
    func validateInput(range: NSRange, replacementString string: String, in viewController: UIViewController) -> Bool {
        let currentText = (self.text ?? "") as NSString
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        if self.tag == 1 { // Email TextField
            if string.contains(" ") {
                UIViewController.showToast(message: "Email should not contain spaces", in: viewController)
                return false
            }
        } else if self.tag == 2 { // Username TextField
            // Check for spaces
            if string.contains(" ") {
                UIViewController.showToast(message: "Username should not contain spaces", in: viewController)
                return false
            }
            if newText.count > 10 {
                UIViewController.showToast(message: "Username cannot exceed 10 characters", in: viewController)
                return false
            }
        }
        
        return true
    }
    
    // Border width property
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    // Border color property
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    // Corner radius property
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    // Left padding property
        @IBInspectable var leftPadding: CGFloat {
            get {
                return leftView?.frame.size.width ?? 0
            }
            set {
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.height))
                leftView = paddingView
                leftViewMode = .always
            }
        }

        // Right padding property
        @IBInspectable var rightPadding: CGFloat {
            get {
                return rightView?.frame.size.width ?? 0
            }
            set {
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.height))
                rightView = paddingView
                rightViewMode = .always
            }
        }
}
