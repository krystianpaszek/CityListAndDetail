//
//  CityCell.swift
//  CitiesListAndDetail
//
//  Created by Krystian Paszek on 20/11/2020.
//

import UIKit

@objc protocol CityCellActions {
    func favorite(sender: UIButton)
    func unfavorite(sender: UIButton)
}

class CityCell: UITableViewCell {

    static let identifier = "city_cell"

    // MARK: - State
    var imageFetchTask: URLSessionDataTask?
    var imageDownloader: ((URL, @escaping (UIImage?, Error?) -> Void) -> URLSessionDataTask?)?

    // MARK: - Outlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityThumbnailImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageFetchTask?.cancel()
    }

    func setup(with city: City, isFavorited: Bool) {
        self.cityNameLabel.text = city.name

        let selector = isFavorited ? #selector(CityCellActions.unfavorite(sender:)) : #selector(CityCellActions.favorite(sender:))

        favoriteButton.addTarget(nil, action: selector, for: .touchUpInside)
        favoriteButton.sizeToFit()

        let image = isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.favoriteButton.setImage(image, for: .normal)

        self.imageFetchTask = imageDownloader?(city.image) { [weak self] image, error in
            DispatchQueue.main.async {
                self?.imageLoadingIndicator.stopAnimating()
                guard let image = image else {
                    // fallback image here
                    return
                }

                self?.cityThumbnailImageView.image = image
            }
        }
    }
    
}
