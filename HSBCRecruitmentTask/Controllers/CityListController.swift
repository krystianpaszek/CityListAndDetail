//
//  ViewController.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 14/11/2020.
//

import UIKit

private let kCityListCellIdentifier = "city_list_cell"

class CityListController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    enum LoadingState {
        case loading, error, data(cities: [City])
    }

    // MARK: - Dependencies
    private let dataStore: DataStoreProtocol
    private var state: LoadingState = .loading {
        didSet {
            DispatchQueue.main.async {
                self.apply(self.state)
            }
        }
    }

    // MARK: - Views
    private var tableView: UITableView!

    // MARK: - Initialization
    init(dataStore: DataStoreProtocol) {
        self.dataStore = dataStore
        super.init(nibName: nil, bundle: nil)

        setupNavigationItems()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Cities"
        view.backgroundColor = .systemBackground

        setupTableView()

        loadData()
    }

    // MARK: - Setup
    private func setupTableView() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCityListCellIdentifier)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        ])

        tableView.dataSource = self
        tableView.delegate = self

        self.tableView = tableView
    }

    private func setupNavigationItems() {
    }

    // MARK: - Private functions
    private func loadData() {
        dataStore.getCityList(reload: false) { (cities, error) in
            guard let cities = cities else {
                self.state = .error
                return
            }

            self.state = .data(cities: cities)
        }
    }

    private func apply(_ state: LoadingState) {
        switch state {
        case .error:
            return

        case .loading:
            return

        case .data(_):
            tableView.reloadData()
            return
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension CityListController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .error, .loading:
            return 0
        case .data(let cities):
            return cities.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case let .data(cities) = state else {
            return UITableViewCell()
        }

        var cell = tableView.dequeueReusableCell(withIdentifier: kCityListCellIdentifier, for: indexPath)
        let city = cities[indexPath.row]
        configure(cell: &cell, with: city)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

private func configure(cell: inout UITableViewCell, with city: City) {
    cell.textLabel?.text = city.name
}
