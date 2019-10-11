//
//  URLImage.swift
//  SwiftUINews
//
//  Created by Suraj Pathak on 11/10/19.
//  Copyright © 2019 Laohan. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct URLImage: View {
	
	@ObservedObject var remoteImageUrl: RemoteImageURL
	
	init(_ imageUrl: String) {
		remoteImageUrl = RemoteImageURL(url: imageUrl)
	}
	
	var body: some View {
		return Image(uiImage: remoteImageUrl.image ?? UIImage())
	}
}

class RemoteImageURL: ObservableObject {
	
	@Published var image: UIImage?

	init(url: String) {
		DispatchQueue(label: "com.image.news").async {
			guard let url = URL(string: url),
				let data = try? Data(contentsOf: url) else {
					return
			}
			DispatchQueue.main.async {
				self.image = UIImage(data: data)
			}
		}
	}
	
}
