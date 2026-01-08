//
//  CommonUtilities.swift
//  Ride Chef
//
//  Created by Aaditya on 11/02/2022.
//

import Foundation
import UIKit
//import Alamofire

class CommonUtilitiess{
    
    static let shared = CommonUtilitiess()
    var window: UIWindow?
    
//    func sethomescreen() {
//        let storyboard:UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        let homeobj = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//        
//        var nav_obj = UINavigationController()
//        nav_obj = UINavigationController(rootViewController: homeobj)
//        nav_obj.isNavigationBarHidden = true
//        
//        UIApplication.shared.windows.first?.rootViewController = nav_obj
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
//    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"//"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPassword(passwordStr: String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let password = passwordStr.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)

    }
}


