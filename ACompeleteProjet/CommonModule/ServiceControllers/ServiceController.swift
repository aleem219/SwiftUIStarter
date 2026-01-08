//
//  ServiceController.swift
//  TestLogin
//
//  Created by Mohammad Mohsin on 09/01/25.
//

import Foundation
class ServiceController {
    
    func encodeRequestBody<T: Encodable>(requestObject: T, name: String) -> Data? {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(requestObject)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("\(name) Service Request: \(jsonString ?? "")")
            return jsonData
        } catch {
            print("error encoding request")
            return nil
        }
    }
}
