//
//  NewSegmentedControll.swift
//  StocksSnapKit
//
//  Created by Aziz Bibitov on 10/02/2026.
//

import UIKit
import EasyPeasy

class SegmentedViewController: UIViewController {

    private var scrollSegment: ScrollUISegmentController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Create instance
        scrollSegment = ScrollUISegmentController(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 40),
                                                  items: ["Media", "Files", "Links", "Voice", "Media", "Files", "Links", "Voice", "Media", "Files", "Links", "Voice"])
        scrollSegment.segmentFont = UIFont.boldSystemFont(ofSize: 14)
        scrollSegment.segmentTintColor = .systemBlue
        scrollSegment.segmentDelegate = self

        // 2. Add to view
        view.addSubview(scrollSegment)
    }
}

// MARK: - ScrollUISegmentControllerDelegate
extension SegmentedViewController: ScrollUISegmentControllerDelegate {
    func selectItemAt(index: Int, onScrollUISegmentController scrollUISegmentController: ScrollUISegmentController) {
        print("Selected tab index: \(index)")
        // Here you can update your page content
        // Example: pageViewController.setViewControllers(...)
    }
}


import SwiftUI

struct PreviewView: SwiftUI.View {
    var body: some SwiftUI.View {
        SegmentedViewController().swiftUIView()
    }
}

#Preview {
    PreviewView()
}
