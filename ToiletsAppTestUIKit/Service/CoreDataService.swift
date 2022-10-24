//
//  CoreDataService.swift
//  ToiletsAppTestUIKit
//
//  Created by Koussaïla Ben Mamar on 18/10/2022.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {
    static let sharedInstance = CoreDataService()
    private init(){}
    
    private let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    private let fetchRequest = NSFetchRequest<ToiletEntity>(entityName: "ToiletEntity")
    
    func saveData(with toilets: [Toilet]) {
        // Dans une tâche de fond
        self.container?.performBackgroundTask { [weak self] (context) in
            print("\n\n>>> Contenu sauvegardé:\n\(self?.fetchToilets(context: context).compactMap { $0.adresse } )")
            print("Lancement de la sauvegarde des données téléchargées.")
            
            if let count = self?.checkToilets(context: context), count > 0 {
                print("-> Des données sont déjà sauvegardées.")
                self?.deleteAllSavedToiletsData(context: context)
            }

            self?.saveToiletsDataLocally(with: toilets, context: context)
            print("Sauvegarde terminée.")
            // print("\n\n>>> Contenu sauvegardé:\n\(self?.fetchToilets(context: context))")
        }
    }
    
    // Supprimer toute donnée sauvegardée localement avant d'en sauvegarder des nouvelles
    private func deleteAllSavedToiletsData(context: NSManagedObjectContext) {
        print("-> Suppression des anciens contenus sauvegardés.")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "ToiletEntity"))
        do {
            try context.execute(deleteRequest)
            // Save Data
            try context.save()
        } catch {
            print("Une erreur est survenue lors de la suppression: \(error)")
        }
    }
    
    
    private func saveToiletsDataLocally(with toilets: [Toilet], context: NSManagedObjectContext) {
        print("-> Sauvegarde de \(toilets.count) toilettes.")
        
        context.perform {
            for toilet in toilets {
                let toiletEntity = ToiletEntity(context: context)
                toiletEntity.accesPmr = toilet.fields?.accesPmr
                toiletEntity.adresse = toilet.fields?.adresse
                toiletEntity.arrondissement = Int64(toilet.fields?.arrondissement ?? 75000)
                toiletEntity.coordinates = toilet.fields?.geoPoint2D
                toiletEntity.gestionnaire = toilet.fields?.gestionnaire
                toiletEntity.horaires = toilet.fields?.horaire
                toiletEntity.relaisBebe = toilet.fields?.relaisBebe
                toiletEntity.source = toilet.fields?.source
                toiletEntity.type = toilet.fields?.type
                toiletEntity.urlFicheEquipement = toilet.fields?.urlFicheEquipement
            }
            
            // Save Data
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    func checkToilets(context: NSManagedObjectContext) -> Int {
        let fetchRequest: NSFetchRequest<ToiletEntity>
        fetchRequest = ToiletEntity.fetchRequest()
        
        var count = 0
        
        do {
            count = try context.count(for: self.fetchRequest)
        } catch {
            fatalError("Erreur comptage: \(error)")
        }
        
        return count
    }
    
    func fetchToilets(context: NSManagedObjectContext) -> [ToiletEntity] {
        print("-> Récupération des toilettes")
        
        var toilets = [ToiletEntity]()
        let fr: NSFetchRequest<ToiletEntity> = ToiletEntity.fetchRequest()
        
        do {
            // Peform Fetch Request
            toilets = try context.fetch(fr)
            print(toilets)
            
            if toilets.count > 0 {
                print("-> Nombre de toilettes dans la base de données: \(toilets.count)")
            } else {
                print("-> Aucune toilette dans la base de données: \(toilets.count)")
            }
        } catch {
            print("Une erreur est survenue lors de la récupération des toilettes: (\(error))")
        }
        
        return toilets
    }
}
