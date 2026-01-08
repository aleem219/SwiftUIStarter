//
//  AppsNetworkManager.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 08/01/26.
//

import Foundation
import UIKit
import AVFoundation
import MessageUI

//import FirebaseCoreInternal
// MARK: - Globle Variable for AppsNetworkManagerInstanse

let appsNetworkManagerInstanse = AppsNetworkManager.sharedInstanse
let iimageCache = NSCache<NSString, AnyObject>()
public typealias Parameters = [String: Any]

public class AppsNetworkManager: NSObject, MFMailComposeViewControllerDelegate {
    
    internal static let sharedInstanse: AppsNetworkManager = AppsNetworkManager()
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func requestApi(requestData: Data,
                    serviceurl: String,
                    showHud: Bool = true,
                    methodType: HttpMethod,
                    completionClosure: @escaping (_ result: Data) -> ()) -> Void {

        // MARK: - Check the network availability
        if InternetConnectionManager.isConnectedToNetwork() != true {
            DispatchQueue.main.async {
                UIViewController.getTopViewController()?.showAlert(
                    message: StringConstants.Login.email
                )
            }
            return
        }


        // MARK: - Fetch URL From Strings
        guard let url = URL(string: serviceurl.replacingOccurrences(of: " ", with: "%20")) else { return }

        // Declare `request` before using it
        var request = URLRequest(url: url)
        var accessToken = ""
        if !UserDefaults.standard.getLoggedInAccessToken().isEmpty {
            accessToken = "Bearer \(UserDefaults.standard.getLoggedInAccessToken())"
        }
        print(accessToken)
        // Now set headers on `request`
        request.httpMethod = methodType.rawValue
        request.setValue(accessToken, forHTTPHeaderField: AppsNetworkManagerConstants.accessToken)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if methodType.rawValue != HttpMethod.get.rawValue {
            request.httpBody = requestData
        }

        // Start the network call
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                let returnMessage = "RequestFailed :-> \(String(describing: error!.localizedDescription))"
                DispatchQueue.main.async {
                    self.alert(message: returnMessage)
                }
                return
            }
            guard let httpsResponse = response as? HTTPURLResponse else { return }
            let statusCode = httpsResponse.statusCode
            let json = self.nsdataToJSON(data: data ?? Data())
//            print("Response: \(json)")

            switch statusCode {
            case 200, 201:
                DispatchQueue.main.async {
                    print("Response: \(String(describing: json))")
                    completionClosure(data ?? Data())
                }

            case 401:
                DispatchQueue.main.async {
                    print("Response: \(String(describing: json))")
                    completionClosure(data ?? Data())
                }
            case 402:
                DispatchQueue.main.async {
                print("unauthorized")
                }
                
            default:
                DispatchQueue.main.async {
                    // Handle other cases
                    print("Response: \(String(describing: json))")
                    completionClosure(data ?? Data())
                    print("Unexpected status code: \(statusCode)")
                }
            }
        }.resume()
    }

    
