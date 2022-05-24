//
//  ViewController.swift
//  testApp
//
//  Created by imac44 on 24.05.2022.
//

import TinyConstraints

class MainViewController: UIViewController {
    
    private let reuseIdentifier = "cell"
    private let collectionView: UICollectionView = {
        let collection = UICollectionView()
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.edgesToSuperview()
    }

//    func configureDataSource() {
//        let dataSource = UICollectionViewDiffableDataSource<Data
//    }
}

