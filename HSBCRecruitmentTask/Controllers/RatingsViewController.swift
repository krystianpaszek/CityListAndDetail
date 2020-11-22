//
//  RatingsViewController.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 22/11/2020.
//

import UIKit

private let kStackViewInset = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

struct CityRatingBreakdown {
    let oneStarRatingsCount: Int
    let twoStarRatingsCount: Int
    let threeStarRatingsCount: Int
    let fourStarRatingsCount: Int
    let fiveStarRatingsCount: Int

    var sumOfAllRatingCounts: Int {
        oneStarRatingsCount + twoStarRatingsCount + threeStarRatingsCount + fourStarRatingsCount + fiveStarRatingsCount
    }
}

class RatingsViewController: UIViewController {

    // MARK: - State
    private let ratingBreakdown: CityRatingBreakdown

    // MARK: - Initialization
    init(ratingBreakdown: CityRatingBreakdown) {
        self.ratingBreakdown = ratingBreakdown
        super.init(nibName: nil, bundle: nil)

        setupNavigationBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Ratings breakdown"
        view.backgroundColor = .systemBackground

        let stackView = setupStackView()
        addSpacing(height: 16, to: stackView)
        addRow(caption: "5", rating: Float(ratingBreakdown.fiveStarRatingsCount) / Float(ratingBreakdown.sumOfAllRatingCounts), to: stackView)
        addRow(caption: "4", rating: Float(ratingBreakdown.fourStarRatingsCount) / Float(ratingBreakdown.sumOfAllRatingCounts), to: stackView)
        addRow(caption: "3", rating: Float(ratingBreakdown.threeStarRatingsCount) / Float(ratingBreakdown.sumOfAllRatingCounts), to: stackView)
        addRow(caption: "2", rating: Float(ratingBreakdown.twoStarRatingsCount) / Float(ratingBreakdown.sumOfAllRatingCounts), to: stackView)
        addRow(caption: "1", rating: Float(ratingBreakdown.oneStarRatingsCount) / Float(ratingBreakdown.sumOfAllRatingCounts), to: stackView)
        addSpacing(height: 16, to: stackView)

        addDisclaimer(below: stackView)
    }

    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
    }

    private func setupStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.backgroundColor = .systemGray6
        stackView.layer.cornerRadius = 8
        stackView.clipsToBounds = true

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -16),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
        ])

        return stackView
    }

    // MARK: - Actions
    @objc private func close() {
        dismiss(animated: true)
    }

    // MARK: - Private functions
    private func addRow(caption: String, rating: Float, to parentStackView: UIStackView) {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.isLayoutMarginsRelativeArrangement = true
        rowStackView.directionalLayoutMargins = kStackViewInset
        rowStackView.spacing = UIStackView.spacingUseSystem

        let captionLabel = UILabel()
        captionLabel.text = caption
        captionLabel.widthAnchor.constraint(equalToConstant: 16).isActive = true

        let ratingView = UIView()
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = .gray
        bar.layer.cornerRadius = 2

        ratingView.addSubview(bar)
        NSLayoutConstraint.activate([
            bar.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor),
            bar.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            bar.heightAnchor.constraint(equalToConstant: 4),
            bar.widthAnchor.constraint(equalTo: ratingView.widthAnchor, multiplier: CGFloat(rating))
        ])

        rowStackView.addArrangedSubview(captionLabel)
        rowStackView.addArrangedSubview(ratingView)

        parentStackView.addArrangedSubview(rowStackView)
    }

    private func addSpacing(height: CGFloat, to parentStackView: UIStackView) {
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: height).isActive = true

        parentStackView.addArrangedSubview(spacer)
    }

    private func addDisclaimer(below: UIView) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Disclaimer: ratings are random"

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: below.bottomAnchor, constant: 16),
        ])
    }

}
