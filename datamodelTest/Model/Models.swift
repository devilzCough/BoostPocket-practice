//
//  DecodedCountry.swift
//  datamodelTest
//
//  Created by sihyung you on 2020/11/18.
//  Copyright © 2020 SihyungYou. All rights reserved.
//

import Foundation

struct DecodedCountry: Codable {
    let identifier: String
}

struct ExchangeRate: Codable {
    let rates: [String:Float]
    let base: String
    let date: String
}

/*
{
"rates":{
"CAD":1.3072126727,
"HKD":7.7523592855,
"ISK":136.0802157061,
"PHP":48.2532861476,
"DKK":6.2787327267,
"HUF":303.5473542299,
"CZK":22.2455342096,
"GBP":0.7530586451,
"RON":4.1059993259,
"SEK":8.6059150657,
"IDR":14110.9959555106,
"INR":74.1582406471,
"BRL":5.3062015504,
"RUB":75.8855746545,
"HRK":6.3759689922,
"JPY":103.8759689922,
"THB":30.3201887428,
"CHF":0.9110212336,
"EUR":0.8426019548,
"MYR":4.0874620829,
"BGN":1.6479609033,
"TRY":7.7148634985,
"CNY":6.5571284125,
"NOK":9.0255308392,
"NZD":1.4446410516,
"ZAR":15.4039433771,
"USD":1.0,
"MXN":20.2312942366,
"SGD":1.3411695315,
"AUD":1.3672059319,
"ILS":3.3486686889,
"KRW":1104.271991911,
"PLN":3.7659251769
},
"base":"USD",
"date":"2020-11-18"
}*/
