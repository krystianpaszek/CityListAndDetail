//
//  ViewController.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 14/11/2020.
//

import UIKit

private let kCityListCellIdentifier = "city_list_cell"

class CityListController: UITableViewController {

    enum LoadingState {
        case loading, error, data(cities: [City])
    }

    // MARK: - Dependencies
    private let dataStore: DataStoreProtocol
    private let imageDownloader: ImageDownloaderProtocol
    private var state: LoadingState = .loading {
        didSet {
            DispatchQueue.main.async {
                self.apply(self.state)
            }
        }
    }
    private var showOnlyFavorited: Bool = false {
        didSet {
            setupFavoriteButton()
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }

    // MARK: - Initialization
    init(dataStore: DataStoreProtocol, imageDownloader: ImageDownloader) {
        self.dataStore = dataStore
        self.imageDownloader = imageDownloader
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCityListCellIdentifier)
    }

    private func setupNavigationItems() {
        setupFavoriteButton()
        setupRefreshButton()
    }

    private func setupFavoriteButton() {
        let image = showOnlyFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        let favoriteFilterItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toggleFavoriteFiltering(sender:)))
        navigationItem.rightBarButtonItem = favoriteFilterItem
    }

    private func setupRefreshButton() {
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData))
        navigationItem.leftBarButtonItem = refreshItem
    }

    private func setupLoadingButton() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()

        let loadingItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.leftBarButtonItem = loadingItem
    }

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

        let indexPath = IndexPath(row: sender.tag, section: 0)
        if showOnlyFavorited {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    @objc private func toggleFavoriteFiltering(sender: UIBarButtonItem) {
        showOnlyFavorited.toggle()
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
            setupLoadingButton()

        case .data(_):
            setupRefreshButton()
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .error, .loading:
            return 0
        case .data(let cities):
            return filtered(cities).count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .data(cities) = state else {
            return
        }

        let city = filtered(cities)[indexPath.row]
        let detailController = CityDetailController(cityID: city.id, dataStore: dataStore)
        navigationController?.pushViewController(detailController, animated: true)
    }
}
