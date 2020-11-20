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
    private var travelProvider: TravelProvidable?
    @IBOutlet weak var tableView: UITableView!
    var travelListViewModel: TravelListViewModelProtocol? {
        didSet {
            travelListViewModel?.didFetch = { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "여행목록"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.context = appDelegate.persistentContainer.viewContext
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TravelTableViewCell.identifier, bundle: .main), forCellReuseIdentifier: TravelTableViewCell.identifier)
        
        travelProvider = TravelProvider(context: context)
        travelListViewModel = TravelListViewModel(travelProvider: travelProvider!)
        fetchTravels()
    }
    
    
    private func fetchTravels() {
        travelListViewModel?.needFetchItems()
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        guard let countriesViewController = storyboard.instantiateViewController(withIdentifier: CountriesViewController.identifier) as? CountriesViewController else { return }
        
        countriesViewController.addCountryButtonTapped = { [weak self] (travelTitle, selectedCountry) in
            guard let self = self,
                let countryName = selectedCountry.countryName
                else { return }

            self.travelListViewModel?.addTravel(title: travelTitle, countryName: countryName)
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
        return travelListViewModel?.numberOfItem() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TravelTableViewCell.identifier, for: indexPath) as? TravelTableViewCell,
            let travelItemViewModel = travelListViewModel?.cellForItemAt(indexPath: indexPath)
            else { return UITableViewCell() }
        
        cell.configure(with: travelItemViewModel)
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
//            guard let `self` = self else { return }
//
//            // what to remove?
//            let travelToRemove = self.travels[indexPath.row]
//
//            // remove travel from core data
//            self.context?.delete(travelToRemove)
//
//            // update core date
//            do {
//                try self.context?.save()
//            } catch {
//                print(error.localizedDescription)
//            }
//
//            // refetch datasource
//            self.fetchTravels()
//        }
//
//        return UISwipeActionsConfiguration(actions: [action])
//    }
}
