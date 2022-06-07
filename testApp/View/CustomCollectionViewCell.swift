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
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        contentView.addSubview(image)
        image.edgesToSuperview(insets: .left(10) + .top(10) + .right(10) + .bottom(10))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        task.cancel()
//    }
    
    func update(data: FullInfo, completion: @escaping(FullInfo) -> ()) {
        var data = data
        image.image = data.image
        let downloadedImage = DataAPI.shared.loadImageFromDiskWith(fileName: data.imageName)
        if downloadedImage == nil {
            DataAPI.shared.downloadImage(data: data, completion: { [weak self] result in
                DispatchQueue.main.async {
                    self?.image.image = result.image
                    completion(result)
                }
            })
        } else {
            image.image = downloadedImage
            data.image = downloadedImage
            completion(data)
        }
        
    
        image.tintColor = .black
    }
}
