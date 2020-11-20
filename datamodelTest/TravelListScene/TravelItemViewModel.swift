//
//  TravelItemViewModel.swift
//  datamodelTest
//
//  Created by sihyung you on 2020/11/20.
//  Copyright © 2020 SihyungYou. All rights reserved.
//

import Foundation

protocol TravelItemViewModelProtocol {
    var budget: Float { get }
    var title: String? { get }
    var coverImage: Data? { get }
    var currencyCode: String? { get }
    var endDate: Date? { get }
    var startDate: Date? { get }
    var memo: String? { get }
    var exchangeRate: Float { get }
}

class TravelItemViewModel: TravelItemViewModelProtocol {
    private(set) var budget: Float = 0.0
    private(set) var title: String?
    private(set) var coverImage: Data?
    private(set) var currencyCode: String?
    private(set) var endDate: Date?
    private(set) var startDate: Date?
    private(set) var memo: String?
    private(set) var exchangeRate: Float
    
    init(travel: Travel) {
        self.budget = travel.budget
        self.title = travel.title
        self.coverImage = travel.coverImage
        self.currencyCode = travel.currencyCode
        self.startDate = travel.startDate
        self.endDate = travel.endDate
        self.memo = travel.memo
        self.exchangeRate = travel.exchangeRate
    }
    
}
