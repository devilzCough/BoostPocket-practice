//
//  TravelListViewModel.swift
//  datamodelTest
//
//  Created by sihyung you on 2020/11/20.
//  Copyright © 2020 SihyungYou. All rights reserved.
//

import Foundation

protocol TravelListViewModelProtocol {
    var travels: [TravelItemViewModel] { get }
    var didFetch: (() -> Void)? { get set }
    func needFetchItems()
    func addTravel(title: String, countryName: String)
    func numberOfItem() -> Int
    func cellForItemAt(indexPath: IndexPath) -> TravelItemViewModel?
}

class TravelListViewModel: TravelListViewModelProtocol {
    var didFetch: (() -> Void)?
    private weak var travelProvider: TravelProvidable?
    private(set) var travels: [TravelItemViewModel] = []
    
    init(travelProvider: TravelProvidable) {
        self.travelProvider = travelProvider
    }
    
    func needFetchItems() {
        travelProvider?.fetchTravels { [weak self] (travels) in
            guard let self = self, let travels = travels else { return }
            travels.forEach { travel in
                self.travels.append(TravelItemViewModel(travel: travel))
            }
            DispatchQueue.main.async {
                self.didFetch?()
            }
        }
    }
    
    func addTravel(title: String, countryName: String) {
        travelProvider?.addTravel(title: title, countryName: countryName) { [weak self ](addedTravel) in
            guard let self = self,
                let addedTravel = addedTravel
                else { return }
            self.travels.append(TravelItemViewModel(travel: addedTravel))
            DispatchQueue.main.async {
                self.didFetch?()
            }
        }
    }
    
    func numberOfItem() -> Int {
        return travels.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> TravelItemViewModel? {
        return travels[indexPath.row]
    }
}
 
