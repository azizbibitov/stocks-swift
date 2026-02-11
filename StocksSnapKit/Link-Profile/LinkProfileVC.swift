//
//  LinkProfileVC.swift
//  StocksSnapKit
//
//  Created by Aziz Bibitov on 16/01/2026.
//

import UIKit
import EasyPeasy

class LinkProfileVC: UIViewController, postsDidScrollDelegate {
    
    private let userPostsViewController1 = UserPostsViewController(color: .systemRed)
    private let userPostsViewController2 = UserPostsViewController(color: .systemBlue)
    
    var mainView: LinkProfileView {
        return view as! LinkProfileView
    }
    
    override func loadView() {
        super.loadView()
        view = LinkProfileView()
    }
    
    
    var parentCollection: UICollectionView?
    var childCollection: UICollectionView?
    
    private let filterView = HorizontalFilterView()

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        userPostsViewController1.collectionView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))

        parentCollection = mainView.collectionView
        childCollection = userPostsViewController1.collectionView

        filterView.filters = ["All", "Gainers", "Losers", "Tech", "Finance", "Energy"]
        filterView.onFilterSelected = { index in
            print("Selected filter: \(index)")
        }
        view.addSubview(filterView)
        filterView.easy.layout(Left(16), Right(16), Bottom(100), Height(40))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let navBarHeight = view.safeAreaInsets.top
        scrollState.maxOffset = navBarHeight
    }
    
    enum ScrollDirection {
        case up
        case down
    }
    
    struct ScrollState {
        var outerLastY: CGFloat = 0.0
        var innerY: CGFloat = 0.0
        var lastDidScrollOffsetY: CGFloat = 0.0
        
        var maxOffset: CGFloat = 250
        
        var isScrollingInnerCV: Bool = false
        var isScrollingOuterCV: Bool = false
        
        var scrollDirection: ScrollDirection?
        var wasScrollingWithOuterCV: Bool = false
    }
    
    var scrollState = ScrollState()
    
    
 
    
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let parentCollection = parentCollection, let childCollection = childCollection else { return }
        
        if recognizer === parentCollection.panGestureRecognizer {
            scrollState.isScrollingOuterCV = true
            scrollState.wasScrollingWithOuterCV = true
        }else if recognizer === childCollection.panGestureRecognizer {
            scrollState.isScrollingInnerCV = true
        }
        
        let isParentAtBottom = parentCollection.contentOffset.y >= scrollState.maxOffset
        let translationY = recognizer.translation(in: view).y
        
        if translationY > 0 {
            scrollState.scrollDirection = .down
        }else if translationY < 0 {
            scrollState.scrollDirection = .up
        }
        
        switch recognizer.state {
        case .began:
            
            scrollState.outerLastY = parentCollection.contentOffset.y
            if isParentAtBottom && childCollection.contentOffset.y > 0 {
                scrollState.innerY = childCollection.contentOffset.y
            }else if !isParentAtBottom && childCollection.contentOffset.y > 0 {
                scrollState.innerY = childCollection.contentOffset.y
            }else{
                scrollState.innerY = 0
            }
        case .changed:
            
            let adjustedTranslation = translationY - scrollState.innerY
            // MARK: isScrollingOuterCV=true we translationY < 0 seretmeli
            
            // MARK: Swipe gesture recognizer goshmaly yokaryk swipe edende ozi do konsa gider yaly
            if scrollState.isScrollingOuterCV {
                if childCollection.contentOffset.y > 0 && translationY > 0 {
                    parentCollection.contentOffset.y = scrollState.outerLastY
                    childCollection.contentOffset.y = scrollState.innerY - translationY
                    return
                }
            }
            
            if !isParentAtBottom {
                
                if scrollState.isScrollingOuterCV {
                    return
                }
                
                if childCollection.contentOffset.y > 0 && translationY > 0 {
                    return
                }
                
                
                
                parentCollection.contentOffset.y = scrollState.outerLastY - adjustedTranslation
                
            }
            
            if isParentAtBottom {
                
              
                
                if (childCollection.contentOffset.y > 0) {
                    return
                }
                
                parentCollection.contentOffset.y = scrollState.outerLastY - adjustedTranslation
            }
        case .failed, .ended, .cancelled:
            scrollState.outerLastY = parentCollection.contentOffset.y
            if isParentAtBottom && childCollection.contentOffset.y > 0 {
                scrollState.innerY = childCollection.contentOffset.y
            }else if !isParentAtBottom && childCollection.contentOffset.y > 0 {
                scrollState.innerY = childCollection.contentOffset.y
            }else{
                scrollState.innerY = 0
            }
            scrollState.scrollDirection = nil
            scrollState.isScrollingInnerCV = false
            scrollState.isScrollingOuterCV = false
        default:
            break
        }
    }
    
    var lastScrollOffsetY: CGFloat = 0.0
    var maxScrollOffsetY: CGFloat = 0.0
    var minScrollOffsetY: CGFloat = 0.0
    
    func bounceFunction(_ scrollView: UIScrollView) {
        lastScrollOffsetY = scrollView.contentOffset.y
        if lastScrollOffsetY > maxScrollOffsetY {
            maxScrollOffsetY = lastScrollOffsetY
        }
        if lastScrollOffsetY < minScrollOffsetY {
            minScrollOffsetY = lastScrollOffsetY
        }
        
        if minScrollOffsetY < 0 && maxScrollOffsetY > 0 && lastScrollOffsetY == 0 {
            minScrollOffsetY = 0
            maxScrollOffsetY = 0
            print("whoaaaa")
            guard let parentCollection = parentCollection, !scrollState.wasScrollingWithOuterCV, !scrollState.isScrollingOuterCV, !scrollState.isScrollingInnerCV else {
                scrollState.wasScrollingWithOuterCV = false
                return
            }
            parentCollection.setContentOffset(.init(x: parentCollection.contentOffset.x, y: -scrollState.maxOffset), animated: true)
        }
    }
    
    func postsDidScrollDelegate(_ scrollView: UIScrollView) {
        bounceFunction(scrollView)
        guard let parentCollection = parentCollection else { return }
        print("child yyyy \(scrollView.contentOffset.y)")
        let isParentAtBottom = parentCollection.contentOffset.y >= scrollState.maxOffset
//        if (scrollView.contentOffset.y > 0 && isParentAtBottom || scrollView.contentOffset.y >= 0 || !isParentAtBottom && scrollView.contentOffset.y > 0) && scrollState.scrollDirection != .up {
//            print("iwiowiwawaw[p")
//            return
//        }
        
        if !isParentAtBottom {
            
            if scrollState.innerY > 0 && scrollView.contentOffset.y > 0 && scrollState.scrollDirection != .up {
                return
            }
            
            scrollView.contentOffset.y = 0
        }
        
        if isParentAtBottom && (scrollView.contentOffset.y <= 0) {
            scrollView.contentOffset.y = 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("parent yyyy \(scrollView.contentOffset.y)")
//        print("mainnnn \(scrollView.contentOffset.y)")
//        guard let parentCollection = parentCollection, let childCollection = childCollection else { return }
//
//        let isParentAtBottom = parentCollection.contentOffset.y >= maxOffset
//
//        let diffsY = scrollView.contentOffset.y - lastDidScrollOffsetY
//        lastDidScrollOffsetY = scrollView.contentOffset.y
//
//        if isParentAtBottom && diffsY < 0 {
////            childCollection.contentOffset.y = outerLastY - scrollView.contentOffset.y
////            scrollView.contentOffset.y = outerLastY
//        }
     
    }
    
}

