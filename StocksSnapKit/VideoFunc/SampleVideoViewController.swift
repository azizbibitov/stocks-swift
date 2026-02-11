////
////  SampleVideoViewController.swift
////  StocksSnapKit
////
////  Created by Aziz Bibitov on 30/07/2025.
////
//
//import UIKit
//import AVFoundation
//import EasyPeasy
//
////class ViewController: UIViewController {
////    
////    let zoomableVideoView = ZoomableVideoView()
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////        view.backgroundColor = .systemGreen
//////        zoomableVideoView.frame = view.bounds
////        zoomableVideoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////        view.addSubview(zoomableVideoView)
////        zoomableVideoView.easy.layout([
////            Center(), Height(200), Width(300)
////        ])
////
////        // Load video
////        if let path = Bundle.main.path(forResource: "sample", ofType: "mp4") {
////            let url = URL(fileURLWithPath: path)
////            let player = AVPlayer(url: url)
////            zoomableVideoView.player = player
////        } else {
////            print("❌ Video not found")
////        }
////    }
////}
//
//
////class ViewController: UIViewController {
////
////    private let videoContainer = UIView()
////    private var videoPlayer: VideoPlayer?
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        view.backgroundColor = .black
////
////        // Setup container frame & center it
////        let width: CGFloat = 300
////        let height: CGFloat = 200
////        videoContainer.frame = CGRect(x: (view.bounds.width - width)/2,
////                                      y: (view.bounds.height - height)/2,
////                                      width: width,
////                                      height: height)
////        videoContainer.backgroundColor = .black
////        videoContainer.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin,
////                                           .flexibleTopMargin, .flexibleBottomMargin]
////        view.addSubview(videoContainer)
////
////        // Prepare video URL
////        guard let url = Bundle.main.url(forResource: "sample", withExtension: "mp4") else {
////            print("Video file not found")
////            return
////        }
////
////        // Initialize player
////        videoPlayer = VideoPlayer(containerView: videoContainer, url: url)
////
////        // Enable pinch-to-zoom
////        videoPlayer?.enableZooming()
////
////        // Start playback
////        videoPlayer?.play()
////    }
////}
//
//
//class MyViewController: UIViewController {
//    private let zoomablePlayer = ZoomablePlayerView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//
//        
//        zoomablePlayer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(zoomablePlayer)
//        
//        zoomablePlayer.easy.layout([
//            Center(), Height(300), Width(450)
//        ])
//
//        if let url = URL(string: "https://www.w3schools.com/html/mov_bbb.mp4") {
//            zoomablePlayer.configure(with: url)
//        }
//    }
//}
