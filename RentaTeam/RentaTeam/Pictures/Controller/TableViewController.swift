//
//  TableViewController.swift
//  RentaTeam
//
//  Created by Flash Jessi on 11/9/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let codeNumber = [100, 101, 102, 200, 201, 202, 203, 204, 206, 207, 300, 301,
                      302, 303, 304, 305, 307, 308, 400, 401, 402, 403, 404, 405,
                      406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417,
                      418, 420, 421, 422, 423, 424, 425, 426, 429, 431, 444, 450,
                      451, 497, 498, 499, 500, 501, 502, 503, 504, 506, 507, 508,
                      509, 510, 511, 521, 523, 525, 599]
    
    lazy var persistentContainer: NSPersistentContainer? = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return delegate.persistentContainer
    }()
    
    var modelCats: [Cats] = []
    var server: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDateImage(count: 3)
    }
    
    private func loadDateImage(count: Int) {
        for _ in 1...count {
            let code = codeNumber.randomElement() ?? 422
            ApiRequest.shared.getImage(code: code) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        if self?.server == true {
                            self?.removeAllModels()
                            self?.server = false
                        }
                        self?.saveNewModel(data: data, code: code)
                        self?.tableView.tableFooterView = nil
                        self?.tableView.reloadData()
                    case .failure:
                        self?.server = true
                        self?.fetchModels()
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func fetchModels() {
        guard let context = persistentContainer?.viewContext else { return }
        let request: NSFetchRequest<Cats> = Cats.fetchRequest()
        
        guard let models = try? context.fetch(request) else { return }
        modelCats = models
        tableView.reloadData()
    }
    
    private func saveNewModel(data: Data, code: Int) {
        guard let context = persistentContainer?.viewContext else { return }
        let model = Cats(context: context)
        let date = "Download date: \(String(describing: self.getDate()))"
        let desc = "It is cat number \(code)"
        model.date = date
        model.desc = desc
        model.image = data
        
        do {
            modelCats.append(model)
            try context.save()
        } catch let error {
            print("Error when saving: \(error)")
        }
    }
    
    private func removeAllModels() {
        guard let context = persistentContainer?.viewContext else { return }
        for model in modelCats {
            context.delete(model)
        }
        do {
            modelCats.removeAll()
            try context.save()
        } catch let error {
            print("Error when saving: \(error)")
        }
    }
    
    private func getDate() -> String {
        let time = Date()
        let fullTime = DateFormatter.localizedString(from: time, dateStyle: .long, timeStyle: .medium)
        return fullTime
    }
    
    private func createActivityIndicatorFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = footerView.center
        activityIndicator.color = .black
        footerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        return footerView
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelCats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        if let data = modelCats[indexPath.row].image {
            cell.imageCell.image = UIImage(data: data)
        } else {
            cell.imageCell.image = UIImage(named: "error1")
        }
        cell.imageCell.backgroundColor = .black
        cell.dateLabel.text = modelCats[indexPath.row].date
        cell.descLabel.text = modelCats[indexPath.row].desc
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentIndexPath = tableView.indexPathForSelectedRow,
            let currentCell = tableView.cellForRow(at: currentIndexPath) as? CustomTableViewCell else {
                tableView.deselectRow(at: indexPath, animated: true)
                return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "PictureViewController") as? PictureViewController else { return }

        vc.imageVC = currentCell.imageCell.image
        vc.desc = currentCell.descLabel.text
        vc.date = currentCell.dateLabel.text
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TableViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > tableView.contentSize.height - 100 - scrollView.frame.size.height {
            self.tableView.tableFooterView = createActivityIndicatorFooter()
            loadDateImage(count: 1)
        }
    }
}
