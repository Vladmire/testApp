//
//  FooterCollectionView.swift
//  testApp
//
//  Created by imac44 on 26.05.2022.
//

import TinyConstraints

class FooterCollectionView: UIView {

    let imageTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    let lang: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let long: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageTitle)
        addSubview(lang)
        addSubview(long)
        backgroundColor = .white
        imageTitle.topToSuperview(offset: 15)
        imageTitle.leftToSuperview(offset: 15)
        
        lang.topToBottom(of: imageTitle, offset: 15)
        lang.leftToSuperview(offset: 15)
        lang.bottomToSuperview(offset: -15)
        
        long.topToBottom(of: imageTitle, offset: 15)
        long.leftToRight(of: lang, offset: 15)
        long.bottomToSuperview(offset: -15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(data: FullInfo) {
        imageTitle.text = data.imageName
        let latText = NSLocalizedString("latitude", comment: "")
        let longText = NSLocalizedString("longitude", comment: "")
        lang.text = "\(latText): \(String(data.lat))"
        long.text = "\(longText): \(String(data.long))"
    }
}
