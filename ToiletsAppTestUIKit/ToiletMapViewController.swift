//
//  ToiletMapViewController.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 18/10/2022.
//

import UIKit
import CoreData

class ToiletMapViewController: UIViewController {
    private var toilets = [Toilet]()
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  HomeViewController.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 12/10/2022.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MapViewControllerPreview: PreviewProvider {
    static var previews: some View {
        // Prévisualisation avec plusieurs simulateurs iPhone et iPad en light et dark mode
        ForEach(deviceNames, id: \.self) { deviceName in
            /*
            // Mode lumineux (light mode)
            UIViewControllerPreview {
                HomeViewController()
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.light)
            .previewDisplayName("\(deviceName) (Light)")
            .edgesIgnoringSafeArea(.all)
             */
            
            // Mode sombre (dark mode)
            UIViewControllerPreview {
                let vc = ToiletMapViewController()
                guard let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else {
                    return vc
                }
                vc.managedObjectContext = container.viewContext
                return vc
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.dark)
            .previewDisplayName("\(deviceName) (Dark)")
            .edgesIgnoringSafeArea(.all)
        }
    }
}
#endif
