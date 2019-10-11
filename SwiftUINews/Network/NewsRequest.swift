//
//Request.swift
//
//
//  Created by Suraj Pathak
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import Foundation

// NewsRequest represent a network request to fetch a list of selected news
struct NewsRequest: NetworkRequest {
    
    let url: URL
    var method: HttpMethod = .get
    var body: Data?
    var headers: [String: String] = [:]
    
    init?(urlString: String) {
        guard let url = URL(string: urlString) else { return nil }
        self.url = url
    }
    
}

struct NewsParser {
    
    static func parsed(_ json: Any) -> [Article] {
        guard let response = json as? [String: Any],
            let assests = response["items"] as? [[String: Any]] else {
                return []
        }
        return assests.compactMap { return Article(raw: $0) }
    }
    
}

extension NewsRequest {
    
    typealias NewsFetchBlock = (([Article]) -> Void)
    
    func send(_ completion: @escaping NewsFetchBlock) {
        NetworkManager.shared.request(request: self, success: { json in
            completion(NewsParser.parsed(json))
        }, failure: { _ in
            completion([])
        })
    }
    
}
