//
//  TableViewController.swift
//  RentaTeam
//
//  Created by Flash Jessi on 11/9/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let codeNumber = [100, 101, 102,
                      200, 201, 202,
                      203, 204, 206,
                      207, 300, 301,
                      302, 303, 304,
                      305, 307, 308,
                      400, 401, 402,
                      403, 404, 405,
                      406, 407, 408,
                      409, 410, 411,
                      412, 413, 414,
                      415, 416, 417,
                      418, 420, 421,
                      422, 423, 424,
                      425, 426, 429,
                      431, 444, 450,
                      451, 497, 498,
                      499, 500, 501,
                      502, 503, 504,
                      506, 507, 508,
                      509, 510, 511,
                      521, 523, 525,
                      599]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "picture" {
//
////            guard
//                let vc = segue.destination as! PictureViewController
//            print(1)
//                let cell = sender as! CustomTableViewCell
//            print(2)
////                else { return }
//            if cell.imageCell.image != nil {
//                vc.imageVC = cell.imageCell.image
//            }
//            print(3)
//            vc.desc = cell.descLabel.text
//            vc.date = "date  fvgff"
//        }
//    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        let code = codeNumber.randomElement() ?? 422
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        ApiRequest.shared.getImage(code: code) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    cell.imageCell.image = image
                    cell.imageCell.backgroundColor = .black
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.isHidden = true
                    cell.dateLabel.text = self.getDate()
                case .failure:
                    cell.imageCell.image = UIImage(named: "error1")
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.isHidden = true
                    cell.dateLabel.text = "Download date: \(self.getDate())"
                }
            }
        }
        cell.descLabel.text = "It is cat number \(code)"
        
        return cell
    }
    
    func getDate() -> String {
        let time = Date()
        let fullTime = DateFormatter.localizedString(from: time, dateStyle: .long, timeStyle: .medium)
        return fullTime
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
