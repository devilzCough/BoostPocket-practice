////
////  Travel.swift
////  datamodelTest
////
////  Created by sihyung you on 2020/11/18.
////  Copyright © 2020 SihyungYou. All rights reserved.
////
//
//import Foundation
//
//final class Travel {
//    private(set) var title: String?
//    private(set) var memo: String?
//    private(set) var startDate: Date?
//    private(set) var endDate: Date?
//    private(set) var country: Country
//    private(set) var coverImage: String?
//    private(set) var records: [Recordable] = []
//    private(set) var budget: Float = 0.0
//    let currencyCode: String
//    let exchangeRate: Float
//
//    var spent: Float {
//        get {
//            let expenses = records.filter { $0.type == .expense }
//            return expenses.reduce(0) { $0 + $1.amount }
//        }
//    }
//
//    var remain: Float {
//        get {
//            return budget - spent
//        }
//    }
//
//    // 여행이 생성되는 시점
//    init(country: Country) {
//        self.country = country
//
//        let locale = NSLocale(localeIdentifier: country.identifier)
//        if let currencyCode = locale.currencyCode {
//            self.currencyCode = currencyCode
//        } else {
//            self.currencyCode = ""
//        }
//
//        if let countryCode = locale.countryCode {
//            print("\(country.name) : \(countryCode)")
//        }
//
//        // currencyCode로 환율 GET -> exchangeRate
//        let exchangeRate: Float = 1.0
//        self.exchangeRate = exchangeRate
//    }
//
//    func setStartDate(startDate: Date) {
//        self.startDate = startDate
//    }
//
//}
//
//struct Country: Codable {
//    let identifier: String
//    let name: String
//    let flag: String
//
//    init(identifier: String, name: String, flag: String) {
//        self.identifier = identifier
//        self.name = name
//        self.flag = flag
//    }
//}
//
//protocol Recordable {
//    var type: RecordType { get set }
//    var expenseType: ExpenseType? { get set }
//    var category: Category { get set }
//    var title: String? { get set }
//    var amount: Float { get set }
//    var date: Date { get set }
//    var description: String? { get set }
//    var image: String? { get set }
//    var isPrep: Bool? { get set }
//}
//
//final class Record: Recordable {
//    var expenseType: ExpenseType?
//    var image: String?
//    var isPrep: Bool?
//
//    var type: RecordType
//    var category: Category
//    var title: String?
//    var amount: Float
//    var date: Date = Date()
//    var description: String?
//
//    init(expenseType: ExpenseType? = nil, image: String? = nil, isPrep: Bool? = nil,
//         type: RecordType, category: Category, title: String? = nil, amount: Float, date: Date, description: String? = nil) {
//        self.expenseType = expenseType
//        self.image = image
//        self.isPrep = isPrep
//        self.type = type
//        self.category = category
//        self.title = title
//        self.amount = amount
//        self.date = date
//        self.description = description
//    }
//}
//
//enum RecordType {
//    case income
//    case expense
//}
//
//enum ExpenseType {
//    case card
//    case cash
//}
//
//enum Category: String {
//    case shopping = "쇼핑"
//    case eating = "식비"
//    case travel = "관광"
//    case transport = "교통"
//    case hotel = "숙박"
//    case etc = "기타"
//    case income = "수입"
//}
