//
//  HorizontalFilterView.swift
//  StocksSnapKit
//
//  Created by Aziz Bibitov on 11/02/2026.
//

import UIKit
import EasyPeasy

// MARK: - CABackdropLayer Runtime Access (Pre-iOS 26)

private func createBackdropLayer() -> CALayer? {
    let className = ("CA" as NSString).appendingFormat("BackdropLayer") as String
    guard let cls = NSClassFromString(className) as? CALayer.Type else { return nil }
    let layer = cls.init()

    // setScale:
    let scaleSelector = NSSelectorFromString("setScale:")
    if layer.responds(to: scaleSelector) {
        layer.perform(scaleSelector, with: NSNumber(value: 1.0))
    }

    // Apply gaussian blur filter
    if let blurFilter = createBlurFilter() {
        blurFilter.setValue(NSNumber(value: 2.0), forKey: "inputRadius")
        layer.filters = [blurFilter]
    }

    return layer
}

private func createBlurFilter() -> NSObject? {
    let filterName = ("gaussian" as NSString).appendingFormat("Blur") as String
    guard let filterClass = NSClassFromString("CAFilter") as? NSObject.Type else { return nil }
    let selector = NSSelectorFromString("filterWithType:")
    guard filterClass.responds(to: selector) else { return nil }
    return filterClass.perform(selector, with: filterName)?.takeUnretainedValue() as? NSObject
}

// MARK: - Image Generation Helpers

private func generateStretchableFilledCircleImage(diameter: CGFloat, color: UIColor) -> UIImage? {
    let size = CGSize(width: diameter, height: diameter)
    let renderer = UIGraphicsImageRenderer(size: size)
    let image = renderer.image { ctx in
        ctx.cgContext.setFillColor(color.cgColor)
        ctx.cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
    }
    let capInset = Int(diameter / 2)
    return image.stretchableImage(withLeftCapWidth: capInset, topCapHeight: capInset)
}

