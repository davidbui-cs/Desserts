//
//  DessertsService.swift
//  desserts
//
//  Created by David Bui on 6/19/22.
//

import Foundation

class DessertsModel {
    func fetchDesserts(completion : @escaping (Desserts?, Error?) -> ()) {
        guard let URL = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
        
        URLSession.shared.dataTask(with: URL) { (data, urlResponse, error) in
            guard let data = data, error == nil else { return }
            var result: Desserts
            do {
                result = try JSONDecoder().decode(Desserts.self, from: data)
                completion(result, nil)
            } catch {
                print("failed")
                completion(nil, error)
            }
        }.resume()
    }
    
    func fetchDetails(idMeal: String, completion : @escaping (Desserts?, Error?) -> ()) {
        guard let URL = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(idMeal)") else { return }
        
        URLSession.shared.dataTask(with: URL) { (data, urlResponse, error) in
            guard let data = data, error == nil else { return }
            var result: Desserts
            do {
                result = try JSONDecoder().decode(Desserts.self, from: data)
                completion(result, nil)
            } catch {
                print("failed")
                completion(nil, error)
            }
        }.resume()
    }
}

struct Desserts: Decodable {
    let meals: [[String: String?]]
}
