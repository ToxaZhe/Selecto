//
//  SQLModel.swift
//  Selecto
//
//  Created by user on 2/22/18.
//  Copyright © 2018 Toxa. All rights reserved.
//

import Foundation

extension Translation: SQLTable {
    static var createStatement: String {
        return """
        CREATE TABLE Translations(
        Translate CHAR(255), Translated CHAR(255)
        );
        """
    }
}
protocol SQLTable {
    static var createStatement: String { get }
}

struct Translation {
    var text: NSString
    var translation: NSString
}
