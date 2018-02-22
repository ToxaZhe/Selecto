//
//  Translated.swift
//  Selecto
//
//  Created by user on 2/22/18.
//  Copyright © 2018 Toxa. All rights reserved.
//

import Foundation

struct Translated: Decodable {
    let data: TranslatedData
    struct TranslatedData: Decodable {
        let translations: [TranslatedText]
        struct TranslatedText: Decodable {
            let translatedText: String
        }
    }
}

extension Translated {
    static func tryDecodeJSON(fromData data:  Data) throws -> String {
        let translated = try JSONDecoder().decode(Translated.self, from: data)
        var translatedStringsArr: [String] = []
        translated.data.translations.forEach({ (textElement) in
            translatedStringsArr.append(textElement.translatedText)
        })
        return translatedStringsArr.joined(separator: " ")
    }
}
