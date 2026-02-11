//
//  ScrollUISegmentController.swift
//  StocksSnapKit
//
//  Created by Aziz Bibitov on 10/02/2026.
//

import UIKit

protocol ScrollUISegmentControllerDelegate: AnyObject {
    func selectItemAt(index: Int, onScrollUISegmentController scrollUISegmentController: ScrollUISegmentController)
}

private class ScrollFriendlySegmentedControl: UISegmentedControl {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

@IBDesignable
class ScrollUISegmentController: UIScrollView {

    private var segmentedControl = ScrollFriendlySegmentedControl()
    private var lastBounds: CGRect = .zero
    private var needsSegmentRebuild = true

    weak var segmentDelegate: ScrollUISegmentControllerDelegate?

    @IBInspectable
    public var segmentTintColor: UIColor = .black {
        didSet { segmentedControl.tintColor = segmentTintColor }
    }

    @IBInspectable
    public var itemWidth: CGFloat = 100 {
        didSet { setNeedsLayout() }
    }

    public var segmentFont: UIFont = .systemFont(ofSize: 13) {
        didSet {
            segmentedControl.setTitleTextAttributes([.font: segmentFont], for: .normal)
        }
    }

    public var segmentItems: [String] = ["1", "2", "3"] {
        didSet {
            needsSegmentRebuild = true
            setNeedsLayout()
        }
    }

    // MARK: - Init

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupScrollView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
    }

    init(frame: CGRect, items: [String]) {
        super.init(frame: frame)
        self.segmentItems = items
        setupScrollView()
    }

    private func setupScrollView() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        needsSegmentRebuild = true
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.size != lastBounds.size || needsSegmentRebuild else { return }
        lastBounds = bounds

        let selectedIndex = needsSegmentRebuild ? 0 : segmentedControl.selectedSegmentIndex

        if needsSegmentRebuild {
            rebuildSegments()
            needsSegmentRebuild = false
        }

        layoutSegmentedControl()
        segmentedControl.selectedSegmentIndex = selectedIndex
    }

    private func rebuildSegments() {
        segmentedControl.removeAllSegments()
        for (index, title) in segmentItems.enumerated() {
            segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        segmentedControl.setTitleTextAttributes([.font: segmentFont], for: .normal)
        segmentedControl.tintColor = segmentTintColor
    }

    private func layoutSegmentedControl() {
        let count = CGFloat(segmentItems.count)
        guard count > 0 else { return }

        let effectiveItemWidth = max(itemWidth, bounds.width / count)
        let totalWidth = effectiveItemWidth * count

        segmentedControl.frame = CGRect(x: 0, y: 0, width: totalWidth, height: bounds.height)
        contentSize = CGSize(width: totalWidth, height: bounds.height)
    }

    // MARK: - Actions

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        segmentDelegate?.selectItemAt(index: sender.selectedSegmentIndex, onScrollUISegmentController: self)
        
        // Scroll to make selected segment more visible
        scrollSegmentToVisible(index: sender.selectedSegmentIndex)
    }

    private func scrollSegmentToVisible(index: Int) {
        guard index < segmentedControl.numberOfSegments else { return }

        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let selectedX = CGFloat(index) * segmentWidth
        let visibleWidth = bounds.width

        var targetOffsetX = selectedX - visibleWidth / 2 + segmentWidth / 2
        targetOffsetX = max(0, min(targetOffsetX, contentSize.width - visibleWidth)) // clamp to scrollable range

        setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
    }

}
