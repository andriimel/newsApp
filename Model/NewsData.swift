//
//  NewsData.swift
//  NewsApp
//
//  Created by Andrii Melnyk on 1/29/24.
//

import Foundation


struct Response : Decodable {
    
    var articles : [Article]
}

struct Article : Decodable {
    var source: Source
    var title: String?
    var url: URL?
    var urlToImage: String?
    var publishedAt: String?
    
}
struct Source : Decodable{
    var id:String?
    var name: String
    
}

