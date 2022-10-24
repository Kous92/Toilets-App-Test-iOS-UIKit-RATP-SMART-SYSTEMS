//
//  ToiletEntityMethods.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 18/10/2022.
//

import Foundation
import CoreData

extension ToiletEntity {
    class func fetchAllToilets(context: NSManagedObjectContext) throws -> [ToiletEntity] {
        var toilets = [ToiletEntity]()
        let fetchRequest: NSFetchRequest<ToiletEntity> = ToiletEntity.fetchRequest()
        
        toilets = try context.fetch(fetchRequest)
        
        return toilets
    }
}
