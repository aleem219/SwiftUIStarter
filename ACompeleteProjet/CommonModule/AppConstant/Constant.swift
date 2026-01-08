//
//  Constant.swift
//  TestLogin
//
//  Created by Mohammad Mohsin on 09/01/25.
//

import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate


public enum StringConstants {
    public enum URLConstants {
        static let login = "\(AppsNetworkManagerConstants.baseUrlForLogin)/login"
    }
    
    public enum UserDefaultKeys {
        static let kIsUserLoggedIn             = "isUserLoggedIn"
        static let kLoggedInAccessToken        = "access_token"
        static let refreshToken                = "refreshToken"
        static let kLoggedInUserDetails        = "loggedInUserDetails"
        static let kDeviceToken                = "device_token"
        static let kLoggedInUserName           = "loggedInUserName"
        static let kUserPassword               = "UserPassword"
        static let kCheckStatus                = "checkStauts"
        static let kHasShownPopup              = "hasShownPopup"
    }
    public enum AlertMessage {
        static let deletePost = "Do you want to Delete this Post?"
        static let acceptDate = "Do you want to Accept the Invitation?"
        static let rejectDate = "Do you want to Decline the Invitation?"
        static let cancelDate = "Do you want to Cancel the Invitation?"
        static let logout = "Are you sure you want to Logout?"
        static let deleteAdminAccount = "If you choose to delete your account all profiles associated with this account will be deleted including all Play Dates, Posts and Friends.\n Are you sure you want to Delete this Account?"
        
        static let deleteMemberAccount = "If you choose to delete your account all Play Dates, Posts and Friends associated with this account will be deleted.\n Are you sure you want to Delete this Account?"
        
    }
    
    public enum ImageName {
        static let circle = "checkmark.circle"
        static let circleFill = "checkmark.circle.fill"
    }
    
    public enum Regex {
        static let emailRegEx = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    }
    
    public enum Common {
        static let postPlaceHolder = "Share your Fun Plans Here!"
        static let appName = "ParkProtect"
        static let okay = "Okay"
        static let cancel = "Cancel"
        static let confirm = "Confirm"
        static let yes = "Yes"
        static let no = "No"
        static let done = "Done"
        static let format = "SELF MATCHES %@"
    }
    
  
    
    public enum Message {
        static let commonError = "App is currently processing your previous request, please wait for some time."
        static let invalidURL = "Invalid URL"
        static let jsonDecodingError = "JSON Decoding Error"
        static let memberAdded = "Member added successfully"
        static let unknownError = "Unknown Error"
    }
    
    public enum SignUp {
        static let firstName = "Please enter first name"
        static let lastName = "Please enter last name"
        static let mobile = "Please enter mobile number"
        static let validMobile = "Please enter valid mobile number"
        static let email = "Please enter email"
        static let validEmail = "Please enter valid email"
        static let relation = "Please select relation"
        static let password = "Please enter password"
        static let strongPassword = "Password must be atleast 6 characters!"
        static let rememberMe = "Please select 'Remember Me' option."
    }
    
    public enum Login {
        static let validCredential = "Please enter valid email or mobile number"
    }
    
    public enum ResetPassword {
        static let password = "Please enter password"
        static let confirmPassword = "Please enter confirm password"
        static let strongPassword = "To ensure a strong password, please consider using 8 alpha numeric characters including at least 1 special character. Thank you!"
        static let samePassword = "Both passwords should be same"
    }
    
    public enum EditProfile {
        static let savedImage = "savedImageUrl"
    }
}

public enum ServiceOutcome<T> {
    case success(T)
    case failure(ErrorResponseModel)
}

enum OtpHasCameFrom {
    case signup
    case forgotPassword
}
enum carDetailsHasCameFrom {
    case Main
    case Home
    
}


public enum AWSBUCKETCONST {
    static let AWSBUCKETNAME = "park-protect-dev"
    
}