extension LinkProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 2 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let contentSection = collectionView.dequeueReusableCell(withReuseIdentifier: ContentWrapperCell.viewID, for: indexPath) as? ContentWrapperCell else {
                fatalError("This should never happen")
            }
            contentSection.setup()
            
            
            
            userPostsViewController1.scrollDelegate = self
            userPostsViewController2.scrollDelegate = self
            


            contentSection.pages = [userPostsViewController1, userPostsViewController2]
            contentSection.reload()
            return contentSection
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionTopHeader.viewID, for: indexPath) as? CollectionTopHeader else {
                fatalError("This should never happen")
            }
            return headerView
        }else if indexPath.section == 1 {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionPinnedHeader.viewID, for: indexPath) as? CollectionPinnedHeader else {
                fatalError("This should never happen")
            }
            return headerView
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EmptyHeaderView", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 200)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let parentCollection = mainView.collectionView
//        let parentMaxOffsetY = parentCollection.contentSize.height - parentCollection.bounds.height
//        let isParentAtBottom = parentCollection.contentOffset.y >= parentMaxOffsetY
//        let isChildAtTop = scrollView.contentOffset.y <= 0
//
//
//        if isParentAtBottom {
//            parentCollection.bounces = false
//            userPostsViewController1.collectionView.isScrollEnabled = true
//            userPostsViewController2.collectionView.isScrollEnabled = true
//        } else{
//            parentCollection.bounces = true
//        }
//        if isChildAtTop {
//            if scrollView == userPostsViewController1.collectionView{
//                userPostsViewController1.collectionView.isScrollEnabled = false
//            } else if scrollView == userPostsViewController2.collectionView{
//                userPostsViewController2.collectionView.isScrollEnabled = false
//            }
//        }
//    }
}

protocol postsDidScrollDelegate {
    func postsDidScrollDelegate(_ scrollView: UIScrollView)
}

class UserPostsViewController: UIViewController{
    
    var color: UIColor

    public var scrollDelegate: postsDidScrollDelegate?
    
    public var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    init(color: UIColor) {
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    private func setUpCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false

//        collectionView.isScrollEnabled = false
        if #available(iOS 26, *) {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        }
        
        
        // Register the cell
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.cellId)
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset.bottom = 215
    }
    
}

