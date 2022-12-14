//
//  UIViewControllerPreview.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 14/10/2022.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

let deviceNames: [String] = [
    "iPhone SE (3rd generation)",
    "iPhone 14 Pro",
    "iPad Pro (9.7-inch)"
]

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> ViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {
        return
    }
}
#endif
