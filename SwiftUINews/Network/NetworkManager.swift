//
//  NetworkManager.swift
//
//
//  Created by Suraj Pathak
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import Foundation

/// Any network manager that conforms to this protocol can define how a network request can be handled
protocol NetworkProtocol {
    func request(_ queue: DispatchQueue?, request: NetworkRequest, success: @escaping ((Any) -> Void), failure: @escaping ((NetworkError) -> Void))
}

class NetworkManager {
    static let shared = NetworkManager()
}

extension NetworkManager: NetworkProtocol {
    
    internal func request(_ queue: DispatchQueue? = nil, request: NetworkRequest, success: @escaping ((Any) -> Void), failure: @escaping ((NetworkError) -> Void)) {
        var urlRequest = URLRequest(url: request.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        var headers = request.headers
        headers["content-type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
        let queueToExecute = queue ?? DispatchQueue.main
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let d = data, let json = try? JSONSerialization.jsonObject(with: d, options: []), let resp = response as? HTTPURLResponse else {
                queueToExecute.async { failure(.invalidError) }
                return
            }
            if resp.statusCode == 400 {
                queueToExecute.async { failure(.serverError) }
            } else if 200...299 ~= resp.statusCode {
                queueToExecute.async { success(json) }
            } else {
                queueToExecute.async { failure(.custom(message: "Unknown Error")) }
            }
        }
        
        task.resume()
    }

}
