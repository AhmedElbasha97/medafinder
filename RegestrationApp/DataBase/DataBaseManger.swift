//
//  DataBaseManger.swift
//  RegestrationApp
//
//  Created by ahmedelbasha on 5/4/20.
//  Copyright © 2020 ahmedelbasha. All rights reserved.
//


import Foundation
import SQLite

class DatabaseManager {
    static let sharedInstance = DatabaseManager()
    private var db: Connection? = nil
    private let userData = Table("userData")
    private let id = Expression<Int>("id")
    private let email = Expression<String>("email")
    private let password = Expression<String>("password")
    private let contactNum = Expression<String>("contactNum")
    private let gender = Expression<String>("gender")
    private let address = Expression<String>("address")
    private let name = Expression<String>("name")
    private let photo = Expression<Data>("photo")
    private let cachedData = Table("chachedData")
    private let text = Expression<String>("text")
    private let userid = Expression<Int>("userid")
    
    static func shared() -> DatabaseManager {
        return DatabaseManager.sharedInstance
    }
    
    
    func usersDbConnection() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("userData").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.db = database
        } catch {
            print(error)
        }
    }
    
    func searchedDataDbConnection() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("cashedData").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.db = database
        } catch {
            print(error)
        }
    }
    
    func createUsersTable() {
        if isUsersTableExists() == false {
            do {
                try db?.run(userData.create { t in
                    t.column(self.id, primaryKey: .autoincrement)
                    t.column(self.name)
                    t.column(self.password)
                    t.column(self.gender)
                    t.column(self.address)
                    t.column(self.contactNum)
                    t.column(self.email, unique: true)
                    t.column(self.photo)
                    print("table created")
                })
            }
            catch   {
                print(error)
            }
        } else {
            print("Table Already Exists")
        }
    }
    
    func createSearchedDataTable(searchedText: String) {
        
        if isSearchedDataTableExists() == false {
            do {
                try db?.run(cachedData.create { t in
                    t.column(self.userid, primaryKey: .autoincrement)
                    t.column(text)
                    t.foreignKey(self.userid, references: userData, self.id)
                    print("table created")
                })
                insertSearchedData(dtext: searchedText)
                print("data insterted")
            }   catch   {
                print(error)
            }
        } else {
            if cachUserExists() == true {
                let id = UserDefaults.standard.integer(forKey: "id")
                let user = self.cachedData.filter(self.userid == id)
                let updateUser = user.update(self.text <- searchedText)
                do {
                    try self.db?.run(updateUser)
                } catch {
                    print(error)
                }
            } else {
                insertSearchedData(dtext: searchedText)
            }
        }
    }
    
    func isUsersTableExists() -> Bool {
        if (try? db?.scalar(userData.exists)) != nil {
            return true
        }
        return false
    }
    func isSearchedDataTableExists() -> Bool {
        if (try? db?.scalar(cachedData.exists)) != nil {
            return true
        }
        return false
    }
    
    func listUsersTable() {
        do {
            let userData = try self.db!.prepare(self.userData)
            for data in userData {
                print(data[id], data[name], data[email], data[password])
            }
        } catch {
            print(error)
        }
    }
    
    func listSearchedDataTable() {
        do {
            let cachedData = try self.db!.prepare(self.cachedData)
            for cachData in cachedData {
                print(cachData[self.userid], cachData[self.text])
            }
        } catch {
            print(error)
        }
    }
    
    func userExsits(email: String, password: String) -> Bool {
        do {
            let userData = try self.db!.prepare(self.userData)
            for user in userData {
                if email == user[self.email] && password == user[self.password] {
                    UserDefaults.standard.set(user[self.id], forKey: "id")
                    return true
                }
            }
        } catch {
            print(error)
        }
        return false
    }
    
    func cachUserExists() -> Bool {
        do {
            let id = UserDefaults.standard.integer(forKey: "id")
            let cachData = try self.db!.prepare(self.cachedData)
            for cach in cachData {
                if cach[self.userid] == id {
                    
                    return true
                }
            }
        } catch {
            print(error)
        }
        return false
    }
    
    func getUserData() -> users? {
        do {
            let id = UserDefaults.standard.integer(forKey: "id")
            let userData = try self.db!.prepare(self.userData)
            for user in userData {
                if id == user[self.id] {
                    
                    return users(name: user[self.name], email: user[self.email], password: user[self.password], contactNum: user[self.contactNum], gender: user[self.gender], address: user[self.address], image: user[self.photo])
                }
                
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func insertUsers(dName: String, dEmail: String, dPassword: String, dContactNum: String, dGender: String, dAddress: String, dPhoto: Data) {
        do {
            let insert = userData.insert(self.name <- dName, self.email <- dEmail, self.password <- dPassword, self.contactNum <- dContactNum, self.gender <- dGender, self.address <- dAddress, self.photo <- dPhoto)
            try db!.run(insert)
            
        } catch {
            print("Insert failed")
        }
        print(dName,dEmail,dPassword)
    }
    
    func insertSearchedData(dtext: String) {
        do {
            let insert = cachedData.insert(self.text <- dtext)
            try db!.run(insert)
            
        } catch {
            print("Insert failed")
        }
        print(dtext)
    }
    
    func getSearchedData() -> String {
        var cachedData: String = "Diana"
        let id = UserDefaults.standard.integer(forKey: "id")
        do {
            for cachData in try db!.prepare(self.cachedData) {
                if cachData[userid] == id {
                    cachedData = cachData[self.text]
                }
            }
        } catch {
            print("Select failed")
        }
        return cachedData
    }
    
}
