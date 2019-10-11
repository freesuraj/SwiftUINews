//
//  Article.swift
//
//
//  Created by Suraj Pathak
//  Copyright © 2016 Suraj Pathak. All rights reserved.
//

import Foundation

final class NewsList: ObservableObject {
	@Published var articles: [Article] = []
}

struct Article: Identifiable {
    let id: String
    let date: Date
    let byLine: String
    let tags: [String]
    let headline: String
    let abstract: String
    let url: String
    let relatedImageUrl: String?
    let thumbnail: String?
	
	static var test: Article {
		return Article(id: "test", date: Date(), byLine: "byline", tags: ["tag1", "tag2"], headline: "Article Headline Goes Here", abstract: "Abstract Goes Here", url: "https://example.com", relatedImageUrl: nil, thumbnail: nil)
	}
}

extension Article {
    
    init?(raw: [String: Any]) {
        guard let id = raw["guid"] as? String,
            let pubDate = raw["pubDate"] as? String,
            let byLine = raw["author"] as? String,
            let headline = raw["title"] as? String,
            let abstract = raw["description"] as? String,
            let url = raw["link"] as? String else { return nil }
        
        self.thumbnail = raw["thumbnail"] as? String
        if let enclosure = raw["enclosure"] as? [String: String], let enclosureLink = enclosure["link"] {
            relatedImageUrl = enclosureLink
        } else {
            relatedImageUrl = nil
        }
        self.id = id
        self.date = pubDate.date()
        self.byLine = byLine
        self.headline = headline
        self.abstract = abstract
        self.url = url
        
        // Makes an array of category names from category object array
        if let categories = raw["categories"] as? [String] {
            tags = categories
        } else {
            tags = []
        }
    }
    
}
