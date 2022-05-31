//
//  HeaderCollectionView.swift
//  testApp
//
//  Created by imac44 on 26.05.2022.
//

import TinyConstraints

class HeaderCollectionView: UIView {
   
    let imageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "imageIcon")
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.tintColor = .black
        return img
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        backgroundColor = .white
        imageView.leftToSuperview()
        imageView.rightToSuperview()
        imageView.topToSuperview(offset: 10)
        imageView.bottomToSuperview(offset: -10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(currentData: Data) {
        imageView.image = UIImage(named: currentData.imageName)
    }
    
    
}
