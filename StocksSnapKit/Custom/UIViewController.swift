//
//  UIViewController.swift
//  PokerUIKit
//
//  Created by Aziz Bibitov on 29/12/2025.
//

import SwiftUI
import UIKit

extension UIViewController {
    func swiftUIView() -> some View {
        UIKitControllerWrapper(controller: self)
            .edgesIgnoringSafeArea(.all)
    }
}

struct UIKitControllerWrapper<Controller: UIViewController>: UIViewControllerRepresentable {

    let controller: Controller

    func makeUIViewController(context: Context) -> Controller {
        controller
    }

    func updateUIViewController(_ uiViewController: Controller, context: Context) {
      
    }
}
