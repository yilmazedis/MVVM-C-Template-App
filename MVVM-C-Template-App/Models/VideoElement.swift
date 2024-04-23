//
//  VideoElement.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}