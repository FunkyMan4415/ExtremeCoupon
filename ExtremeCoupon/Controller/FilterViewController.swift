//
//  FilterViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 12.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit


protocol FilterDelegate {
    func didAddFilter(_ filter: String, add: Bool)
    
}

class FilterViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var selectedMarkets: [String]?
    var delegate: FilterDelegate?
    var markets = [Market]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        markets.removeAll()
        if let cachedMarkets = FirebaseHelper.getCachedMarkets() {
            self.markets = cachedMarkets
            self.tableView.reloadData()
        } else {
            FirebaseHelper.getAllMarkets { (markets) in
                self.markets = markets
                self.tableView.reloadData()
            }
        }
    }
}

extension FilterViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        cell.textLabel?.text = markets[indexPath.row].title
        
        if let filterValues = selectedMarkets{
            for value in filterValues {
                if cell.textLabel?.text == value {
                    cell.accessoryType = .checkmark
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            delegate?.didAddFilter(markets[indexPath.row].title, add: false)
        } else {
            cell?.accessoryType = .checkmark
            delegate?.didAddFilter(markets[indexPath.row].title, add: true)
        }     
    }
}
