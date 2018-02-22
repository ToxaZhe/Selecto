//
//  ViewController.swift
//  Selecto
//
//  Created by user on 2/22/18.
//  Copyright © 2018 Toxa. All rights reserved.
//

import UIKit

let translationHistoryCellIdentifier = "TranslationHistoryCell"

class TranslationHistoryVC: UIViewController {
    @IBOutlet weak var translationsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func translateActionBtn(_ sender: Any) {
    }
}

extension TranslationHistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: translationHistoryCellIdentifier, for: indexPath)
        return cell
    }
}
