//
//  dataAPI.swift
//  testApp
//
//  Created by imac44 on 24.05.2022.
//

import Foundation
import UIKit

class DataAPI {
    
    static let shared = DataAPI()
    
    private func fetchdata() -> [Info] {
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
    
    func createFullInfo() -> [FullInfo] {
        var fullInfos: [FullInfo] = []
        let infos = fetchdata()
        for info in infos {
            guard let image = UIImage(named: "imageIcon") else {
                return fullInfos
            }
            let fullInfo = FullInfo(imageName: info.imageName, lat: info.lat, long: info.long, url: info.url, image: image)
            fullInfos.append(fullInfo)
        }
        return fullInfos
    }
    
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(data: [FullInfo], completion: @escaping([FullInfo]) -> ()) {
        let group = DispatchGroup()
        
        var downloadedInfo = data
            for (index, datum) in data.enumerated() {
                group.enter()
                if let url = URL(string: datum.url) {
                    DispatchQueue.global(qos: .utility).async {
                    print("download started \(index)")
                    self.getData(from: url) { data, response, error in
                        guard let data = data, error == nil else {
                            print("download failed \(index)")
                            group.leave()
                            return
                        }
                        print("download finished \(index)")
                        downloadedInfo[index].image = UIImage(data: data)
                        group.leave()
                        
                    }
                }
            }
        }
        group.notify(queue: .global(qos: .utility)) {
            completion(downloadedInfo)
        }
            
    }
}
