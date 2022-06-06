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
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.tintColor = .black
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        backgroundColor = .white
        imageView.edgesToSuperview(insets: .left(10) + .top(10) + .right(10) + .bottom(10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(currentData: FullInfo) {
        imageView.image = currentData.image
        
    }
}
