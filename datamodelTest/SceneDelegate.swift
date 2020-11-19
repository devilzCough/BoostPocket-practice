//
//  SceneDelegate.swift
//  datamodelTest
//
//  Created by sihyung you on 2020/11/18.
//  Copyright © 2020 SihyungYou. All rights reserved.
//

import UIKit
import CoreData
import FlagKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        var countries = [Country]()
        let context = appDelegate.persistentContainer.viewContext
        
        getExchangeRate() { [weak self] (exchangeRates) in
            guard let self = self else { return }

            do {
                countries = try context.fetch(Country.fetchRequest()) as! [Country]
                
                if countries.count <= 0, let mainFileLocation = Bundle.main.url(forResource: "validCountries", withExtension: "json") {
                    print("countries.count <= 0 : \(countries.count)")
                    
                    let mainData = try Data(contentsOf: mainFileLocation)
                    let decodedCountries = try JSONDecoder().decode([DecodedCountry].self, from: mainData)
                    
                    decodedCountries.forEach { decodedCountry in
                        let identifier = decodedCountry.identifier
                        
                        if let countryCode = self.getCountryCode(with: identifier),
                            let currencyCode = self.getCurrencyCode(with: identifier),
                            let exchangeRate = exchangeRates.rates[currencyCode] {
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                            let date: Date = dateFormatter.date(from: exchangeRates.date) ?? Date()
                            
                            let newCountry = Country(context: context)
                            newCountry.countryName = self.getCountryName(with: identifier)
                            newCountry.lastUpdated = date
                            newCountry.exchangeRate = exchangeRate
                            newCountry.flag = self.getFlagImageFromPod(with: countryCode)
                            newCountry.identifier = identifier
                            
                            do {
                                try context.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                else if countries.count > 0 {
                    print("countries > 0 : \(countries.count)")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func getCountryCode(with identifier: String) -> String? {
        let locale = NSLocale(localeIdentifier: identifier)
        return locale.countryCode
    }
    
    private func getCountryName(with identifier: String) -> String? {
        let localeKR = NSLocale(localeIdentifier: "ko_KR")
        return localeKR.displayName(forKey: NSLocale.Key.identifier, value: identifier)
    }
    
    private func getCurrencyCode(with identifier: String) -> String? {
        let locale = NSLocale(localeIdentifier: identifier)
        return locale.currencyCode
    }
    
    private func getExchangeRate(completion: @escaping (ExchangeRate) -> Void) {
        guard let url = URL(string: "https://api.exchangeratesapi.io/latest?base=KRW") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            
            let jsonDecoder = JSONDecoder()
            do {
                let exchangeRates = try jsonDecoder.decode(ExchangeRate.self, from: data)
                completion(exchangeRates)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func getFlag(with countryCode: String) -> String {
        let flagURL = "https://flagcdn.com/h60/\(countryCode.lowercased()).jpg"
        return flagURL
    }
    
    private func getFlagImage(with countryCode: String, completion: @escaping (Data?) -> Void) {
        let urlString: String = getFlag(with: countryCode)
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        completion(try? Data(contentsOf: url))
    }
    
    private func getFlagImageFromPod(with countryCode: String) -> Data? {
        let flagImage = Flag(countryCode: countryCode)
        return flagImage?.originalImage.pngData()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

