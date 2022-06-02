//
//  ViewController.swift
//  testApp
//
//  Created by imac44 on 24.05.2022.
//

import TinyConstraints

class MainViewController: UIViewController {
    
    
    // data
    private let cellIdentifier = "cell"
    private var data = DataAPI.shared.createFullInfo()
    
    
    // views
    private let bigImageView = HeaderCollectionView()
    private let footerView = FooterCollectionView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    // constraints
    private enum LayoutConstant {
        static let spacing: CGFloat = 10
    }
    private var collectionViewBottomFirst: Constraint!
    private var collectionViewTopFirst: Constraint!
    
    private var collectionViewTopSecond: Constraint!
    private var collectionViewBottomSecond: Constraint!
    private var collectionViewLeft: Constraint!
    private var collectionViewRight: Constraint!
    
    private var bigImageEdges: Constraints!
    private var footerEdges: Constraints!
    
    private var headerHeight: Constraint!
    private var footerHeight: Constraint!
    
//    private var portraitConstraints: Constraints!
//    private var landscapeConstraints: Constraints!
//
//    private var CVLandscapeTop: Constraint!
//    private var CVLandscapeBottom: Constraint!
//
//
//    private var CVLandscapeLeft: Constraint!
//    private var CVLandscapeRight: Constraint!
//    private var CVLandscapeLeftSecond: Constraint!
//
//    private var BILandscapeEdges: Constraints!
//    private var FTLandscapeEdges: Constraints!
//    private var FTLandscapeLeft: Constraint!
//
//    private var BILandscapewidth: Constraint!
//    private var FTHeight: Constraint!
//    private var FTLandscapeLeftSecond: Constraint!
    
//    func update(data: [FullInfo]) {
//        self.data = data
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        DataAPI.shared.downloadImage(data: data, completion: { [weak self] result in
            
            DispatchQueue.main.async {
                let download = result
                self?.data = download
                self?.collectionView.reloadData()
            }
        })
    }
    
    //landscape mode
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        if let interfaceOrientation = UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.windowScene?.interfaceOrientation {
//            switch interfaceOrientation {
//            case .portrait:
//                fallthrough
//            case .portraitUpsideDown:
//                landscapeConstraints.deActivate()
//                portraitConstraints.activate()
//                break
//            case .landscapeLeft:
//                fallthrough
//            case .landscapeRight:
//                portraitConstraints.deActivate()
//                landscapeConstraints.activate()
//                break
//            case .unknown:
//                fallthrough
//            @unknown default:
//                print("unknown orientation")
//                break
//            }
//        }
//    }
    // MARK: - Helpers
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionViewTopFirst = collectionView.top(to: view.safeAreaLayoutGuide)
        collectionViewLeft = collectionView.leftToSuperview()
        collectionViewRight = collectionView.rightToSuperview()
        collectionViewBottomFirst = collectionView.bottom(to: view.safeAreaLayoutGuide)
        
        collectionViewTopSecond = collectionView.topToBottom(of: bigImageView, isActive: false)
        collectionViewBottomSecond = collectionView.bottomToTop(of: footerView, isActive: false)
        
        headerHeight = bigImageView.height(0)
        footerHeight = footerView.height(0)
        
//        portraitConstraints = [collectionViewBottomFirst, collectionViewTopFirst, collectionViewTopSecond, collectionViewBottomSecond, collectionViewLeft, collectionViewRight, headerHeight, footerHeight]
        
//        CVLandscapeTop = collectionView.top(to: view.safeAreaLayoutGuide)
//        CVLandscapeBottom = collectionView.bottom(to: view.safeAreaLayoutGuide)
//        CVLandscapeLeft = collectionView.leftToSuperview()
//        CVLandscapeRight = collectionView.rightToSuperview()
//        CVLandscapeLeftSecond = collectionView.leftToRight(of: bigImageView)
//
//        BILandscapewidth = bigImageView.width(0)
//        FTHeight = footerView.height(0)
//
//        landscapeConstraints = [CVLandscapeTop, CVLandscapeBottom, CVLandscapeLeft, CVLandscapeRight, CVLandscapeLeftSecond, BILandscapewidth, FTHeight]
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
            
            headerHeight.constant = 0
            footerHeight.constant = 0
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
            
            bigImageEdges = bigImageView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
            footerEdges = footerView.edgesToSuperview(excluding: .top, usingSafeArea: true)
            
//            portraitConstraints.append(contentsOf: bigImageEdges)
//            portraitConstraints.append(contentsOf: footerEdges)
            
            selectedCell.contentView.backgroundColor = UIColor.gray
            self.headerHeight.constant = UIScreen.main.bounds.size.height * 0.3
            self.footerHeight.constant = UIScreen.main.bounds.size.height * 0.1
            UIViewPropertyAnimator(duration: 0.75, dampingRatio: 1) {
                self.view.layoutIfNeeded()
            }.startAnimation()
            footerView.update(data: data[indexPath.row])
            bigImageView.update(currentData: data[indexPath.row])
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cellToDeselect: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        cellToDeselect.contentView.backgroundColor = UIColor.clear
    }
    
    @objc func handleTap() {
        let fullVC = FullScreenViewController(currentData: data[1])
        present(fullVC, animated: true, completion: nil)
    }
}