private func generateGlassForegroundImage(size: CGSize, shadowInset: CGFloat, isDark: Bool) -> UIImage? {
    let fillColor: UIColor
    if isDark {
        fillColor = UIColor(white: 1.0, alpha: 1.0)
            .mixedWith(.black, alpha: 1.0 - 0.11)
            .withAlphaComponent(0.85)
    } else {
        fillColor = UIColor(white: 1.0, alpha: 0.7)
    }

    let totalSize = CGSize(width: size.width + shadowInset * 2, height: size.height + shadowInset * 2)
    let renderer = UIGraphicsImageRenderer(size: totalSize)
    let image = renderer.image { ctx in
        let context = ctx.cgContext
        context.clear(CGRect(origin: .zero, size: totalSize))

        let innerRect = CGRect(
            origin: CGPoint(x: shadowInset, y: shadowInset),
            size: size
        )
        let cornerRadius = min(size.width, size.height) * 0.5

        // Outer shadow pass 1: blur 30, alpha 0.045
        context.saveGState()
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        let spreadRect1 = innerRect.insetBy(dx: 0.25, dy: 0.25)
        let spreadPath1 = UIBezierPath(roundedRect: spreadRect1, cornerRadius: cornerRadius)
        context.setShadow(offset: .zero, blur: 30.0, color: UIColor(white: 0, alpha: 0.045).cgColor)
        context.setFillColor(UIColor.black.cgColor)
        context.addPath(spreadPath1.cgPath)
        context.fillPath()
        // Cut out inside
        let cleanPath1 = UIBezierPath(roundedRect: innerRect, cornerRadius: cornerRadius)
        context.setBlendMode(.copy)
        context.setFillColor(UIColor.clear.cgColor)
        context.addPath(cleanPath1.cgPath)
        context.fillPath()
        context.setBlendMode(.normal)
        context.endTransparencyLayer()
        context.restoreGState()

        // Outer shadow pass 2: blur 20, alpha 0.01
        context.saveGState()
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        context.setShadow(offset: .zero, blur: 20.0, color: UIColor(white: 0, alpha: 0.01).cgColor)
        context.setFillColor(UIColor.black.cgColor)
        context.addPath(spreadPath1.cgPath)
        context.fillPath()
        let cleanPath2 = UIBezierPath(roundedRect: innerRect, cornerRadius: cornerRadius)
        context.setBlendMode(.copy)
        context.setFillColor(UIColor.clear.cgColor)
        context.addPath(cleanPath2.cgPath)
        context.fillPath()
        context.setBlendMode(.normal)
        context.endTransparencyLayer()
        context.restoreGState()

        // Fill ellipse with tint color
        context.setFillColor(fillColor.cgColor)
        context.fillEllipse(in: innerRect)

        // Border stroke — asymmetric corner radii for glass highlight effect
        let lineWidth: CGFloat = isDark ? 0.8 : 0.8
        let baseAlpha: CGFloat = isDark ? 0.3 : 0.6
        let strokeColor: UIColor
        let blendMode: CGBlendMode

        if isDark {
            blendMode = .overlay
            strokeColor = UIColor(white: 1.0, alpha: 0.7 * baseAlpha)
        } else {
            blendMode = .normal
            strokeColor = UIColor(white: 1.0, alpha: baseAlpha)
        }

        context.saveGState()
        context.addEllipse(in: innerRect)
        context.clip()

        let strokeRect = innerRect.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(strokeColor.cgColor)
        context.setBlendMode(blendMode)

        let radius = strokeRect.height * 0.5
        let smallerRadius = radius - lineWidth * 1.33
        context.move(to: CGPoint(x: strokeRect.minX, y: strokeRect.minY + radius))
        context.addArc(tangent1End: CGPoint(x: strokeRect.minX, y: strokeRect.minY),
                       tangent2End: CGPoint(x: strokeRect.minX + radius, y: strokeRect.minY),
                       radius: radius)
        context.addLine(to: CGPoint(x: strokeRect.maxX - smallerRadius, y: strokeRect.minY))
        context.addArc(tangent1End: CGPoint(x: strokeRect.maxX, y: strokeRect.minY),
                       tangent2End: CGPoint(x: strokeRect.maxX, y: strokeRect.minY + smallerRadius),
                       radius: smallerRadius)
        context.addLine(to: CGPoint(x: strokeRect.maxX, y: strokeRect.maxY - radius))
        context.addArc(tangent1End: CGPoint(x: strokeRect.maxX, y: strokeRect.maxY),
                       tangent2End: CGPoint(x: strokeRect.maxX - radius, y: strokeRect.maxY),
                       radius: radius)
        context.addLine(to: CGPoint(x: strokeRect.minX + smallerRadius, y: strokeRect.maxY))
        context.addArc(tangent1End: CGPoint(x: strokeRect.minX, y: strokeRect.maxY),
                       tangent2End: CGPoint(x: strokeRect.minX, y: strokeRect.maxY - smallerRadius),
                       radius: smallerRadius)
        context.closePath()
        context.strokePath()

        context.restoreGState()
    }

    let capX = Int(shadowInset + size.width * 0.5)
    let capY = Int(shadowInset + size.height * 0.5)
    return image.stretchableImage(withLeftCapWidth: capX, topCapHeight: capY)
}

// MARK: - UIColor Helper

private extension UIColor {
    func mixedWith(_ other: UIColor, alpha: CGFloat) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        other.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        let t = alpha
        return UIColor(
            red: r1 * (1 - t) + r2 * t,
            green: g1 * (1 - t) + g2 * t,
            blue: b1 * (1 - t) + b2 * t,
            alpha: a1 * (1 - t) + a2 * t
        )
    }
}

// MARK: - Backdrop Layer Delegate (disables implicit animations)

private final class BackdropLayerDelegate: NSObject, CALayerDelegate {
    func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
}

// MARK: - HorizontalFilterView

class HorizontalFilterView: UIView {

    // MARK: - Public API

    var filters: [String] = [] {
        didSet { rebuildButtons() }
    }

    var selectedIndex: Int {
        get { return _selectedIndex }
        set {
            let oldValue = _selectedIndex
            _selectedIndex = newValue
            if oldValue != newValue {
                updateSelection(animated: true)
            }
        }
    }
    private var _selectedIndex: Int = 0

    var onFilterSelected: ((Int) -> Void)?

    // MARK: - Glass Background (two paths)

    // iOS 26+: native glass
    private var nativeGlassView: UIVisualEffectView?

    // Pre-iOS 26: CABackdropLayer + foreground overlay
    private var backdropLayer: CALayer?
    private let backdropLayerDelegate = BackdropLayerDelegate()
    private var legacyContainerView: UIView?
    private var foregroundImageView: UIImageView?
    private var shadowImageView: UIImageView?

