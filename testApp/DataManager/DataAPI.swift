//
//  dataAPI.swift
//  testApp
//
//  Created by imac44 on 24.05.2022.
//

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
    
    func downloadImage(data: FullInfo, completion: @escaping(FullInfo) -> ()) {
        var downloadedInfo = data
        if let url = URL(string: data.url) {
            DispatchQueue.global(qos: .utility).async {
            print("download started")
            self.getData(from: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("download failed")
                    return
                }
                print("download finished")
                guard let image = UIImage(data: data) else { return }
                
                downloadedInfo.image = image
                self.saveImage(imageName: downloadedInfo.imageName, image: image)
                completion(downloadedInfo)
                
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func saveImage(imageName: String, image: UIImage) {
        guard let documentDirecory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileName = imageName
        let fileURL = documentDirecory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else {
            return
        }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func imagePath(fileName: String) -> URL? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            return imageURL
        }
        return nil
    }
}
