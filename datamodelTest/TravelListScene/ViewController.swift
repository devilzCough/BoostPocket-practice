//
//  ViewController.swift
//  datamodelTest
//
//  Created by sihyung you on 2020/11/18.
//  Copyright © 2020 SihyungYou. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    private var context: NSManagedObjectContext?
    @IBOutlet weak var tableView: UITableView!
    var travels: [Travel] = [Travel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "여행목록"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.context = appDelegate.persistentContainer.viewContext
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TravelTableViewCell.identifier, bundle: .main), forCellReuseIdentifier: TravelTableViewCell.identifier)
        
        fetchTravels()
    }
    
    
    private func fetchTravels() {
        // load data from core data
        do {
            // update travels datasource
            self.travels = try context?.fetch(Travel.fetchRequest()) as! [Travel]
        } catch {
            print(error.localizedDescription)
        }

        // reload tableview
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        guard let countriesViewController = storyboard.instantiateViewController(withIdentifier: CountriesViewController.identifier) as? CountriesViewController else { return }
        
        countriesViewController.addCountryButtonTapped = { [weak self] (travelTitle, selectedCountry) in
            guard let self = self,
                let context = self.context,
                let countryName = selectedCountry.countryName
                else { return }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
            fetchRequest.predicate = NSPredicate(format: "countryName == %@", countryName)
            
            do {
                guard let country = try context.fetch(fetchRequest) as? [Country] else { return }
                
                let newTravel = Travel(context: context)
                newTravel.title = travelTitle
                newTravel.country = country.first
                
                try self.context?.save()
            } catch {
                print(error.localizedDescription)
            }
            
            self.fetchTravels()
        }
        
        let navigationController = UINavigationController(rootViewController: countriesViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        // guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TravelTableViewCell.identifier, for: indexPath) as? TravelTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: travels[indexPath.row])
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let `self` = self else { return }
            
            // what to remove?
            let travelToRemove = self.travels[indexPath.row]
            
            // remove travel from core data
            self.context?.delete(travelToRemove)
            
            // update core date
            do {
                try self.context?.save()
            } catch {
                print(error.localizedDescription)
            }
            
            // refetch datasource
            self.fetchTravels()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
