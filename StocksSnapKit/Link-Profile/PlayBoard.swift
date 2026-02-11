//
// Copyright 2026 Link Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import UIKit
import EasyPeasy
import AVKit


class MyScreen: UIViewController {
    
    let playerLayer: AVPlayerLayer = {
        let avplayerLayer = AVPlayerLayer()
        avplayerLayer.videoGravity = .resizeAspectFill
        return avplayerLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = "Label shu"
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 30)
        
        let rectangle = UIView()
        rectangle.backgroundColor = .systemRed
        rectangle.layer.cornerRadius = 20
        view.addSubview(rectangle)
        rectangle.easy.layout([
            Center(), Height(200), Width(300)
        ])
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.tintColor = .green
        rectangle.addSubview(imageView)
        imageView.easy.layout(Size(50), Center())
        
        view.backgroundColor = .white
        view.addSubview(label)
        label.easy.layout([
            CenterX(), Bottom(20).to(rectangle, .top)
        ])
        
        playerLayer.frame = self.view.frame
        if let uRL = Bundle.main.url(forResource: "video", withExtension: "mp4") {
            let player = AVPlayer(url: uRL)
            playerLayer.player = player
        }
    }
    
}


//import SwiftUI
//
//struct PreviewView: SwiftUI.View {
//    var body: some SwiftUI.View {
//        MyScreen().swiftUIView()
//    }
//}
//
//#Preview {
//    PreviewView()
//}
//
//
//func playBoard() {
//    
//    var name: String = "Aziz"
//
//    name = "Sunnet"
//    
//    print(name)
//}
//
