//
//  HomeViewController.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 12/10/2022.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

let deviceNames: [String] = [
    "iPhone SE (3rd generation)",
    "iPhone 14 Pro",
    "iPad Pro (9.7-inch)"
]

@available(iOS 13.0, *)
struct ViewControllerPreview: PreviewProvider {
    static var previews: some View {
        // Prévisualisation avec plusieurs simulateurs iPhone et iPad en light et dark mode
        ForEach(deviceNames, id: \.self) { deviceName in
            // Mode lumineux (light mode)
            UIViewControllerPreview {
                HomeViewController()
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.light)
            .previewDisplayName("\(deviceName) (Light)")
            .edgesIgnoringSafeArea(.all)
            
            // Mode sombre (dark mode)
            UIViewControllerPreview {
                HomeViewController()
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.dark)
            .previewDisplayName("\(deviceName) (Dark)")
            .edgesIgnoringSafeArea(.all)
        }
    }
}
#endif
