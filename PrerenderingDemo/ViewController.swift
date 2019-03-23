//
//  ViewController.swift
//  PrerenderingDemo
//
//  Created by Ahmed Khalaf on 3/22/19.
//  Copyright © 2019 Ahmed Khalaf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let data: [String] = (0..<100).map({ _ in
        return randomString(length: Int.random(in: 1...10000))
    })
    private var labelModels: [LabelModel] = []
    
    @IBOutlet private weak var tableViewNormal: UITableView!
    @IBOutlet private weak var tableViewPrerendered: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func fillModels() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .default).async { [data, width = tableViewPrerendered.bounds.width] in
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .right
            
            let labelModels = data.map({ string in
                return LabelModel(attributedString: NSAttributedString(string: string, attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                    NSAttributedString.Key.foregroundColor: UIColor.black,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]), width: width)
            })
            
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                self.labelModels = labelModels
                self.tableViewPrerendered.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fillModels()
    }
}

class Cell: UITableViewCell {
    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var textHostView: UIView?
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === tableViewNormal {
            return data.count
        } else if tableView === tableViewPrerendered {
            return labelModels.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === tableViewNormal {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
            cell.label?.text = data[indexPath.row]
            return cell
        } else if tableView === tableViewPrerendered {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! Cell
            cell.textHostView?.layer.contents = labelModels[indexPath.row].image?.cgImage
            return cell
        }
        
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return labelModels[indexPath.row].size.height
    }
}

/*extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for i in indexPaths.map({ $0.row }) {
            labelModels[i].render()
        }
    }
}*/

/// Credits: https://stackoverflow.com/a/26845710/715593
func randomString(length: Int) -> String {
    let letters = "ضصثقفغعهخحجةشسيبلاتنمكظطذدزرو "
    return String((0..<length).map{ _ in letters.randomElement()! })
}