//    func requestApi(requestData: Data,
//                    serviceurl: String,
//                    showHud: Bool = true,
//                    methodType: HttpMethod,
//                    completionClosure: @escaping (_ result: Data) -> ()) -> Void {
//        
//        // MARK: - Check the network availability
//        //        if  NetworkReachabilityManager()?.isReachable != true {
//        //            showAlertMessage.alert(message: AlertMessage.knoNetwork)
//        //        }
//        
//        // MARK: -Fatch URL From Strings
//        
//        guard let url = URL(string: serviceurl.replacingOccurrences(of: " ", with: "%20")) else { return }
//        
//        let accessToken = "\(UserDefaults.standard.getLoggedInAccessToken())"
//        request.setValue(accessToken, forHTTPHeaderField: AppsNetworkManagerConstants.accessToken)
//        print("Access token: \(accessToken)")
//        var request = URLRequest(url: url)
//        request.httpMethod = methodType.rawValue
//        
//        print(accessToken)
//        
//        if  methodType.rawValue != HttpMethod.get.rawValue {
//            request.httpBody = requestData
//        }
//        
//        request.setValue(accessToken, forHTTPHeaderField: AppsNetworkManagerConstants.accessToken)
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard error == nil else {
//                let returnMessage = "RequestFailed :->  \(String(describing: error!.localizedDescription))"
//                DispatchQueue.main.async {
////                    LoadingView.showLoadingView(show: false)
//                    self.alert(message: returnMessage)
//                }
//                return
//            }
//            guard  let httpsresponse = response as? HTTPURLResponse else {return}
//            let statusCode = httpsresponse.statusCode
//            let json = self.nsdataToJSON(data: data ?? Data())
//            print("Response: \(json)")
//            switch statusCode {
//            case 200:
//                DispatchQueue.main.async {
//                    print("Response: \(json)")
//                    completionClosure(data ?? Data())
//                }
//            case 400:
//                DispatchQueue.main.async {
////                    LoadingView.loadingView(show: false)
//                    guard let messageDict = json as? [String:Any] else { return }
//  
//                }
//            case 403:
//                DispatchQueue.main.async {
////                    LoadingView.loadingView(show: false)
//                    guard let messageDict = json as? [String:Any] else { return }
//                
//                }
//            case 401:
//                DispatchQueue.main.async {
////                    LoadingView.showLoadingView(show: false)
////                    (UIApplication.shared.delegate as? AppDelegate)?.moveToLogin()
//                }
//            default:
//                DispatchQueue.main.async {
////                    LoadingView.loadingView(show: false)
//
//                }
//            }
//        }.resume()
//    }
    
    func requestMultipartApi(parameters : Dictionary<String , Any> , serviceurl:String , methodType:  HttpMethod, completionClosure: @escaping (_ result: Any?) -> ()) -> Void{
        let urlString = AppsNetworkManagerConstants.baseUrl + serviceurl
        guard let url = URL(string: urlString.replacingOccurrences(of: " ", with: "%20")) else { return }
        print("Connecting to Host with URL \(urlString) with parameters: \(parameters)")
        let accessToken = UserDefaults.standard.getLoggedInAccessToken()
        var request = URLRequest(url: url)
        print(accessToken)
        request.httpMethod = methodType.rawValue
        request.setValue(accessToken, forHTTPHeaderField: AppsNetworkManagerConstants.accessToken)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let boundary =  "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! createBody(parameters: parameters, boundary: boundary, mimeType: "image/jpeg/png/jpg/docx/doc/mp4/mov/movie/m4a")
        
        
        URLSession.shared.dataTask(with: request){(data , response , error) in
            guard error == nil else {
                let returnMessage = "RequestFailed :->  \(String(describing: error!.localizedDescription))"
                print(returnMessage)
                return
            }
            
//            if let response = response {
//            }
            if let data = data {
                guard  let httpsresponse = response as? HTTPURLResponse else {return}
                
                let statusCode = httpsresponse.statusCode
               
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                   
                    print(response as Any)
                    
                    switch statusCode{
                    case 200 :
                        DispatchQueue.main.async {
                            completionClosure(response)
                        }
                        break
                    case 400:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                          //  AlertController.showAlert(message: String.getString(kSharedInstance.getDictionary(data)["message"]))
                        }
                        break
                    case 401:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            //AlertController.showAlert(message: String.getString(kSharedInstance.getDictionary(data)["message"]))
                        }
                        break
                    case 404:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           // AlertController.showAlert(message: String.getString(kSharedInstance.getDictionary(data)["message"]))
                        }
                        break
                    case 409:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           // AlertController.showAlert(message: String.getString(kSharedInstance.getDictionary(data)["message"]))
                        }
                        break

                    default:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            
                        }

                        break
                    }
                } catch {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    
    
    
    //MARK:- Func for Create Body for multipart Api to append Video and images
    func createBody(parameters: [String: Any], boundary: String, mimeType: String) throws -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            if(value is String || value is NSString) {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            } else if let imagValue = value as? UIImage {
                let random = arc4random()
                let filename = "image\(random).jpg" //MARK:  put your imagename in key
                let data: Data = imagValue.jpegData(compressionQuality: 0.7) ?? Data()
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: \(mimeType)\r\n\r\n")
                body.append(data)
                body.append("\r\n")
                
            } else if value is [String: String] {
                var body1 = Data()
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                for (keyy, valuee) in (value as? [String: String])! {
                    body1.append("--\(boundary)\r\n")
                    body1.append("Content-Disposition: form-data; name=\"\(keyy)\"\r\n\r\n")
                    body1.append("\(valuee)\r\n")
                }
                
                body.append(body1)
                
            } else if let images = value as? [UIImage] {
                
                for image in images {
                    let random = arc4random()
                    let filename = "image\(random).jpg" //MARK:  put your imagename in key
                    let data: Data = image.jpegData(compressionQuality: 0.5)!
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                    body.append("Content-Type: \(mimeType)\r\n\r\n")
                    body.append(data)
                    body.append("\r\n")
                    
                }
            } else if let auidoData = value as? Data { //MARK:  it is Used for Video and pdf send to the server
                let random = arc4random()
                let filename = "\(key)\(random).m4a" //MARK:  Put you image Name in key
                let data : Data = auidoData
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: audio/m4a\r\n\r\n")
                body.append(data)
                body.append("\r\n")
            } else if let videoData = value as? Data { //MARK:  it is Used for Video and pdf send to the server
                let random = arc4random()
                let filename = "\(key)\(random).mov" //MARK:  Put you image Name in key
                let data : Data = videoData
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: \(mimeType)\r\n\r\n")
                body.append(data)
                body.append("\r\n")
            } else if let multipleData = value as? [Data] { //MARK:  It is used for Multiple Data to api
                for filedata in multipleData {
                    let random = arc4random()
                    let filename = "\(key)\(random).mov" //MARK:-  put your imagename in key
                    let data: Data = filedata
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                    body.append("Content-Type: \(mimeType)\r\n\r\n")
                    body.append(data)
                    body.append("\r\n")
                    
                }
            }
        }
        body.append("--\(boundary)--\r\n")
        return body
    }
    
}

