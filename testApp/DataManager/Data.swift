//
//  Data.swift
//  testApp
//
//  Created by imac44 on 24.05.2022.
//

import Foundation
import UIKit

struct Info: Decodable, Hashable {
    let imageName: String
    let lat: Float
    let long: Float
    let url: String
}

struct FullInfo: Hashable {
    let imageName: String
    let lat: Float
    let long: Float
    let url: String
    var image: UIImage?
}
