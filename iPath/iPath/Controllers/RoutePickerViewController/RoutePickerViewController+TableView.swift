//
//  RoutePickerViewController+TableView.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 10/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit

extension RoutePickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - PUBLIC -
    
    // MARK: - INTERNAL -
    
    internal func initializeTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    internal func reloadTableView(animated: Bool) {
        guard animated else {
            return self.tableView.reloadData()
        }
        let section = IndexSet(integer: 0)
        self.tableView.reloadSections(section, with: .automatic)
    }
    
    // MARK: - PRIVATE -
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "route")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "route")
        }
        let route = self.route(for: indexPath)!
        cell?.textLabel?.text = self.text(from: route)
        
        return cell!
    }
    
    private func text(from route: Route) -> String {
        return "From \(route.start.name) to \(route.end.name)"
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let route = self.route(for: indexPath) else { return }
        self.selectRoute(route, animated: true)
    }
    
    // MARK: Helpers
    
    private func route(for indexPath: IndexPath) -> Route? {
        let index = indexPath.row
        guard index >= 0 && index < self.routes.count else { return nil }
        return self.routes[indexPath.row]
    }
}
