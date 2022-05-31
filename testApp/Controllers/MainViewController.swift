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
    
    private var collectionViewBottomFirst: NSLayoutConstraint!
    private var collectionViewTopFirst: NSLayoutConstraint!
    
    private var collectionViewTopSecond: NSLayoutConstraint!
    private var collectionViewBottomSecond: NSLayoutConstraint!
    
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionViewTopFirst = collectionView.top(to: view.safeAreaLayoutGuide)
        collectionView.leftToSuperview()
        collectionView.rightToSuperview()
        collectionViewBottomFirst = collectionView.bottom(to: view.safeAreaLayoutGuide)
        
        collectionViewTopSecond = collectionView.topToBottom(of: bigImageView, isActive: false)
        collectionViewBottomSecond = collectionView.bottomToTop(of: footerView, isActive: false)
        
        headerHeight = bigImageView.height(0)
        footerHeight = footerView.height(0)
    }
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
        print("did select item at \(indexPath)")
        
        let selectedCell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        if selectedCell.contentView.backgroundColor == UIColor.gray {
            selectedCell.contentView.backgroundColor = UIColor.clear
            
            headerHeight.constant = 20
            footerHeight.constant = 20
            UIViewPropertyAnimator(duration: 0.75, dampingRatio: 1) {
                self.view.layoutIfNeeded()
            }.startAnimation()
            
            collectionViewTopSecond.isActive = false
            collectionViewBottomSecond.isActive = false
            
            collectionViewTopFirst.isActive = true
            collectionViewBottomFirst.isActive = true
            bigImageView.removeFromSuperview()
            footerView.removeFromSuperview()
        } else {
            
            view.addSubview(bigImageView)
            view.addSubview(footerView)
            
            bigImageView.isUserInteractionEnabled = true
            bigImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
            
            collectionViewTopFirst.isActive = false
            collectionViewBottomFirst.isActive = false
            
            collectionViewTopSecond.isActive = true
            collectionViewBottomSecond.isActive = true
            
            bigImageView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
            footerView.edgesToSuperview(excluding: .top, usingSafeArea: true)
            
            selectedCell.contentView.backgroundColor = UIColor.gray
            self.headerHeight.constant = UIScreen.main.bounds.size.height * 0.3
            self.footerHeight.constant = UIScreen.main.bounds.size.height * 0.1
            UIViewPropertyAnimator(duration: 0.75, dampingRatio: 1) {
                self.view.layoutIfNeeded()
            }.startAnimation()
            footerView.update(data: data[indexPath.row])
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cellToDeselect: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        cellToDeselect.contentView.backgroundColor = UIColor.clear
        
        
    }
    
    @objc func handleTap() {
        print("hello world!")
    }
}
