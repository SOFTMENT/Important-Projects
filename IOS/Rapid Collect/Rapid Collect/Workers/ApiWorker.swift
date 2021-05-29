//
//  ApiWorker.swift
//  CurrencyConversion
//
//  Created by Nguyen Dinh Cong on 2019/12/14.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import Foundation

protocol ApiTarget {
    associatedtype ResponseType: Decodable
    
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var params: [String: String] { get }
}

extension ApiTarget {
    var fullUrl: URL {
        let queries = params.map({ "\($0)=\($1)" }).joined(separator: "&")
        return URL(string: "\(scheme)://\(host)\(path)?\(queries)")!
    }
}

enum ApiError: Error {
    case undefined
    case invalidResponse
}

class ApiWorker {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func request<Target: ApiTarget>(target: Target, completion: @escaping (Result<Target.ResponseType, ApiError>) -> Void) {
        let request = URLRequest(
            url: target.fullUrl,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: AppConfig.apiTimeout)
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let responseData = try? jsonDecoder.decode(Target.ResponseType.self, from: data) {
                    DispatchQueue.main.async { completion(.success(responseData)) }
                    
                } else {
                    DispatchQueue.main.async { completion(.failure(.invalidResponse)) }
                }
            } else {
                DispatchQueue.main.async { completion(.failure(.undefined)) }
            }
        }
        
        task.resume()
    }
}
