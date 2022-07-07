//
//  MealDetailsPresenter.swift
//  desserts
//
//  Created by David Bui on 6/20/22.
//

import Foundation

class MealDetailsPresenter {
    
    let dessertsModel = DessertsModel()
    
    let idMeal: String
    var meals: [[String: String?]] = []
    
    init(idMeal: String) {
        self.idMeal = idMeal
    }
    
    func fetchDetails(id: String, completion: @escaping() -> Void) {
        self.dessertsModel.fetchDetails(idMeal: self.idMeal) { desserts, error in
            self.meals = desserts?.meals ?? []
            completion()
        }
    }

}
