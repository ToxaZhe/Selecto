//
//  ViewController.swift
//  Selecto
//
//  Created by user on 2/22/18.
//  Copyright © 2018 Toxa. All rights reserved.
//

import UIKit
protocol TranslatorVCDelegate : class {
    func addTranslation(translation: Translation)
}
let isTableCreatedKey = "isTableCreated"

class TranslationHistoryVC: UIViewController {
    let defaults = UserDefaults.standard
    let toTranslatorVCSegueIdentifier = "ToTranslatorVCSegue"
    let translationHistoryCellIdentifier = "TranslationHistoryCell"
    var translates = [Translation]()
    let isTableCreated: Bool = {
        guard UserDefaults.standard.object(forKey: isTableCreatedKey) == nil else {
            return true
        }
        return false
    }()
    @IBOutlet weak var translationsTableView: UITableView!
    fileprivate var db: SQLiteDatabase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
    }
    
    @IBAction func translateActionBtn(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if toTranslatorVCSegueIdentifier == segue.identifier {
            let destVC = segue.destination as! TranslatorVC
            destVC.delegate = self
        }
    }
}

extension TranslationHistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translates.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: translationHistoryCellIdentifier, for: indexPath) as! TranslatedTextTVCell
        cell.textToTranslateLbl.text = String(translates[indexPath.row].text)
        cell.translatedTextLbl.text = String(translates[indexPath.row].translation)
        
        return cell
    }
}
//MARK: SQLiteDatabase
extension TranslationHistoryVC {
    
    func configureDatabase() {
        openDatabase()
        guard !isTableCreated else {
            translates = getTranslatesFromDb()
            return
        }
        createTable()
    }
    func createDatabaseFile() -> URL {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Translations.sqlite")
        return fileURL
    }
    func openDatabase() {
        let url = createDatabaseFile()
        do {
            db = try SQLiteDatabase.open(path: url.path)
        } catch SQLiteError.OpenDatabase(let message) {
            print("Unable to open database: \(message)")
        } catch {
            print(error.localizedDescription)
        }
    }
    func insert(translation: Translation) {
        do {
            let translation = translation
            try db!.insert(translation: translation)
        } catch {
            print(db!.errorMessage)
        }
    }
    func createTable() {
        do {
            try db!.createTable(table: Translation.self)
            UserDefaults.standard.set(true, forKey: isTableCreatedKey)
        } catch {
            print(db!.errorMessage)
        }
    }
    func getTranslatesFromDb() -> [Translation] {
        return  db!.translations()
    }
}

extension TranslationHistoryVC : TranslatorVCDelegate {
    func addTranslation(translation: Translation) {
        translates.append(translation)
        translationsTableView.reloadData()
        insert(translation: translation)
    }
}
