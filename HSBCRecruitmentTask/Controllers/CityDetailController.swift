//
//  CityDetailController.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import UIKit

private let kStackViewInset = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

class CityDetailController: UIViewController {

    // MARK: - Dependencies
    private let imageDownloader: ImageDownloaderProtocol
    private let dataStore: DataStoreProtocol
    private let cityID: UUID

    // MARK: - State
    private var imageDownloadTask: URLSessionDataTask?

    // MARK: - Views
    private var populationStackView: UIStackView!
    private var ratingStackView: UIStackView!

    // MARK: - Initialization
    init(cityID: UUID, dataStore: DataStoreProtocol, imageDownloader: ImageDownloaderProtocol) {
        self.imageDownloader = imageDownloader
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
        loadData()
    }

    deinit {
        imageDownloadTask?.cancel()
    }

    // MARK: - Setup
    private func setupViews(with city: City) {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem

        stackView.addArrangedSubview(setupImageThumbnail(city: city))
        stackView.addArrangedSubview(setupPopulationRow())
        stackView.addArrangedSubview(setupRatingRow())

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: stackView.topAnchor),
        ])
    }

    private func setupImageThumbnail(city: City) -> UIView {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        imageDownloadTask = imageDownloader.fetchImage(with: city.image) { (image, error) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }

        return imageView
    }

    private func setupPopulationRow() -> UIView {
        let populationStackView = makeStackViewRow(labelText: "Population:")
        self.populationStackView = populationStackView

        return populationStackView
    }

    private func setupRatingRow() -> UIView {
        let ratingStackView = makeStackViewRow(labelText: "Rating:")
        self.ratingStackView = ratingStackView

        return ratingStackView
    }

    // MARK: - Private functions
    private func loadData() {
        let group = DispatchGroup()

        group.enter()
        dataStore.getCityRating(reload: false, id: cityID) { (_, _) in group.leave() }

        group.enter()
        dataStore.getCityPopulation(reload: false, id: cityID) { (_, _) in group.leave() }

        group.notify(queue: .main) {
            self.showLoadedData()
        }
    }

    private func showLoadedData() {
        let city = dataStore.getCity(withID: cityID)
        showResultOrError(value: city?.population?.population, errorMessage: "Error loading city's rating", in: populationStackView)
        showResultOrError(value: city?.rating?.rating, errorMessage: "Error loading city's population", in: ratingStackView)
    }

    private func showResultOrError(value: Any?, errorMessage: String, in stackView: UIStackView) {
        stackView.arrangedSubviews.first(where: { $0 is UIActivityIndicatorView })?.removeFromSuperview()

        let label = UILabel()
        if let value = value {
            label.text = "\(value)"
        } else {
            label.text = errorMessage
        }

        stackView.addArrangedSubview(label)
    }


}

private func makeStackViewRow(labelText: String) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.directionalLayoutMargins = kStackViewInset

    let mainLabel = UILabel()
    mainLabel.text = labelText
    mainLabel.setContentHuggingPriority(.required, for: .horizontal)
    let spacer = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.startAnimating()

    stackView.addArrangedSubview(mainLabel)
    stackView.addArrangedSubview(spacer)
    stackView.addArrangedSubview(activityIndicator)

    return stackView
}
