//
//  ImageDownloader.swift
//  CitiesListAndDetail
//
//  Created by Krystian Paszek on 20/11/2020.
//

import Foundation
import UIKit

protocol ImageDownloaderProtocol {
    func fetchImage(with url: URL, completion: @escaping (UIImage?, Error?) -> Void) -> URLSessionDataTask?
}

class ImageDownloader: ImageDownloaderProtocol {

    // MARK: - Properties
    private let cache = NSCache<NSURL, UIImage>()
    private let urlSession: URLSession = URLSession.shared

    // MARK: - ImageDownloaderProtocol
    func fetchImage(with url: URL, completion: @escaping (UIImage?, Error?) -> Void) -> URLSessionDataTask? {
        guard let image = cache.object(forKey: url as NSURL) else {
            let dataTask = urlSession.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data else {
                    completion(nil, NetworkServiceError.cannotFetchResource)
                    return
                }

                guard let image = UIImage(data: data) else {
                    completion(nil, NetworkServiceError.cannotDecodeResource)
                    return
                }

                self?.cache.setObject(image, forKey: url as NSURL)
                completion(image, nil)
            }

            dataTask.resume()
            return dataTask
        }

        completion(image, nil)
        return nil
    }
}
