//
//  TravelProvider.swift
//  datamodelTest
//
//  Created by sihyung you on 2020/11/20.
//  Copyright © 2020 SihyungYou. All rights reserved.
//

import Foundation
import CoreData

protocol TravelProvidable: AnyObject {
    var travels: [Travel] { get }
    var context: NSManagedObjectContext? { get }
    func fetchTravels(completion: ([Travel]?) -> Void)
    func addTravel(title: String, countryName: String, completion: (Travel?) -> Void)
}

class TravelProvider: TravelProvidable {
    private(set) weak var context: NSManagedObjectContext?
    private(set) var travels: [Travel] = []
    
    init(context: NSManagedObjectContext?) {
        self.context = context
    }
    
    func fetchTravels(completion: ([Travel]?) -> Void) {
        guard let fetchedTravels = try? context?.fetch(Travel.fetchRequest()) as? [Travel] else { return }
        
        self.travels = fetchedTravels
        
        completion(fetchedTravels)
    }
    
    func addTravel(title: String, countryName: String, completion: (Travel?) -> Void) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
            fetchRequest.predicate = NSPredicate(format: "countryName == %@", countryName)
            
            guard let context = self.context,
                let country = try context.fetch(fetchRequest) as? [Country]
                else { return }
            
            let newTravel = Travel(context: context)
            newTravel.title = title
            newTravel.country = country.first
            
            try context.save()
            
            completion(newTravel)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
}