//MARK:- Class For Shared Utilities For AppsNetworkManagerInstanse
extension AppsNetworkManager {
    
    //MARK: - Show Alert For Error
    func alert(message:String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alert.addAction(action1)
//        UIApplication.topViewController()?.present(alert , animated: true)
    }
    
    func nsdataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}


// MARK: - Constant for Api For Url Sessions

struct AppsNetworkManagerConstants {
    static let baseUrl                  = "http://13.202.184.77/v1/api"
    static let accessToken              = "Authorization"
    static let baseUrlForLogin          = "https://dummyjson.com/auth"
    static let baseUrlForGet            = ""
}

// MARK: - Enum For httpsMethods

enum HttpMethod: String {
    case get  = "GET"
    case post = "POST"
    case put  = "PUT"
    case delete = "DELETE"
}

// MARK: - Extension for Downlode Image Using URl Sessions
extension UIImageView{
    
    private static var taskKey = 0
    private static var urlKey = 0
    
    private var currentTask: URLSessionTask? {
        get { return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var currentURL: URL? {
        get { return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func loadImageAsync(with urlString: String?, placeholderImage: UIImage?) {
        // cancel prior task, if any
        
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        
        // reset imageview's image
        
        self.image = placeholderImage
        
        // allow supplying of `nil` to remove old image and then return immediately
        
        guard let urlString = urlString else { return }
        
        // check cache
        
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            self.image = cachedImage
            return
        }
        
        // download
        
        guard let url = URL(string: urlString.replacingOccurrences(of:  " ", with: "%20")) else { return }
        currentURL = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.currentTask = nil
            
            //error handling
            
            if let error = error {
                // don't bother reporting cancelation errors
                
                if (error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorCancelled {
                    return
                }
                print(error)
                return
            }
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("unable to extract image")
                return
            }
            ImageCache.shared.save(image: downloadedImage, forKey: urlString)
            
            if url == self?.currentURL {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }
        
        // save and start new task
        
        currentTask = task
        task.resume()
    }
    
}

class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol!
    
    static let shared = ImageCache()
    
    private init() {
        // make sure to purge cache on memory pressure
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { [weak self] notification in
            self?.cache.removeAllObjects()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer as Any)
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}


//MARK: - Extension for Downlode Image Using URl Sessions
extension UIImageView {
    
    //MARK:- Func for downlode image
    func downlodeImage(serviceurl:String , placeHolder: UIImage? = UIImage(named: "profilePlaceholder")) {
        
        self.image = placeHolder
        let urlString = serviceurl
        guard let url = URL(string: urlString.replacingOccurrences(of:  " ", with: "%20")) else { return }
        
        //MARK:- Check image Store in Cache or not
        if let cachedImage = iimageCache.object(forKey: urlString.replacingOccurrences(of: " ", with: "%20") as NSString) {
            if  let image = cachedImage as? UIImage {
                self.image = image
                print("Find image on Cache : For Key" , urlString.replacingOccurrences(of: " ", with: "%20"))
                return
            }
        }
        
        print("Conecting to Host with Url:-> \(url)")
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                DispatchQueue.main.async {
                    self.image = placeHolder
                    return
                }
            }
            if data == nil {
                DispatchQueue.main.async {
                    self.image = placeHolder
                }
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    iimageCache.removeAllObjects()
                    self.image = image
                    iimageCache.setObject(image, forKey: urlString.replacingOccurrences(of: " ", with: "%20") as NSString)
                }
            }
        }).resume()
    }
}

