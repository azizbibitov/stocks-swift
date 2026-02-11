////
////  ZoomableVideoView.swift
////  StocksSnapKit
////
////  Created by Aziz Bibitov on 30/07/2025.
////
//
//import UIKit
//import AVFoundation
//
////class ZoomableVideoView: UIView, UIScrollViewDelegate {
////    
////    private let scrollView = UIScrollView()
////    private let containerView = UIView()
////    private let playerLayer = AVPlayerLayer()
////    
////    var player: AVPlayer? {
////        didSet {
////            playerLayer.player = player
////            player?.play()
////        }
////    }
////
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////        setupViews()
////    }
////
////    required init?(coder: NSCoder) {
////        super.init(coder: coder)
////        setupViews()
////    }
////
////    private func setupViews() {
////        // ScrollView config
////        scrollView.backgroundColor = .systemBlue
////        scrollView.delegate = self
////        scrollView.minimumZoomScale = 1.0
////        scrollView.maximumZoomScale = 4.0
////        scrollView.showsVerticalScrollIndicator = false
////        scrollView.showsHorizontalScrollIndicator = false
////        scrollView.bouncesZoom = true
////        scrollView.bounces = true
////        addSubview(scrollView)
////
////        // Container view config
////        scrollView.addSubview(containerView)
////        containerView.layer.addSublayer(playerLayer)
////    }
////
////    override func layoutSubviews() {
////        super.layoutSubviews()
////
////        // ScrollView takes full bounds
////        scrollView.frame = bounds
////
////        // Fixed size of video (e.g., 300x200)
////        let videoSize = CGSize(width: 300, height: 200)
////        containerView.frame = CGRect(origin: .zero, size: videoSize)
////
////        // Center the video in scrollView
////        containerView.center = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
////        scrollView.contentSize = videoSize
////
////        // Match the player layer to container
////        playerLayer.frame = containerView.bounds
////    }
////
////    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
////        return containerView
////    }
////    
////    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
////        // Animate back to normal zoom
////        UIView.animate(withDuration: 0.3) {
////            scrollView.setZoomScale(1.0, animated: false)
////        }
////    }
////}
//
//
////class VideoPlayer: NSObject {
////    let containerView: UIView // hosts playerLayer
////    private let playerLayer: AVPlayerLayer
////    let player: AVPlayer
////
////    private var scrollView: UIScrollView?
////
////    init(containerView: UIView, url: URL) {
////        self.containerView = containerView
////        self.player = AVPlayer(url: url)
////
////        playerLayer = AVPlayerLayer(player: player)
////        playerLayer.frame = containerView.bounds
////        playerLayer.videoGravity = .resizeAspect
////        containerView.layer.addSublayer(playerLayer)
////    }
////
////    func play() {
////        player.play()
////    }
////
////    func pause() {
////        player.pause()
////    }
////
////    // Call this to enable zooming on containerView
////    func enableZooming() {
////        guard scrollView == nil else { return } // only once
////
////        // Create scroll view with same frame as containerView
////        let sv = UIScrollView(frame: containerView.bounds)
////        sv.minimumZoomScale = 1.0
////        sv.maximumZoomScale = 4.0
////        sv.bouncesZoom = true
////        sv.showsHorizontalScrollIndicator = false
////        sv.showsVerticalScrollIndicator = false
////
////        // Move containerView’s content into a new view that will be zoomed
////        let zoomContentView = UIView(frame: containerView.bounds)
////        containerView.addSubview(sv)
////        sv.addSubview(zoomContentView)
////
////        // Remove playerLayer from containerView and add it to zoomContentView
////        playerLayer.removeFromSuperlayer()
////        playerLayer.frame = zoomContentView.bounds
////        zoomContentView.layer.addSublayer(playerLayer)
////
////        // Forward scrollView delegate (you can implement this)
////        sv.delegate = self // conform to UIScrollViewDelegate below
////
////        scrollView = sv
////
////        // You may want to update frames on layout changes
////    }
////}
//
////extension VideoPlayer: UIScrollViewDelegate {
////    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
////        return scrollView.subviews.first
////    }
////
////    func scrollViewDidZoom(_ scrollView: UIScrollView) {
////        // Center zoom content view when zoomed out
////        guard let zoomView = scrollView.subviews.first else { return }
////
////        let offsetX = max((scrollView.bounds.width - zoomView.frame.width) * 0.5, 0)
////        let offsetY = max((scrollView.bounds.height - zoomView.frame.height) * 0.5, 0)
////        zoomView.center = CGPoint(x: scrollView.bounds.width * 0.5 + offsetX,
////                                 y: scrollView.bounds.height * 0.5 + offsetY)
////    }
////}
//
//final class ZoomablePlayerView: UIView, UIScrollViewDelegate {
//    
//    // MARK: - Public API
//    
//    private(set) var player: AVPlayer?
//    
//    /// Call to set up video URL and start playing
//    func configure(with url: URL) {
//        let playerItem = AVPlayerItem(url: url)
//        if player == nil {
//            player = AVPlayer(playerItem: playerItem)
//            playerLayer.player = player
//        } else {
//            player?.replaceCurrentItem(with: playerItem)
//        }
//        player?.play()
//    }
//    
//    /// Pause playback
//    func pause() {
//        player?.pause()
//    }
//    
//    /// Play or resume playback
//    func play() {
//        player?.play()
//    }
//    
//    // MARK: - Private UI
//    
//    private let scrollView = UIScrollView()
//    private let playerContainerView = UIView()
//    private let playerLayer = AVPlayerLayer()
//    
//    // MARK: - Initialization
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupViews()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        scrollView.frame = bounds
//        updateFrames()
//    }
//    
//    // MARK: - Setup
//    
//    private func setupViews() {
//        // Setup scrollView
//        scrollView.delegate = self
//        scrollView.minimumZoomScale = 1.0
//        scrollView.maximumZoomScale = 4.0
//        scrollView.bouncesZoom = true
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.showsVerticalScrollIndicator = false
//        addSubview(scrollView)
//        
//        // Setup playerContainerView inside scrollView
//        scrollView.addSubview(playerContainerView)
//        
//        // Setup playerLayer
//        playerLayer.videoGravity = .resizeAspect
//        playerContainerView.layer.addSublayer(playerLayer)
//        
//        // Initial frames (will be updated in layoutSubviews)
//        updateFrames()
//    }
//    
//    private func updateFrames() {
//        // Set playerContainerView to fixed size (you can customize)
//        let width: CGFloat = bounds.width * 0.8
//        let height: CGFloat = bounds.height * 0.5
//        let originX = (bounds.width - width) / 2
//        let originY = (bounds.height - height) / 2
//        
//        playerContainerView.frame = CGRect(x: originX, y: originY, width: width, height: height)
//        playerLayer.frame = playerContainerView.bounds
//        
//        scrollView.contentSize = playerContainerView.frame.size
//        centerScrollViewContents()
//    }
//    
//    private func centerScrollViewContents() {
//        let boundsSize = scrollView.bounds.size
//        var contentsFrame = playerContainerView.frame
//        
//        if contentsFrame.size.width < boundsSize.width {
//            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
//        } else {
//            contentsFrame.origin.x = 0
//        }
//        
//        if contentsFrame.size.height < boundsSize.height {
//            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
//        } else {
//            contentsFrame.origin.y = 0
//        }
//        
//        playerContainerView.frame = contentsFrame
//    }
//    
//    // MARK: - UIScrollViewDelegate
//    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return playerContainerView
//    }
//    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        centerScrollViewContents()
//    }
//}
