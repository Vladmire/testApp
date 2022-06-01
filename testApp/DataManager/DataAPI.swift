//
//  dataAPI.swift
//  testApp
//
//  Created by imac44 on 24.05.2022.
//

import Foundation
import UIKit

class DataAPI {
    
    static func fetchdata() -> [Info] {
        var data: [Info] = []
        let fileName = "imageData"
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                guard let jsonData = try String(contentsOfFile: path).data(using: .utf8) else {
                    print("can't read the file")
                    return data
                }
                let decoder = JSONDecoder()
                data = try decoder.decode([Info].self, from: jsonData)
            } catch {
                print("error \(error)")
            }
        }
        return data
    }
    
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: String) {
        print("download started")
        guard let url = URL(string: url) else {
            return
        }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
//            DispatchQueue.main.async() { [weak self] in
//                self?.imageView.image = UIImage(data: data)
//            }
        }
    }
    
    
}
