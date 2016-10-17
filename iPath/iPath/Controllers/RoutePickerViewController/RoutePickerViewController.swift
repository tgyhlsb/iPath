//
//  RoutePickerViewController.swift
//  iPath
//
//  Created by Tanguy Hélesbeux on 09/10/2016.
//  Copyright © 2016 Tanguy Helesbeux. All rights reserved.
//

import UIKit

class RoutePickerViewController: UIViewController {

    // MARK: - PUBLIC -
    
    public init(map: Map, backend: BackendManager) {
        self.map = map
        self.backend = backend
        super.init(nibName: "RoutePickerViewController", bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - INTERNAL -
    
    internal var routes = [Route]()
    
    internal func selectRoute(_ route: Route, animated: Bool) {
        let destination = RouteDetailsViewController(route: route)
        self.navigationController?.pushViewController(destination, animated: animated)
    }
    
    // MARK: - PRIVATE -
    
    private let backend: BackendManager
    private let map: Map
    
    private lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(RoutePickerViewController.addButtonTouchUpInside(_:)))
    }()
    
    private lazy var loadingItem: UIBarButtonItem = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.startAnimating()
        return UIBarButtonItem(customView: indicatorView)
    }()
    
    // MARK: IBOutlets

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Routes of \(self.map.name)"
        self.navigationItem.rightBarButtonItem = self.addButton
        self.initializeTableView()
    }
    
    // MARK: Handlers
    
    func addButtonTouchUpInside(_ sender: UIBarButtonItem) {
        self.requestNewRoute()
    }
    
    // MARK: - Backend
    
    private func requestNewRoute() {
        self.setLoading(true)
        self.backend.createRoute() { result in
            switch result {
            case .success(let token):
                self.backend.fetchRoute(map: self.map, token: token) { result in
                    switch result {
                    case .success(let route): return self.handleRequestSuccess(route)
                    case .failure(let error): return self.handleRequestFailure(error)
                    }
                }
            case .failure(let error): return self.handleRequestFailure(error)
            }
            self.setLoading(false)
        }
    }
    
    private func handleRequestSuccess(_ route: Route) {
        self.routes.append(route)
        self.reloadTableView(animated: true)
    }
    
    private func handleRequestFailure(_ error: String) {
        NSLog(error)
    }
    
    private func setLoading(_ loading: Bool) {
        self.navigationItem.rightBarButtonItem = loading ? self.loadingItem : self.addButton
    }
    
}
