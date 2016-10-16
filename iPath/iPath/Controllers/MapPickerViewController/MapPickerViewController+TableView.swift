//
//  MapPickerViewController+TableView.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 16/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit

extension MapPickerViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - PUBLIC -
    
    // MARK: - INTERNAL -
    
    internal func initializeTableView() {
        self.tableView.registerReusableCell(MapTableViewCell.self)
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
        return self.maps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MapTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.map = self.map(for: indexPath)!
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let map = self.map(for: indexPath) else { return }
        self.selectMap(map, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Helpers
    
    private func map(for indexPath: IndexPath) -> Map? {
        let index = indexPath.row
        guard index >= 0 && index < self.maps.count else { return nil }
        return self.maps[indexPath.row]
    }
    
}
