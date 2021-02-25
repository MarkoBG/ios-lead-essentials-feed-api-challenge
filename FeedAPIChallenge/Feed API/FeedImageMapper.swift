//
//  FeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Marko Tribl on 2/25/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

internal class FeedImageMapper {
	private struct Root: Decodable {
		var items: [Item]
		
		var feed: [FeedImage] {
			return items.map { $0.feedImage }
		}
	}
	
	private struct Item: Decodable {
		let id: UUID
		let description: String?
		let location: String?
		let imageURL: URL
		
		enum CodingKeys: String, CodingKey {
			case id = "image_id"
			case description = "image_desc"
			case location = "image_loc"
			case imageURL = "image_url"
		}
		
		var feedImage: FeedImage {
			return FeedImage(id: id, description: description, location: location, url: imageURL)
		}
	}
	
	internal static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
		if let root = try? JSONDecoder().decode(Root.self, from: data), response.statusCode  == 200 {
			return .success(root.feed)
		} else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}
	}
}
