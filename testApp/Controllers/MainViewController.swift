//
//  ViewController.swift
//  testApp
//
//  Created by imac44 on 24.05.2022.
//

import TinyConstraints
import Network
import UIKit

class MainViewController: UIViewController {
    // data
    private let cellIdentifier = "cell"
    private var data = DataAPI.shared.createFullInfo()
    private let monitor = NWPathMonitor()
    private var isPortrait = false
    // views
    var fullVC: FullScreenViewController!
    private let headerView = HeaderCollectionView()
    private let footerView = FooterCollectionView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    // constraints
    private enum LayoutConstant {
        static let spacing: CGFloat = 0
    }
    private var collectionViewBottom: Constraint!
    private var collectionViewTop: Constraint!
    private var collectionViewLeft: Constraint!
    private var collectionViewRight: Constraint!
    private var CVPortraitTop: Constraint!
    private var CVchangeBottom: Constraint!
    private var CVLandscapeLeft: Constraint!
    
    private var headerTop: Constraint!
    private var headerRight: Constraint!
    private var headerBottom: Constraint!
    private var headerLeft: Constraint!
    private var headerHeight: Constraint!
    private var headerWidth: Constraint!
    
    private var footerRight: Constraint!
    private var footerBottom: Constraint!
    private var footerLeft: Constraint!
    private var footerHeight: Constraint!
    private var FTLandscapeLeft: Constraint!
    
