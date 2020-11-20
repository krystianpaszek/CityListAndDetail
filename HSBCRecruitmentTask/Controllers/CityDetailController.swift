//
//  CityDetailController.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import UIKit

class CityDetailController: UIViewController {

    // MARK: - Dependencies
    private let dataStore: DataStoreProtocol
    private let cityID: UUID

    // MARK: - Initialization
    init(cityID: UUID, dataStore: DataStoreProtocol) {
        self.dataStore = dataStore
        self.cityID = cityID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        guard let city = dataStore.getCity(withID: cityID) else {
            // show error
            return
        }

        title = city.name

        setupViews(with: city)
    }

    // MARK: - Setup
    private func setupViews(with city: City) {
        title = city.name
    }

}
