//
//  IGListKitExample.swift
//  StocksSnapKit
//
//  Created by Aziz Bibitov on 22/01/2026.
//

import Foundation
import UIKit
import IGListKit
import EasyPeasy

class LabelSectionController: ListSectionController {
    
  override func sizeForItem(at index: Int) -> CGSize {
    return CGSize(width: collectionContext!.containerSize.width, height: 55)
  }

  override func cellForItem(at index: Int) -> UICollectionViewCell {
    return collectionContext!.dequeueReusableCell(of: IGCell.self, for: self, at: index)
  }
}

class IGCell: UICollectionViewCell {
    
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let titleLabel = UILabel()
        titleLabel.text = "Top Header"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        addSubview(titleLabel)
        titleLabel.easy.layout(Center())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//import SwiftUI
//
//struct PreviewView: SwiftUI.View {
//    var body: some SwiftUI.View {
//        LinkProfileVC().swiftUIView()
//    }
//}
//
//#Preview {
//    PreviewView()
//}
