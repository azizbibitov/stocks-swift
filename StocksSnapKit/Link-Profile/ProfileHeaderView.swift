//
//  ProfileHeaderView.swift
//  StocksSnapKit
//
//  Created by Aziz Bibitov on 21/01/2026.
//

import Foundation
import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    
    static let viewID = "ProfileHeaderView"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
