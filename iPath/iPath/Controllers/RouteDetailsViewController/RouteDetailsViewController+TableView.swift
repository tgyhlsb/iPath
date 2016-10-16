//
//  RouteDetailsViewController+TableView.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 17/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit

extension RouteDetailsViewController: UITableViewDataSource {
    
    // MARK: - PUBLIC -
    
    // MARK: - INTERNAL -
    
    internal func initializeTableView() {
        self.tableView.dataSource = self
    }
    
    internal func reloadTableView() {
        self.tableView.reloadData()
    }
    
    // MARK: - PRIVATE -
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let path = self.activePath else { return 0 }
        return path.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "placeCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = self.place(for: indexPath)?.name
        
        return cell!
    }
    
    private func place(for indexPath: IndexPath) -> Place? {
        return self.activePath?[indexPath.row]
    }
    
}
