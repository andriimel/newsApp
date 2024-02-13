//
//  NewsManager.swift
//  NewsApp
//
//  Created by Andrii Melnyk on 1/29/24.
//

import UIKit
import Foundation
import Alamofire
import CoreData


class NewsManager {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var favoriteArray = [String]()
    var news:[News]?
    let myAPIkey = "de95bb98581645e39e35356ad155a46d"
    
    var articles: [Article] = []
    
    
    // MARK: - Alamofire method to get data from JSON
    
    func getApiData(forCategory category: String, handler:@escaping (_ apiData: [Article]) -> (Void)) {
        
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&category=\(category)&apiKey=\(myAPIkey)"
        print(urlString)
        AF.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            resp in
            switch resp.result {
            case .success(let data):
                do{
                    let jsonData = try JSONDecoder().decode(Response.self, from: data!)
                    self.articles += jsonData.articles
                    handler(self.articles)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
