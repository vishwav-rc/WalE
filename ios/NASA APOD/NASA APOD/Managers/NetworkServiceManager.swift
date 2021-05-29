//
//  NetworkServiceManager.swift
//  NASA APOD
//
//  Created by Vishwanath Vallamkondi on 29/05/21.
//

import Foundation

typealias RequestCompletionBlock = (_ status:Bool, _ error:Error?, _ statusCode:Int, _ data:Data?) -> Void
typealias APODRequestCompletionBlock = (APOD?, AppError?) -> Void

class NetworkServiceManager {
    static let shared = NetworkServiceManager()
    
    private init() {
        
    }
    
    enum RequestMethod:String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
    
    private func performRequest(method:RequestMethod, endURL:EndURL, parameters:[String:Any]?, completionBlock:@escaping RequestCompletionBlock) {
        let url = baseURL + endURL.rawValue + apiKey
        
        AppLog(message: "requestUrl-\(url)")

        let headers = [
          "Content-Type": "application/json",
        ]

        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if (method == .post || method == .put), let params = parameters {
            let postData = try? JSONSerialization.data(withJSONObject: params, options: [])
            AppLog(message: "Post Data-\(postData != nil)")
            request.httpBody = postData
        }


        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: {  (data, response, error) -> Void in
            if let error = error {
                AppLog(message: "error-\(error.localizedDescription)")
                completionBlock(false, error, 0, nil)
             } else {
                if let data = data, let urlResponse = response as? HTTPURLResponse {
                    let response = String.init(data: data, encoding: .utf8)
                    AppLog(message: "Status Code:\(urlResponse.statusCode) Response:\(String(describing: response))")
                    completionBlock(true, nil, urlResponse.statusCode, data)
                } else {
                    completionBlock(false, error, 0, nil)
                }
            }
        })

        dataTask.resume()
    }
    
    private func _getPictureOfTheDay(block:APODRequestCompletionBlock?) {
        self.performRequest(method: .get, endURL: .apod, parameters: nil) { (result, error, statusCode, data) in
            guard result, statusCode == 200, let data = data else {
                block?(nil, .notFound)
                return
            }
            do {
                let apod = try JSONDecoder().decode(APOD.self, from: data)
                block?(apod, nil)
            } catch {
                block?(nil, .parseError)
                return
            }
        }
    }
}

extension NetworkServiceManager {
    public func getPictureOfTheDay(block:APODRequestCompletionBlock?) {
        DispatchQueue.global(qos: .userInitiated).async {
            self._getPictureOfTheDay { (apod, error) in
                block?(apod, error)
            }
        }
    }
}
