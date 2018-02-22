//
//  TranslatorAPI.swift
//  Selecto
//
//  Created by user on 2/22/18.
//  Copyright © 2018 Toxa. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(data: Data)
    //    here we can handle the error status codes or Api erros
    case failure(errorMessage: String)
}

struct TranslateParams {
    var source: String
    var target: String
    var text: String
    init(source:String, target:String, text:String) {
        self.source = source
        self.target = target
        self.text = text
    }
}

class TranslatorApi {
    static let shared = TranslatorApi()
    var apiKey = "AIzaSyAUgkoeLa6pWjVZES00A1l-EmL3AuDqf0U"
    func translate(params:TranslateParams, completion:@escaping (_ result: Result<Any>) -> Void) {
        guard let urlEncodedText = params.text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(Result.failure(errorMessage: "Sorry can't get urlEncodedText"))
            return
        }
        guard let url = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(self.apiKey)&q=\(urlEncodedText)&source=\(params.source)&target=\(params.target)&format=text") else {
            completion(Result.failure(errorMessage: "Sorry something wrong with url"))
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil else {
                print("Something went wrong: \(error!.localizedDescription)")
                return
            }
            let httpResponse = response as? HTTPURLResponse
            guard httpResponse?.statusCode == 200 else {
                completion(Result.failure(errorMessage: "Response [\(httpResponse!.statusCode)"))
                return
            }
            guard let data = data else {
                return
            }
            completion(Result.success(data: data))
        })
        dataTask.resume()
    }
}
