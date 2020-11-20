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
    // MARK: - Actions
    @objc private func favoriteCity(sender: UIButton) {
        guard case let .data(cities) = state else { return }
        let city = filtered(cities)[sender.tag]

        dataStore.addToFavorites(id: city.id)
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
    }

    @objc private func unfavoriteCity(sender: UIButton) {
        guard case let .data(cities) = state else { return }
        let city = filtered(cities)[sender.tag]

        dataStore.removeFromFavorites(id: city.id)
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
    }

    }

    // MARK: - Private functions
    @objc private func reloadData() {
        loadData(reload: true)
    }

    private func loadData(reload: Bool = false) {
        self.state = .loading
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

    private func filtered(_ cities: [City]) -> [City] {
        guard showOnlyFavorited else {
            return cities
        }

        return cities.filter({ dataStore.isCityFavorite(id: $0.id) })
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension CityListController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .error, .loading:
            return 0
        case .data(let cities):
            return filtered(cities).count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case let .data(cities) = state else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: kCityListCellIdentifier, for: indexPath)
        let city = filtered(cities)[indexPath.row]

        let favoriteButton = UIButton()
        let isFavorited = dataStore.isCityFavorite(id: city.id)
        let image = isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        let selector = isFavorited ? #selector(unfavoriteCity(sender:)) : #selector(favoriteCity(sender:))
        favoriteButton.tag = indexPath.row
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.addTarget(self, action: selector, for: .touchUpInside)
        favoriteButton.sizeToFit()

        cell.textLabel?.text = city.name
        cell.accessoryView = favoriteButton

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
