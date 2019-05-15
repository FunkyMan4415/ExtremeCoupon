//
//  FilterViewController.swift
//  ExtremeCoupon
//
//  Created by Christian Dobrovolny on 12.05.19.
//  Copyright © 2019 Christian Dobrovolny. All rights reserved.
//

import UIKit


protocol FilterDelegate {
    func didAddFilter(_ filter: Market?)
    func didRemoveFilter(_ filter: Market?)
}

class FilterViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var selectedMarket: String?
    var delegate: FilterDelegate?
    var markets = [Market]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        FirebaseHelper.getAllMarkets { (markets) in
            self.markets = markets
            self.tableView.reloadData()
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
        
        if let filterValue = selectedMarket {
            if cell.textLabel?.text == filterValue {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        
        for i in tableView.indexPathsForVisibleRows! {
            if i != indexPath {
                let c = tableView.cellForRow(at: i)
                c?.accessoryType = .none
            }
            
        }
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            delegate?.didAddFilter(nil)
        } else {
            cell?.accessoryType = .checkmark
            delegate?.didAddFilter(markets[indexPath.row])
        }
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .none
        delegate?.didRemoveFilter(nil)
    }
}