    // MARK: - Content

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceHorizontal = true
        sv.canCancelContentTouches = true
        return sv
    }()

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()

    private let selectionView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = false
        iv.isHidden = true
        return iv
    }()

    private var buttons: [UIButton] = []
    private var currentIsDark: Bool = false
    private var lastLayoutSize: CGSize = .zero

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    // MARK: - Setup

    private func setUp() {
        clipsToBounds = false

        if #available(iOS 26.0, *) {
            setUpNativeGlass()
        } else {
            setUpLegacyGlass()
        }

        scrollView.addSubview(selectionView)
        scrollView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Horizontal: pin to contentLayoutGuide → defines scrollable content width
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            // Vertical: pin to frameLayoutGuide → fills visible height, no vertical scroll
            stackView.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor),
        ])
    }

    @available(iOS 26.0, *)
    private func setUpNativeGlass() {
        let glassEffect = UIGlassEffect(style: .regular)
        glassEffect.isInteractive = false
        let effectView = UIVisualEffectView(effect: glassEffect)
        effectView.clipsToBounds = true
        self.nativeGlassView = effectView
        addSubview(effectView)
        effectView.easy.layout(Edges())

        effectView.contentView.addSubview(scrollView)
        scrollView.easy.layout(Edges())
    }

    private func setUpLegacyGlass() {
        // Shadow layer (behind everything)
        let shadowIV = UIImageView()
        self.shadowImageView = shadowIV
        addSubview(shadowIV)

        // Container for backdrop + clipping
        let container = UIView()
        container.clipsToBounds = true
        container.layer.cornerCurve = .circular
        self.legacyContainerView = container
        addSubview(container)

        // CABackdropLayer for real-time blur
        if let backdrop = createBackdropLayer() {
            backdrop.delegate = backdropLayerDelegate
            container.layer.addSublayer(backdrop)
            self.backdropLayer = backdrop
        }

        // Foreground overlay (tint + border + shadow baked into stretchable image)
        let fgView = UIImageView()
        self.foregroundImageView = fgView
        addSubview(fgView)

        // Scroll view on top of everything
        addSubview(scrollView)
        scrollView.easy.layout(Edges())
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        let size = bounds.size
        guard size.width > 0, size.height > 0 else { return }

        let cornerRadius = size.height * 0.5
        let isDark = traitCollection.userInterfaceStyle == .dark
        currentIsDark = isDark

        if #available(iOS 26.0, *), let nativeGlassView {
            nativeGlassView.layer.cornerRadius = cornerRadius
            nativeGlassView.overrideUserInterfaceStyle = isDark ? .dark : .light
        } else {
            layoutLegacyGlass(size: size, cornerRadius: cornerRadius, isDark: isDark)
        }

        lastLayoutSize = size
        updateSelectionFrame()
    }

    private func layoutLegacyGlass(size: CGSize, cornerRadius: CGFloat, isDark: Bool) {
        let shadowInset: CGFloat = 32.0

        // Container (backdrop + clip)
        if let container = legacyContainerView {
            container.frame = bounds
            container.layer.cornerRadius = cornerRadius
        }

        // Backdrop layer fills the container
        if let backdrop = backdropLayer {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            backdrop.frame = CGRect(origin: .zero, size: size)
            CATransaction.commit()
        }

        // Foreground image (extends beyond bounds for shadow)
        let foregroundFrame = bounds.insetBy(dx: -shadowInset, dy: -shadowInset)
        if let fgView = foregroundImageView {
            fgView.frame = foregroundFrame
            fgView.image = generateGlassForegroundImage(
                size: size,
                shadowInset: shadowInset,
                isDark: isDark
            )
        }

        // Shadow image
        if let shadowIV = shadowImageView {
            shadowIV.frame = foregroundFrame
            shadowIV.image = generateOuterShadowImage(
                size: size,
                shadowInset: shadowInset,
                cornerRadius: cornerRadius
            )
        }
    }

    private func generateOuterShadowImage(size: CGSize, shadowInset: CGFloat, cornerRadius: CGFloat) -> UIImage? {
        let totalSize = CGSize(width: size.width + shadowInset * 2, height: size.height + shadowInset * 2)
        let renderer = UIGraphicsImageRenderer(size: totalSize)
        return renderer.image { ctx in
            let context = ctx.cgContext
            context.clear(CGRect(origin: .zero, size: totalSize))

            let innerRect = CGRect(x: shadowInset + 0.5, y: shadowInset + 0.5,
                                   width: size.width - 1.0, height: size.height - 1.0)

            context.setFillColor(UIColor.black.cgColor)
            context.setShadow(offset: CGSize(width: 0, height: 1), blur: 40.0,
                              color: UIColor(white: 0, alpha: 0.04).cgColor)
            context.fillEllipse(in: innerRect)

            // Cut out the center
            context.setFillColor(UIColor.clear.cgColor)
            context.setBlendMode(.copy)
            context.fillEllipse(in: innerRect)
        }.stretchableImage(
            withLeftCapWidth: Int(shadowInset + cornerRadius),
            topCapHeight: Int(shadowInset + cornerRadius)
        )
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            setNeedsLayout()
        }
    }

    // MARK: - Button Building

    private func rebuildButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for (index, title) in filters.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            button.setTitleColor(.label, for: .normal)
            button.tag = index
            button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
            button.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }

        _selectedIndex = 0
        setNeedsLayout()
    }

    // MARK: - Selection

    @objc private func filterTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index != selectedIndex else { return }
        selectedIndex = index
        onFilterSelected?(index)
    }

    /// Only repositions the pill frame — called from layoutSubviews on size change.
    /// Does NOT touch contentOffset so it won't fight with user scrolling.
    private func updateSelectionFrame() {
        guard selectedIndex < buttons.count else {
            selectionView.isHidden = true
            return
        }

        // Force the ENTIRE subtree to lay out: scrollView → stackView → buttons.
        // scrollView.layoutIfNeeded() alone only resolves the stackView's frame,
        // not the buttons inside it.
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
        stackView.setNeedsLayout()
        stackView.layoutIfNeeded()

        let button = buttons[selectedIndex]
        let btnFrame = button.convert(button.bounds, to: scrollView)
        let pillHeight = scrollView.bounds.height - 6.0

        // Bail out only if the scroll view has no height yet
        guard pillHeight > 0, btnFrame.width > 0 else { return }

        let pillFrame = CGRect(
            x: btnFrame.minX - 13.0,
            y: 3.0,
            width: btnFrame.width + 26.0,
            height: pillHeight
        )
        selectionView.frame = pillFrame

        if selectionView.image?.size.height != pillFrame.height {
            selectionView.image = generateStretchableFilledCircleImage(
                diameter: pillFrame.height,
                color: .white
            )?.withRenderingMode(.alwaysTemplate)
        }
        selectionView.tintColor = UIColor.label.withAlphaComponent(0.1)
        selectionView.isHidden = false
        selectionView.alpha = 1.0
    }

    /// Full update: animates pill + auto-scrolls to center the selected filter.
    /// Called when selectedIndex changes (user tap).
    private func updateSelection(animated: Bool) {
        guard selectedIndex < buttons.count else {
            selectionView.isHidden = true
            return
        }

        let button = buttons[selectedIndex]

        let movePill = {
            let btnFrame = button.convert(button.bounds, to: self.scrollView)
            let pillFrame = CGRect(
                x: btnFrame.minX - 13.0,
                y: 3.0,
                width: btnFrame.width + 26.0,
                height: self.scrollView.bounds.height - 6.0
            )
            self.selectionView.frame = pillFrame

            if self.selectionView.image?.size.height != pillFrame.height {
                self.selectionView.image = generateStretchableFilledCircleImage(
                    diameter: pillFrame.height,
                    color: .white
                )?.withRenderingMode(.alwaysTemplate)
            }
            self.selectionView.tintColor = UIColor.label.withAlphaComponent(0.1)
        }

        if selectionView.isHidden {
            selectionView.isHidden = false
            selectionView.alpha = 0
            movePill()
            UIView.animate(withDuration: 0.2) {
                self.selectionView.alpha = 1
            }
        } else if animated {
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: 0.75,
                initialSpringVelocity: 0.5,
                options: [.curveEaseInOut],
                animations: movePill
            )
        } else {
            movePill()
        }

        // Auto-scroll OUTSIDE the animation block so it doesn't get captured
        let btnFrame = button.convert(button.bounds, to: scrollView)
        let contentOffsetX = max(
            0,
            min(
                scrollView.contentSize.width - scrollView.bounds.width,
                floor(btnFrame.midX - scrollView.bounds.width / 2.0)
            )
        )
        scrollView.setContentOffset(
            CGPoint(x: contentOffsetX, y: 0),
            animated: animated
        )
    }
}
