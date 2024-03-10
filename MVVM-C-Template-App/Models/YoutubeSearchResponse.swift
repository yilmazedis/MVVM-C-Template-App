//
//  YoutubeSearchResponse.swift
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

//
struct TitlePreviewViewModel {
    let title: String
    let youtubeView: VideoElement
    let titleOverview: String
}

//
struct TitleViewModel {
    let titleName: String
    let posterURL: String
}
