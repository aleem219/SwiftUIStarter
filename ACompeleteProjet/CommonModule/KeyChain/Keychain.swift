//
//  Keychain.swift
//  TestLogin
//
//  Created by Mohammad Mohsin on 09/01/25.
//

import Foundation
class KeychainService {

    private static let service = "com.example.myapp"  // Define your service name here

    // Save username and password to Keychain
    @discardableResult
    static func save(username: String, password: String) -> Bool {
        let usernameData = username.data(using: .utf8)!
        let passwordData = password.data(using: .utf8)!
        
        // Save username
        let usernameQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "username",
            kSecValueData as String: usernameData
        ]
        
        // Save password
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "password",
            kSecValueData as String: passwordData
        ]
        
        // Check if username exists, if so update it, otherwise add new
        let usernameStatus = SecItemCopyMatching(usernameQuery as CFDictionary, nil)
        if usernameStatus == errSecSuccess {
            let attributesToUpdate: [String: Any] = [kSecValueData as String: usernameData]
            _ = SecItemUpdate(usernameQuery as CFDictionary, attributesToUpdate as CFDictionary)
        } else {
            _ = SecItemAdd(usernameQuery as CFDictionary, nil)
        }
        
        // Check if password exists, if so update it, otherwise add new
        let passwordStatus = SecItemCopyMatching(passwordQuery as CFDictionary, nil)
        if passwordStatus == errSecSuccess {
            let attributesToUpdate: [String: Any] = [kSecValueData as String: passwordData]
            _ = SecItemUpdate(passwordQuery as CFDictionary, attributesToUpdate as CFDictionary)
        } else {
            _ = SecItemAdd(passwordQuery as CFDictionary, nil)
        }

        return usernameStatus == errSecSuccess && passwordStatus == errSecSuccess
    }

    // Load username and password from Keychain
    static func load() -> (username: String?, password: String?) {
        // Load username
        let usernameQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "username",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var usernameResult: AnyObject?
        let usernameStatus = SecItemCopyMatching(usernameQuery as CFDictionary, &usernameResult)
        
        // Load password
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "password",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var passwordResult: AnyObject?
        let passwordStatus = SecItemCopyMatching(passwordQuery as CFDictionary, &passwordResult)
        
        if usernameStatus == errSecSuccess, let usernameData = usernameResult as? Data,
           let username = String(data: usernameData, encoding: .utf8),
           passwordStatus == errSecSuccess, let passwordData = passwordResult as? Data,
           let password = String(data: passwordData, encoding: .utf8) {
            return (username, password)
        }
        
        return (nil, nil)
    }

    // Update username and password in Keychain
    @discardableResult
    static func update(username: String, password: String) -> Bool {
        return save(username: username, password: password)
    }

    // Remove username and password from Keychain
    @discardableResult
    static func remove() -> Bool {
        let usernameQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "username"
        ]
        
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "password"
        ]
        
        let usernameStatus = SecItemDelete(usernameQuery as CFDictionary)
        let passwordStatus = SecItemDelete(passwordQuery as CFDictionary)
        
        return usernameStatus == errSecSuccess && passwordStatus == errSecSuccess
    }
}
