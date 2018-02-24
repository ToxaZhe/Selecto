//
//  TranslatorVC.swift
//  Selecto
//
//  Created by user on 2/22/18.
//  Copyright © 2018 Toxa. All rights reserved.
//

import UIKit

var languages = ["en", "uk"]
class TranslatorVC: UIViewController {
    @IBOutlet weak var textToTranslateTextField: UITextField!
    @IBOutlet weak var translateToLanguageLbl: UILabel!
    @IBOutlet weak var translationFromLanguageLbl: UILabel!
    @IBOutlet weak var translatedTextView: UITextView!
    var translateParams = TranslateParams(source: languages[0], target: languages[1], text:"")
    var translationText = ""

    weak var delegate: TranslatorVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func changeTranslatingLanguage() {
        languages.reverse()
        translateParams.source = languages[0]
        translateParams.target = languages[1]
        translationFromLanguageLbl.text = languages[0]
        translateToLanguageLbl.text = languages[1]
    }
    
    @IBAction func changeTranslationLanguageActionBtn(_ sender: Any) {
        changeTranslatingLanguage()
    }
    @IBAction func backActionBtn(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    func translate(withTranslateParams params: TranslateParams) {
        let translator = TranslatorApi.shared
        translator.translate(params: params) { (result) in
            switch result {
            case .failure(errorMessage: let errString):
                print(errString)
            case .success(data: let data):
                do {
                    let translatedText = try Translated.tryDecodeJSON(fromData: data)
                    self.refreshViewAndSave(translatedText: translatedText)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func refreshViewAndSave(translatedText text: String) {
        let localTranslation = self.localModelPrepareForSaving(translationText: translateParams.text, translation: text)
        DispatchQueue.main.async {
            self.delegate?.addTranslation(translation: localTranslation)
            self.translatedTextView.text = text
        }
    }
    
    @IBAction func translateTextActionBtn(_ sender: Any) {
        guard let text = textToTranslateTextField.text,
            !textToTranslateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("no text to translate")
            return
        }
        print("iranslsate text = \(text)?")
        translateParams.text = text
        translate(withTranslateParams: translateParams)
    }
    func localModelPrepareForSaving(translationText: String, translation: String) -> Translation {
        let localSavingText = translationText as NSString
        let localSavingTextTranslation = translation as NSString
        return Translation(text: localSavingText, translation: localSavingTextTranslation)
    }
    func configureViews() {
        translatedTextView.layer.borderColor = UIColor.darkGray.cgColor
        translatedTextView.layer.borderWidth = 0.5
        
        textToTranslateTextField.delegate = self
    }
}

extension TranslatorVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = nil
        translatedTextView.text = nil
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}


