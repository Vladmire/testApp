//
//  CustomCollectionViewCell.swift
//  testApp
//
//  Created by imac44 on 25.05.2022.
//

import TinyConstraints

class CustomCollectionViewCell: UICollectionViewCell {
    
    let image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        contentView.addSubview(image)
        image.edgesToSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(data: FullInfo) {
        image.image = data.image
        image.tintColor = .black
    }
}