    private var portraitConstraints: Constraints!
    private var landscapeConstraints: Constraints!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main screen"
        setupViews()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                let alertController = UIAlertController(title: "Oops", message: "No Ethernet connection!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let orientation = self.view.window?.windowScene?.interfaceOrientation {
            if orientation == .portrait || orientation == .portraitUpsideDown {
                isPortrait = true
                changeOrientation()
            }
            if orientation == .landscapeLeft || orientation == .landscapeRight{
                isPortrait = false
                changeOrientation()
            }
        }
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            isPortrait = true
            changeOrientation()
        }
        if UIDevice.current.orientation.isLandscape {
            isPortrait = false
            changeOrientation()
        }
    }
    // MARK: - Helpers
    private func changeOrientation() {
        if isPortrait {
            headerBottom.isActive = false
            collectionViewTop.isActive = false
            CVLandscapeLeft.isActive = false
            FTLandscapeLeft.isActive = false
            headerWidth.isActive = false
            
            headerRight.isActive = true
            CVPortraitTop.isActive = true
            collectionViewLeft.isActive = true
            footerLeft.isActive = true
            headerHeight.isActive = true
            if headerWidth.constant != 0 {
                headerWidth.constant = 0
                headerHeight.constant = UIScreen.main.bounds.size.width * 0.3
                footerHeight.constant = UIScreen.main.bounds.size.width * 0.1
            }
            UIViewPropertyAnimator(duration: 0.75, dampingRatio: 1) {
                self.view.layoutIfNeeded()
            }.startAnimation()
        } else {
            headerRight.isActive = false
            CVPortraitTop.isActive = false
            collectionViewLeft.isActive = false
            footerLeft.isActive = false
            
            headerHeight.isActive = false
            headerWidth.isActive = true
            headerBottom.isActive = true
            collectionViewTop.isActive = true
            CVLandscapeLeft.isActive = true
            FTLandscapeLeft.isActive = true
            
            
            if headerHeight.constant != 0 {
                headerHeight.constant = 0
                headerWidth.constant = UIScreen.main.bounds.size.height * 0.3
                footerHeight.constant = UIScreen.main.bounds.size.height * 0.1
            }
            UIViewPropertyAnimator(duration: 0.75, dampingRatio: 1) {
                self.view.layoutIfNeeded()
            }.startAnimation()
        }
    }
    private func createHeadFoot() {
        if isPortrait {
            
            
            
            headerHeight.constant = UIScreen.main.bounds.size.height * 0.3
            footerHeight.constant = UIScreen.main.bounds.size.height * 0.1
            headerWidth.isActive = false
        } else {
            headerBottom.isActive = true
            headerRight.isActive = false
            CVPortraitTop.isActive = false
            collectionViewTop.isActive = true
            collectionViewLeft.isActive = false
            CVLandscapeLeft.isActive = true
            footerLeft.isActive = false
            FTLandscapeLeft.isActive = true
            headerWidth.constant = UIScreen.main.bounds.size.width * 0.3
            footerHeight.constant = UIScreen.main.bounds.size.width * 0.1
            headerWidth.isActive = true
            headerHeight.isActive = false
        }
        UIViewPropertyAnimator(duration: 0.75, dampingRatio: 1) {
            self.view.layoutIfNeeded()
        }.startAnimation()
        
    }
    private func deleteHedFoot() {
        if isPortrait {
            headerHeight.constant = 0
            footerHeight.constant = 0
        } else {
            headerBottom.isActive = false
            headerRight.isActive = true
            CVPortraitTop.isActive = true
            collectionViewTop.isActive = false
            collectionViewLeft.isActive = true
            CVLandscapeLeft.isActive = false
            footerLeft.isActive = true
            FTLandscapeLeft.isActive = false
            headerWidth.constant = 0
            footerHeight.constant = 0
            headerWidth.isActive = false
            headerHeight.isActive = true
        }
        UIViewPropertyAnimator(duration: 0.75, dampingRatio: 1) {
            self.view.layoutIfNeeded()
        }.startAnimation()
        
    }
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(collectionView)
        view.addSubview(footerView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        headerHeight = headerView.height(0)
        headerWidth = headerView.width(0, isActive: false)
        headerTop = headerView.topToSuperview(usingSafeArea: true)
        headerLeft = headerView.leftToSuperview(usingSafeArea: true)
        headerRight = headerView.rightToSuperview(usingSafeArea: true)
        headerBottom = headerView.bottomToSuperview(isActive: false, usingSafeArea: true)
        
        collectionViewTop = collectionView.topToSuperview(isActive: false)
        collectionViewLeft = collectionView.leftToSuperview(usingSafeArea: true)
        collectionViewRight = collectionView.rightToSuperview(usingSafeArea: true)
        collectionViewBottom = collectionView.bottomToTop(of: footerView)
        
        CVLandscapeLeft = collectionView.leftToRight(of: headerView, isActive: false)
        CVPortraitTop = collectionView.topToBottom(of: headerView)

        footerHeight = footerView.height(0)
        footerLeft = footerView.leftToSuperview(usingSafeArea: true)
        footerBottom = footerView.bottomToSuperview(usingSafeArea: true)
        footerRight = footerView.rightToSuperview(usingSafeArea: true)
        FTLandscapeLeft = footerView.leftToRight(of: headerView, isActive: false)
        
        portraitConstraints = [CVPortraitTop, collectionViewLeft, headerRight, footerLeft, headerHeight]
        landscapeConstraints = [collectionViewTop,  CVLandscapeLeft, headerBottom, FTLandscapeLeft, headerWidth]
        
    }
    
}

// MARK: - Extensions

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCollectionViewCell
        
        cell.update(data: data[indexPath.row], completion: { [weak self] result in
            self?.data[indexPath.row] = result
        })
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        var itemSize = 0.0
        if screenWidth < screenHeight {
            itemSize = (screenWidth - (6 * LayoutConstant.spacing)) / 3
        } else {
            itemSize = (screenHeight - (6 * LayoutConstant.spacing)) / 3
        }
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
        fullVC = FullScreenViewController(currentData: data[indexPath.row])
        let selectedCell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
            if selectedCell.contentView.backgroundColor == UIColor.gray {
                deleteHedFoot()
                selectedCell.contentView.backgroundColor = UIColor.clear
            } else {
                createHeadFoot()
                headerView.isUserInteractionEnabled = true
                headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
                selectedCell.contentView.backgroundColor = UIColor.gray
                footerView.update(data: data[indexPath.row])
                headerView.update(currentData: data[indexPath.row])
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cellToDeselect: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        cellToDeselect.contentView.backgroundColor = UIColor.clear
    }
    
    @objc func handleTap() {
        navigationController?.pushViewController(fullVC, animated: true)
    }
}
