//
//  VideoElement.swift
//  MVVM-C-Template-App
//
//  Created by yilmaz on 10.03.2024.
//

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable, DummyProtocol {
    let id: IdVideoElement
    
    static func firstIfNilDummy() -> VideoElement {
        VideoElement(id: IdVideoElement(kind: "", videoId: "8oXW11PuB0c"))
    }
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
