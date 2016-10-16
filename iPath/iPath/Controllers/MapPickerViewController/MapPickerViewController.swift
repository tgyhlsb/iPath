//
//  MapPickerViewController.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 16/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit

class MapPickerViewController: UIViewController {
    
    // MARK: - PUBLIC -
    
    public init(backend: BackendManager) {
        self.backend = backend
        super.init(nibName: "MapPickerViewController", bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - INTERNAL -
    
    internal var maps = [Map]()
    
    internal func selectMap(_ map: Map, animated: Bool) {
        let destination = RoutePickerViewController(map: map, backend: self.backend)
        self.navigationController?.pushViewController(destination, animated: animated)
    }
    
    // MARK: - PRIVATE -
    
    private let backend: BackendManager
    
    private var loadingCount: Int = 0 {
        didSet {
            guard self.loadingCount != oldValue else { return }
            if oldValue == 0 {
                self.setLoading(true, animated: true)
            }
            if self.loadingCount == 0 {
                self.setLoading(false, animated: true)
            }
        }
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Maps"
        self.initializeTableView()
        self.fetchList()
    }
    
    private func fetchList() {
        self.loadingCount += 1
        self.backend.listMaps { (result) in
            switch result {
            case .failure(let err):
                NSLog(err)
            case .success(let maps):
                for map in maps {
                    self.fetchMap(name: map)
                }
            }
            self.loadingCount -= 1
        }
    }
    
    private func fetchMap(name: String) {
        self.loadingCount += 1
        self.backend.fetchMap(name: name) { (result) in
            switch result {
            case .failure(let err):
                NSLog(err)
            case .success(let map):
                self.insert(map: map, animated: true)
            }
            self.loadingCount -= 1
        }
    }

    private func setLoading(_ loading: Bool, animated: Bool) {
        let animations = {
            self.tableView.alpha = loading ? 0 : 1
            self.activityIndicatorView.alpha = loading ? 1 : 0
        }
        guard animated else { return animations() }
        UIView.animate(withDuration: 0.33, animations: animations)
    }
    
    private func insert(map: Map, animated: Bool) {
        self.maps.append(map)
        self.reloadTableView(animated: true)
    }
    
}