extension UserPostsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.cellId, for: indexPath) as? FeedCollectionViewCell else {
                fatalError("This should never happen")
            }
        let colors: [UIColor] = [
            .systemRed, .systemBlue, .systemGreen,
            .systemOrange, .systemPurple, .systemPink, .systemCyan, .systemTeal, .systemMint, .systemBrown, .systemIndigo
        ]
        cell.postImageView.backgroundColor = colors[indexPath.item % colors.count]
        cell.titleLabel.text = "\(indexPath.item+1)"
        return cell
    }
    
    // Set the item size for the 3 column grid
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width - 2) / 3 // 3 columns with space between
        return CGSize(width: width, height: width)  // Make cells square
    }
    
    // Set insets and spacing for the grid
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // Set spacing around the grid
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1 // Space between items horizontally
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1 // Space between items vertically
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.postsDidScrollDelegate(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

}

final class CollectionPinnedHeader: UICollectionReusableView {
    
    static let viewID = "CollectionPinnedHeader"
  
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.borderWidth = 1
        titleLabel.text = "Pinned Header"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = .black
        addSubview(titleLabel)
        titleLabel.easy.layout(CenterY(), Leading(50))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class CollectionTopHeader: UICollectionReusableView {
    
    static let viewID = "CollectionTopHeader"
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.borderWidth = 1
        titleLabel.text = "Top Header"
        titleLabel.font = UIFont.systemFont(ofSize: 40)
        titleLabel.textColor = .black
        addSubview(titleLabel)
        titleLabel.easy.layout(CenterY(), Leading(50))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class FeedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let cellId = "FeedCollectionViewCell"
    
    // MARK: - UI components
    
    let titleLabel = UILabel()
    
    public var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.systemCyan
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        titleLabel.text = nil
    }

    // MARK: - Private
    private func setUpUI() {
        contentView.addSubview(postImageView)
        postImageView.easy.layout(
            Edges()
        )
        
        contentView.addSubview(titleLabel)
        titleLabel.easy.layout(Center())
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
    }
}

class LinkProfileView: UIView {
    
    private let refreshControl = UIRefreshControl()
    
    public lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CollectionTopHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionTopHeader.viewID)
        collectionView.register(CollectionPinnedHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionPinnedHeader.viewID)
        collectionView.register(ContentWrapperCell.self, forCellWithReuseIdentifier: ContentWrapperCell.viewID)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyHeaderView")
        return collectionView
    }()
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            
            let height = UIScreen.main.bounds.height
            var sectionHeaderHeight: CGFloat = 0
            var sectionItemHeight: CGFloat = 0
            switch sectionIndex {
            case 0:
                sectionHeaderHeight = 200
            case 1:
                sectionHeaderHeight = 50
                sectionItemHeight = height
            default:
                sectionHeaderHeight = 0
            }
            
           

            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )

            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: [item]
            )

            // Create the section layout
            let section = NSCollectionLayoutSection(group: group)

         

            // Define boundary supplementary item (header)
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1),
                                  heightDimension: .absolute(sectionHeaderHeight)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            if sectionIndex == 1 {
                headerItem.pinToVisibleBounds = true
            }
           
            section.boundarySupplementaryItems = [headerItem]
            return section // Fallback
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.refreshControl = refreshControl
        refreshControl.layer.zPosition = -1
        addSubview(collectionView)
        collectionView.easy.layout(
            Edges()
        )
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        if #available(iOS 26.0, *) {
            collectionView.topEdgeEffect.style = .hard
        }
    }
    
    @objc private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ContentWrapperCell: UICollectionViewCell {
    static let viewID = "ContentWrapperCell"

    public var pages: [UIViewController] = []

    lazy var contentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: "ContentCell")
        collectionView.bounces = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    func reload() {
        contentCollectionView.reloadData()
    }

    
    func setup() {
        contentView.addSubview(contentCollectionView)
        contentCollectionView.easy.layout(
            Edges()
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContentWrapperCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as! ContentCell
        DispatchQueue.main.async {
            cell.embedViewController(self.pages[indexPath.item])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
}

class ContentCell: UICollectionViewCell {
    func embedViewController(_ vc: UIViewController) {
        // Clean up any existing views
        contentView.subviews.forEach { $0.removeFromSuperview() }

        if let parent = self.parentViewController {
            // Avoid duplicate parent-child relationships
            if vc.parent != parent {
                parent.addChild(vc)
                vc.didMove(toParent: parent)
            }

            vc.view.frame = contentView.bounds
            vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView.addSubview(vc.view)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.subviews.forEach { $0.frame = contentView.bounds }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let next = responder?.next {
            if let vc = next as? UIViewController {
                return vc
            }
            responder = next
        }
        return nil
    }
}

import SwiftUI

struct PreviewView: SwiftUI.View {
    var body: some SwiftUI.View {
        UINavigationController(rootViewController: LinkProfileVC())
            .swiftUIView()
    }
}

#Preview {
    PreviewView()
}
