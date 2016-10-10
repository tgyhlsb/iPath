//
//  RouteTableViewCell.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 10/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - PUBLIC -
    
    public var route: Route! {
        didSet {
            guard self.route != oldValue else { return }
            self.update(for: route)
        }
    }
    
    // MARK: - INTERNAL -
    
    // MARK: - PRIVATE -
    
    // MARK: IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
    }
    
    private func update(for route: Route) {
        self.titleLabel.text = "From \(route.start.name)"
        self.subtitleLabel.text = "To \(route.end.name)"
    }
    
}
