//
//  MealDetailsViewController.swift
//  desserts
//
//  Created by David Bui on 6/20/22.
//

import Foundation
import UIKit

class MealDetailsViewController: UIViewController {
    
    let mealDetailsPresenter: MealDetailsPresenter
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(stackView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(instructionsHeadingLabel)
        stackView.addArrangedSubview(instructionsTextLabel)
        stackView.addArrangedSubview(measuredIngredientsHeadingLabel)
        stackView.addArrangedSubview(measuredIngredientsTextLabel)
        stackView.spacing = 7.5
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-bold", size: 32)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let instructionsHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Instructions"
        label.font = UIFont(name: "Helvetica", size: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var instructionsTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let measuredIngredientsHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Ingredients"
        label.font = UIFont(name: "Helvetica", size: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var measuredIngredientsTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(mealDetailsPresenter: MealDetailsPresenter) {
        self.mealDetailsPresenter = mealDetailsPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mealDetailsPresenter.fetchDetails(id: self.mealDetailsPresenter.idMeal) {
            DispatchQueue.main.async {
                guard let meals = self.mealDetailsPresenter.meals[safe: 0], let instructions = meals["strInstructions"], let name = meals["strMeal"] else { return }
                self.instructionsTextLabel.text = instructions
                self.nameLabel.text = name
                let ingredientsList = meals.keys.enumerated().map { (meals["strIngredient\($0.offset)"] ?? "")?.capitalized ?? "" }.filter { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" }
                let measurementsList = meals.keys.enumerated().map { (meals["strMeasure\($0.offset)"] ?? "")?.capitalized ?? "" }.filter { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" }
                guard ingredientsList.count == measurementsList.count else { return }
                var measuredIngredientsText = ""
                for index in 0 ... ingredientsList.count - 1 {
                    measuredIngredientsText += "\(measurementsList[safe: index] ?? "") \(ingredientsList[safe: index] ?? "")\n"
                }
                self.measuredIngredientsTextLabel.text = measuredIngredientsText
            }
        }
        self.setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
                                     self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                     
                                     self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
                                     self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10),
                                     self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 10),
                                     self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
                                     self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -20),
                                    
                                     self.instructionsTextLabel.widthAnchor.constraint(equalTo: self.stackView.widthAnchor),
                                     self.measuredIngredientsTextLabel.widthAnchor.constraint(equalTo: self.stackView.widthAnchor)])
    }
}
