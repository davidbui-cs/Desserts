//
//  DessertsViewController.swift
//  desserts
//
//  Created by David Bui on 6/18/22.
//

import UIKit

class DessertsViewController: UIViewController {

    private let dessertsPresenter = DessertsPresenter()
    
    private let dessertsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    struct Constants {
        static let identifier = "dessertsCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dessertsTableView.delegate = self
        dessertsTableView.dataSource = self
        self.dessertsPresenter.fetchDesserts() {
            DispatchQueue.main.async {
                self.dessertsTableView.reloadData()
            }
        }
        self.setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.dessertsTableView)
        
        NSLayoutConstraint.activate([
            self.dessertsTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.dessertsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.dessertsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.dessertsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        cell.backgroundColor = .systemBackground
        let index = indexPath.row
        cell.textLabel?.text = self.dessertsPresenter.meals[safe: index]?["strMeal"] as? String
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 18)
        let imageView = UIImageView()
        guard let urlString = self.dessertsPresenter.meals[safe: index]?["strMealThumb"] as? String else { return }
        imageView.loadRemoteImageFrom(urlString: urlString ) {
            cell.imageView?.image = imageView.image
            cell.setNeedsLayout()
        }
    }
}

extension DessertsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dessertsPresenter.meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier) else { return UITableViewCell() }
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let idMeal = self.dessertsPresenter.meals[safe: indexPath.row]?["idMeal"] else { return }
        let mealDetailsVC = MealDetailsViewController(mealDetailsPresenter: MealDetailsPresenter(idMeal: idMeal ?? ""))
        self.navigationController?.pushViewController(mealDetailsVC, animated: true)
    }
}
