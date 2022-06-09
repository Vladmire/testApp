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
    private var initHeadFootPort: Constraints!
    private var initHeadFootLand: Constraints!
    
    // MARK: - Helpers
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Main screen", comment: "")
        setupViews()
        checkConnection()
    }
    
    private func checkConnection(){
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                let alertController = UIAlertController(title: NSLocalizedString("Oops", comment: ""), message: NSLocalizedString("No Ethernet connection!",
                    comment: ""), preferredStyle: .alert)
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
            }
            if orientation == .landscapeLeft || orientation == .landscapeRight{
                isPortrait = false
            }
        }
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.verticalSizeClass == .regular {
            isPortrait = true
            if CVLandscapeLeft.isActive {
                landscapeConstraints.deActivate()
                portraitConstraints.activate()
            }
        }
        if traitCollection.verticalSizeClass == .compact {
            isPortrait = false
            if CVPortraitTop.isActive {
                portraitConstraints.deActivate()
                landscapeConstraints.activate()
            }
        }
    }

    private func createHeadFoot() {
        if isPortrait {
            collectionViewTop.isActive = false
            collectionViewBottom.isActive = false
            
            headerWidth.constant = UIScreen.main.bounds.size.height * 0.3
            headerHeight.constant = UIScreen.main.bounds.size.height * 0.3
            footerHeight.constant = UIScreen.main.bounds.size.height * 0.1
    
            initHeadFootPort.activate()
            
            headerView.isHidden = false
            footerView.isHidden = false
        } else {
            headerView.isHidden = false
            footerView.isHidden = false
            
            collectionViewLeft.isActive = false
            collectionViewBottom.isActive = false
            headerRight.isActive  = false
            footerLeft.isActive  = false
            
            headerHeight.constant = UIScreen.main.bounds.size.width * 0.3
            headerWidth.constant = UIScreen.main.bounds.size.width * 0.3
            footerHeight.constant = UIScreen.main.bounds.size.width * 0.1
            
            initHeadFootLand.activate()
        }
        UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) {
            self.view.layoutIfNeeded()
        }.startAnimation()
    }
    
    private func deleteHedFoot() {
        if isPortrait {
            headerWidth.isActive = false
            initHeadFootPort.deActivate()
            
            headerView.isHidden = true
            footerView.isHidden = true
            collectionViewTop.isActive = true
            collectionViewBottom.isActive = true
            
        } else {
            headerHeight.isActive = false
            initHeadFootLand.deActivate()
            
            headerView.isHidden = true
            footerView.isHidden = true
            collectionViewLeft.isActive = true
            collectionViewBottom.isActive = true
            headerRight.isActive  = true
            footerLeft.isActive  = true
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
        
        headerView.isHidden = true
        footerView.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        headerHeight = headerView.height(100, isActive: false)
        headerWidth = headerView.width(100, isActive: false)
        footerHeight = footerView.height(100, isActive: false)
    
        headerTop = headerView.topToSuperview(usingSafeArea: true)
        headerLeft = headerView.leftToSuperview(usingSafeArea: true)
        headerRight = headerView.rightToSuperview(usingSafeArea: true)
        headerBottom = headerView.bottomToSuperview(isActive: false, usingSafeArea: true)
    
        collectionViewTop = collectionView.topToSuperview(usingSafeArea: true)
        collectionViewLeft = collectionView.leftToSuperview(usingSafeArea: true)
        collectionViewRight = collectionView.rightToSuperview(usingSafeArea: true)
        collectionViewBottom = collectionView.bottomToSuperview(usingSafeArea: true)
        
        CVchangeBottom = collectionView.bottomToTop(of: footerView, isActive: false)
        CVLandscapeLeft = collectionView.leftToRight(of: headerView, isActive: false)
        CVPortraitTop = collectionView.topToBottom(of: headerView, isActive: false)

        footerLeft = footerView.leftToSuperview(usingSafeArea: true)
        footerBottom = footerView.bottomToSuperview(usingSafeArea: true)
        footerRight = footerView.rightToSuperview(usingSafeArea: true)
        FTLandscapeLeft = footerView.leftToRight(of: headerView, isActive: false)
        
        initHeadFootPort = [headerHeight, footerHeight, CVPortraitTop, CVchangeBottom]
        initHeadFootLand = [headerBottom, headerWidth, CVchangeBottom, footerHeight, CVLandscapeLeft, FTLandscapeLeft]
        
        portraitConstraints = [headerRight, CVPortraitTop, collectionViewLeft, footerLeft, headerHeight]
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
