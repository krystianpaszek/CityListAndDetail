//
//  ErrorController.swift
//  CitiesListAndDetail
//
//  Created by Krystian Paszek on 22/11/2020.
//

import UIKit

class ErrorController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var errorTitleLabel: UILabel!
    @IBOutlet private weak var errorMessageLabel: UILabel!

    // MARK: - State
    private var errorTitle: String = "Error"
    private var errorMessage: String = "Something's wrong. Try again."

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        errorTitleLabel.text = errorTitle
        errorMessageLabel.text = errorMessage
    }

}
