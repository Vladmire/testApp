//
//  ViewController.swift
//  testApp
//
//  Created by imac44 on 24.05.2022.
//

import TinyConstraints

class MainViewController: UIViewController {
    
    private enum LayoutConstant {
        static let spacing: CGFloat = 10
    }
    private let bigImageView = HeaderCollectionView()
    private let footerView = FooterCollectionView()
    
    private let cellIdentifier = "cell"
    private let data = DataAPI.fetchdata()
    
    private var headerHeight: NSLayoutConstraint!
    private var footerHeight: NSLayoutConstraint!
  

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    // MARK: - Helpers

    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(bigImageView)
        view.addSubview(footerView)
        
        bigImageView.top(to: view.safeAreaLayoutGuide)
        bigImageView.leftToSuperview()
        bigImageView.rightToSuperview()
        headerHeight = bigImageView.height(0)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.topToBottom(of: bigImageView)
        collectionView.leftToSuperview()
        collectionView.rightToSuperview()
        collectionView.bottomToTop(of: footerView)
        
        footerView.bottom(to: view.safeAreaLayoutGuide)
        footerView.leftToSuperview()
        footerView.rightToSuperview()
        footerHeight = footerView.height(0)
        
        
    }
    
//    private func updateHeights(headerHeight: CGFloat, footerHeight: CGFloat) -> NSLayoutConstraint {
//        let headerHeight = bigImageView.height(0)
//        headerHeight.constant = UIScreen.main.bounds.size.height * 0.3
//
//        return headerHeight
//    }
}


extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCollectionViewCell
        cell.update(data: data[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let itemSize = (screenWidth - (6 * LayoutConstant.spacing)) / 3
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: LayoutConstant.spacing , left: LayoutConstant.spacing, bottom: LayoutConstant.spacing, right: LayoutConstant.spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select item")
        
        headerHeight.constant = UIScreen.main.bounds.size.height * 0.3
        footerHeight.constant = UIScreen.main.bounds.size.height * 0.1
        footerView.update(data: data[indexPath.row])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        headerHeight.constant = 0
        footerHeight.constant = 0
    }
}

