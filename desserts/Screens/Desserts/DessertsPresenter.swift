//
//  DessertsPresenter.swift
//  desserts
//
//  Created by David Bui on 6/20/22.
//

import Foundation

class DessertsPresenter {
    
    private let dessertsModel = DessertsModel()
    
    var meals: [[String: String?]] = []
    
    func fetchDesserts(completion: @escaping() -> Void) {
        self.dessertsModel.fetchDesserts() { desserts, error in
            self.meals = desserts?.meals ?? []
            completion()
        }
    }
}
