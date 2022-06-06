//
//  ViewController.swift
//  testApp
//
//  Created by imac44 on 24.05.2022.
//

import TinyConstraints
import Network

class MainViewController: UIViewController {
    // data
    private let cellIdentifier = "cell"
    private var data = DataAPI.shared.createFullInfo()
    private let monitor = NWPathMonitor()
    private var isPortrait = true
    // views
    var fullVC: FullScreenViewController!
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
        static let spacing: CGFloat = 0
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

    private var portraitConstraints: Constraints!
    private var landscapeConstraints: Constraints!

    private var CVLandscapeTop: Constraint!
    private var CVLandscapeBottom: Constraint!
    private var CVLandscapeBottomSecond: Constraint!
    
    private var CVLandscapeLeft: Constraint!
    private var CVLandscapeRight: Constraint!
    private var CVLandscapeLeftSecond: Constraint!

    private var BILandscapeEdges: Constraints!
    private var FTLandscapeTop: Constraint!
    private var FTLandscapeRight: Constraint!
    private var FTLandscapeLeft: Constraint!
    private var FTLandscapeBottom: Constraint!

    private var BILandscapewidth: Constraint!
    private var FTHeight: Constraint!
    private var FTLandscapeLeftSecond: Constraint!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        title = "Main screen"
        
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
    
    //landscape mode
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if let interfaceOrientation = UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.windowScene?.interfaceOrientation {
            switch interfaceOrientation {
            case .portrait:
                fallthrough
            case .portraitUpsideDown:
                isPortrait = true
                break
            case .landscapeLeft:
                fallthrough
            case .landscapeRight:
                isPortrait = false
                break
            case .unknown:
                fallthrough
            @unknown default:
                print("unknown orientation")
                break
            }
        }
    }
    
    // MARK: - Helpers
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        //portrait
        collectionViewTopFirst = collectionView.topToSuperview(usingSafeArea: true)
        collectionViewLeft = collectionView.leftToSuperview()
        collectionViewRight = collectionView.rightToSuperview()
        collectionViewBottomFirst = collectionView.bottomToSuperview(usingSafeArea: true)

        collectionViewTopSecond = collectionView.topToBottom(of: bigImageView, isActive: false)
        collectionViewBottomSecond = collectionView.bottomToTop(of: footerView, isActive: false)

        headerHeight = bigImageView.height(0)
        footerHeight = footerView.height(0)

        portraitConstraints = [collectionViewBottomFirst, collectionViewTopFirst, collectionViewLeft, collectionViewRight, headerHeight, footerHeight]
        
        //landscape
        CVLandscapeTop = collectionView.topToSuperview(usingSafeArea: true)
        CVLandscapeBottom = collectionView.bottomToSuperview(usingSafeArea: true)
        CVLandscapeLeft = collectionView.leftToSuperview(usingSafeArea: true)
        CVLandscapeRight = collectionView.rightToSuperview(usingSafeArea: true)
        
        BILandscapewidth = bigImageView.width(0)
        FTHeight = footerView.height(0)
        CVLandscapeLeftSecond = collectionView.leftToRight(of: bigImageView, isActive: false)
        CVLandscapeBottomSecond = collectionView.bottomToTop(of: footerView, isActive:  false)
        FTLandscapeLeft = footerView.leftToRight(of: bigImageView, isActive: false)
        
        landscapeConstraints = [CVLandscapeTop, CVLandscapeBottom, CVLandscapeLeft, CVLandscapeRight, BILandscapewidth, FTHeight]
        landscapeConstraints.deActivate()
        
        
    }
    
}


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
        
        if isPortrait { // не видит ориентацию смартфона
            portraitConstraints.activate()
            landscapeConstraints.deActivate()
            CVLandscapeLeftSecond.isActive = false
            CVLandscapeBottomSecond.isActive = false
            FTLandscapeLeft.isActive = false
            
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
                    portraitConstraints.append(contentsOf: bigImageEdges)
                    portraitConstraints.append(contentsOf: footerEdges)
                    headerHeight.constant = UIScreen.main.bounds.size.height * 0.3
                    footerHeight.constant = UIScreen.main.bounds.size.height * 0.1
                    selectedCell.contentView.backgroundColor = UIColor.gray
                    UIViewPropertyAnimator(duration: 0.75, dampingRatio: 1) {
                        self.view.layoutIfNeeded()
                    }.startAnimation()
                    footerView.update(data: data[indexPath.row])
                    bigImageView.update(currentData: data[indexPath.row])
                }
        } else {
            landscapeConstraints.activate()
            portraitConstraints.deActivate()
            collectionViewTopSecond.isActive = false
            collectionViewBottomSecond.isActive = false
            
                if selectedCell.contentView.backgroundColor == UIColor.gray {
                    selectedCell.contentView.backgroundColor = UIColor.clear
                    BILandscapewidth.constant = 0
                    FTHeight.constant = 0
                    UIViewPropertyAnimator(duration: 0.75, dampingRatio: 1) {
                        self.view.layoutIfNeeded()
                    }.startAnimation()
                    CVLandscapeLeftSecond.isActive = false
                    CVLandscapeLeft.isActive = true
                    CVLandscapeBottomSecond.isActive = false
                    CVLandscapeBottom.isActive = true
                    bigImageView.removeFromSuperview()
                    footerView.removeFromSuperview()
                } else {
                    view.addSubview(bigImageView)
                    view.addSubview(footerView)
                    bigImageView.isUserInteractionEnabled = true
                    bigImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
                    BILandscapeEdges = bigImageView.edgesToSuperview(excluding: .right, usingSafeArea: true)
                    FTLandscapeRight = footerView.rightToSuperview(usingSafeArea: true)
                    FTLandscapeBottom = footerView.bottomToSuperview(usingSafeArea: true)
                    FTLandscapeLeft.isActive = true
                    CVLandscapeLeftSecond.isActive = true
                    CVLandscapeLeft.isActive = false
                    CVLandscapeBottomSecond.isActive = true
                    CVLandscapeBottom.isActive = false
                    selectedCell.contentView.backgroundColor = UIColor.gray
                    landscapeConstraints.append(contentsOf: BILandscapeEdges)
                    landscapeConstraints.append(FTLandscapeRight)
                    landscapeConstraints.append(FTLandscapeBottom)
                    BILandscapewidth.constant = UIScreen.main.bounds.size.width * 0.3
                    FTHeight.constant = UIScreen.main.bounds.size.width * 0.1
                    UIViewPropertyAnimator(duration: 0.75, dampingRatio: 1) {
                        self.view.layoutIfNeeded()
                    }.startAnimation()
                    footerView.update(data: data[indexPath.row])
                    bigImageView.update(currentData: data[indexPath.row])
                }
                
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