//MARK:- Extension of Data For Apped String
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
extension UserDefaults {
    func getLoggedInAccessToken() -> String {
        return string(forKey: "access_token") ?? ""
    }
}
extension UserDefaults {
    var loggedInUserName: String? {
          get {
              return string(forKey: "loggedInUserName")
          }
          set {
              set(newValue, forKey: "loggedInUserName")
          }
      }
//    var loggedUserPassword: String?{
//        set{
//            set(newValue, forKey: "kUserPassword")
//        }
//    }
}



//extension AppsNetworkManager {
//    
//    func deleteImage(imageName: String) {
//        let s3Service = AWSS3.default()
//        let deleteObjectRequest = AWSS3DeleteObjectRequest()
//        deleteObjectRequest?.bucket = AWSBUCKETCONST.AWSBUCKETNAME// bucket name
//        deleteObjectRequest?.key = imageName//"" // File name
//        s3Service.deleteObject((deleteObjectRequest ?? nil)!).continueWith { (task: AWSTask) -> AnyObject? in
//            if let error = task.error {
//                return nil
//            } else {
//                return nil
//            }
//        }
//    }
//    func uploadImageOnS3(data: Data, completion : @escaping (_ urlString: String?, _ error: Error?) -> Void) {
//        let name = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
//        let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock? = { (task, error) -> Void in
//            if error != nil {
//                completion(nil, error)
//            } else {
//                if let s3URL: URL = AWSS3.default().configuration.endpoint.url {
//                    let contentUrl = "\(s3URL.appendingPathComponent(AWSBUCKETCONST.AWSBUCKETNAME))"+"\("/")"+"\(task.key)"
//                    completion(contentUrl, nil)
//                }
//            }
//        }
//        
//        let expression = AWSS3TransferUtilityUploadExpression()
//        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
//        })
//        }
//        let transferUtility = AWSS3TransferUtility.default()
//        transferUtility.uploadData(data as Data,
//            bucket: AWSBUCKETCONST.AWSBUCKETNAME,
//            key: name,
//            contentType: "image/jpeg",
//            expression: expression,
//            completionHandler: completionHandler).continueWith {
//                (task: AWSTask) -> AnyObject? in
//                if let error = task.error {
//                    print(error)
//                }
//                if let uploadTask = task.result {
//                    print("Upload started...\(uploadTask)")
//                }
//                return nil
//        }
//    }
//    
//        func uploadfile(fileUrl: URL, fileName: String, contenType: String, completion : @escaping (_ urlString: String?, _ error: Error?) -> Void) {
//            let expression = AWSS3TransferUtilityUploadExpression()
//            expression.progressBlock = {(task, awsProgress) in
//               }
//            var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
//            completionHandler = { (task, error) -> Void in
//                DispatchQueue.main.async(execute: {
//                    if error == nil {
//                        if let s3URL: URL = AWSS3.default().configuration.endpoint.url {
//                            let contentUrl = "\(s3URL.appendingPathComponent(AWSBUCKETCONST.AWSBUCKETNAME))"+"\("/")"+"\(task.key)"
//                            completion(contentUrl, nil)
//                            print("Uploaded to:\(String(describing: contentUrl))")
//                        }
//                      
//                        
//                    } else {
//                    }
//                })
//            }
//            
//            let awsTransferUtility = AWSS3TransferUtility.default()
//            awsTransferUtility.uploadFile(fileUrl, bucket: AWSBUCKETCONST.AWSBUCKETNAME, key: fileName, contentType: contenType, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
//                if let error = task.error {
//                    print("error is: \(error.localizedDescription)")
//                              }
//                if let _ = task.result {
//                    // your uploadTask
//                }
//                return nil
//            }
//        }
//    
//    
//    func uploadVideoOnS3(fileUrl: URL, completion : @escaping (_ urlString: String?, _ error: Error?) -> Void) {
//        let newKey = ProcessInfo.processInfo.globallyUniqueString + ".mov"
//        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
//        completionHandler = { (task, error) -> Void in
//            DispatchQueue.main.async(execute: {
//                if error == nil {
//                    if let s3URL: URL = AWSS3.default().configuration.endpoint.url {
//                        let videoUrl = "\(s3URL.appendingPathComponent(AWSBUCKETCONST.AWSBUCKETNAME))"+"\("/")"+"\(newKey)"
//                        completion(videoUrl, nil)
//                    }
//                } else {
//                    completion(nil, error)
//                }
//            })
//        }
//        let awsTransferUtility = AWSS3TransferUtility.default()
//        awsTransferUtility.uploadFile(fileUrl, bucket: AWSBUCKETCONST.AWSBUCKETNAME, key: newKey, contentType: "video/mp4", expression: AWSS3TransferUtilityUploadExpression(), completionHandler: completionHandler).continueWith { (task) -> Any? in
//            if let error = task.error {
//                print("error is: \(error.localizedDescription)")
//            }
//            if let uploadTask = task.result {
//                print("Upload started...\(uploadTask)")
//            }
//            return nil
//        }
//    }
//    
//    func getPreSignedURL( s3DownloadKeyName: String) -> String {
//        var preSignedURLString = ""
//            let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
//            getPreSignedURLRequest.httpMethod = AWSHTTPMethod.GET
//            getPreSignedURLRequest.key = s3DownloadKeyName
//            getPreSignedURLRequest.bucket = AWSBUCKETCONST.AWSBUCKETNAME
//            getPreSignedURLRequest.expires = Date(timeIntervalSinceNow: 3600)
//            AWSS3PreSignedURLBuilder.default().getPreSignedURL(getPreSignedURLRequest).continueWith { (task:AWSTask<NSURL>) -> Any? in
//                if let error = task.error as NSError? {
//                    print("Error: \(error)")
//                    return nil
//                }
//                preSignedURLString = (task.result?.absoluteString)!
//                return nil
//            }
//            return preSignedURLString
//        }
//    
//    func generateBoundary() -> String {
//            return "Boundary-\(NSUUID().uuidString)"
//        }
//        
//        func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
//            let lineBreak = "\r\n"
//            var body = Data()
//            if let parameters = params {
//                for (key, value) in parameters {
//                    if let data = value as? String {
//                    body.append("--\(boundary + lineBreak)")
//                    body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
//                    body.append("\(data + lineBreak)")
//                    }
//                }
//            }
//            if let media = media {
//                for photo in media {
//                    body.append("--\(boundary + lineBreak)")
//                    body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
//                    body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
//                    body.append(photo.data)
//                    body.append(lineBreak)
//                }
//            }
//            body.append("--\(boundary)--\(lineBreak)")
//            
//            return body
//        }
//    
//}

//extension Data {
//    mutating func append(_ string: String) {
//        if let data = string.data(using: .utf8) {
//            append(data)
//        }
//    }
//}

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "photo.jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}
