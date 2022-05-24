//
//  Data.swift
//  testApp
//
//  Created by imac44 on 24.05.2022.
//

import Foundation

struct Data: Decodable, Hashable {
    let imageName: String
    let lat: Float
    let long: Float
    let url: String
}
