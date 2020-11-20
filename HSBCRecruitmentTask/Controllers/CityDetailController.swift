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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
