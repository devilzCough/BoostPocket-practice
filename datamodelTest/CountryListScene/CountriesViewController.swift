//
//  CountriesViewController.swift
//  datamodelTest
//
//  Created by sihyung you on 2020/11/18.
//  Copyright © 2020 SihyungYou. All rights reserved.
//

import UIKit
import CoreData

class CountriesViewController: UIViewController {
    private var context: NSManagedObjectContext?
    static let identifier = "CountriesViewController"
    @IBOutlet weak var tableView: UITableView!
    
    var addCountryButtonTapped: ((String, Country) -> Void)?
    var countries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.context = appDelegate.persistentContainer.viewContext
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CountryTableViewCell.identifier, bundle: .main),
                           forCellReuseIdentifier: CountryTableViewCell.identifier)
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        title = "여행할 나라를 선택해주세요"
        
        fetchCountries()
    }
    
    @objc func cancelButtonTapped() {
        countries.forEach { country in
            context?.delete(country)
            do {
                try context?.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
        let alert = UIAlertController(title: "Add Travel", message: "새 여행을 추가하세요", preferredStyle: .alert)
        
        alert.addTextField { (titleField) in
            titleField.placeholder = "여행 제목"
        }
        
        let submitButtonTapped = UIAlertAction(title: "Add", style: .default) { [weak self] (action) in
            guard let self = self,
                let indexPath = self.tableView.indexPathForSelectedRow,
                let travelTitle = alert.textFields?.first?.text
                else { return }
            
            let selectedCountry = self.countries[indexPath.row]
            
            self.dismiss(animated: true) {
                self.addCountryButtonTapped?(travelTitle, selectedCountry)
            }
        }
        
        alert.addAction(submitButtonTapped)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func fetchCountries() {
        do {
            self.countries = try context?.fetch(Country.fetchRequest()) as! [Country]
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

extension CountriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier, for: indexPath) as? CountryTableViewCell else { return UITableViewCell() }
        
        let currentCountry = countries[indexPath.row]
        
        // if currentCountry has been selected -> cell?.accessoryType = .checkmark
        
        cell.configure(with: currentCountry)
        
        return cell
    }
    
}

extension CountriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .none
    }
}
