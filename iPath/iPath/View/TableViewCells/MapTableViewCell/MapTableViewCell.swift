//
//  MapTableViewCell.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 16/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit

class MapTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - PUBLIC -
    
    public var map: Map? {
        didSet {
            guard let map = self.map else { return }
            self.udate(for: map)
        }
    }
    
    // MARK: - INTERNAL -
    
    // MARK: - PRIVATE -
    
    // MARK: IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
    }
    
    private func udate(for map: Map) {
        self.nameLabel.text = map.name
    }
}
