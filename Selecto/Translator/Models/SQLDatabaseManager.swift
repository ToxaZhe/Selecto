//
//  SQLDatabaseManager.swift
//  Selecto
//
//  Created by user on 2/22/18.
//  Copyright © 2018 Toxa. All rights reserved.
//

import Foundation
import SQLite3

enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}

class SQLiteDatabase {
    fileprivate let dbPointer: OpaquePointer?
    fileprivate init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }
    deinit {
        sqlite3_close(dbPointer)
    }
    
    static func open(path: String) throws -> SQLiteDatabase {
        var db: OpaquePointer? = nil
        if sqlite3_open(path, &db) == SQLITE_OK {
            return SQLiteDatabase(dbPointer: db)
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String.init(cString: errorPointer)
                throw SQLiteError.OpenDatabase(message: message)
            } else {
                throw SQLiteError.OpenDatabase(message: "No error message provided from sqlite.")
            }
        }
    }
}

extension SQLiteDatabase {
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer? = nil
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.Prepare(message: errorMessage)
        }
        return statement
    }
}

extension SQLiteDatabase {
    func createTable(table: SQLTable.Type) throws {
        let createTableStatement = try prepareStatement(sql: table.createStatement)
        defer {
            sqlite3_finalize(createTableStatement)
        }
        guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("\(table) table created.")
    }
}

extension SQLiteDatabase {
    func insert(translation: Translation) throws {
        let insertSql = "INSERT INTO Translations (Translate, Translated) VALUES (?,?);"
        let insertStatement = try prepareStatement(sql: insertSql)
        defer {
            sqlite3_finalize(insertStatement)
        }
        let text: NSString = translation.text
        let translation: NSString = translation.translation
        guard sqlite3_bind_text(insertStatement, 1, text.utf8String, -1, nil) == SQLITE_OK && sqlite3_bind_text(insertStatement, 2, translation.utf8String, -1, nil) == SQLITE_OK else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Successfully inserted row.")
    }
}

extension SQLiteDatabase {
    func getTranslationFromDbTable(queryResultCol1: UnsafePointer<UInt8>?, queryResultCol2: UnsafePointer<UInt8>?) -> Translation {
        let text = String(cString: queryResultCol1!) as NSString
        let translation = String(cString: queryResultCol2!) as NSString
        let contact = Translation(text: text, translation: translation)
        return contact
    }
    func translations() -> [Translation] {
        var translations = [Translation]()
        let querySql = "SELECT * FROM Translations"
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return translations
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        while (sqlite3_step(queryStatement) == SQLITE_ROW) {
            let queryResultCol2 = sqlite3_column_text(queryStatement, 1)
            let queryResultCol1 = sqlite3_column_text(queryStatement, 0)
            let translation = getTranslationFromDbTable(queryResultCol1: queryResultCol1, queryResultCol2: queryResultCol2)
            translations.append(translation)
        }
        return translations
    }
}


