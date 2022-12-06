//
//  AccountCoreDataManager.swift
//  CRS
//
//  Created by John Doe on 2022-12-06.
//

import UIKit
import CoreData
//MARK: - Accounts Table Info
extension CoreDataManager {
    func saveAccounts(accounts: Accounts) {
        for account in accounts {
            let accountcd = AccountsCD(context: context())
            accountcd.accountName = account.accountName
            accountcd.accountLatitude = account.accountLatitude
            accountcd.accountLongitude = account.accountLongitude
            accountcd.specialityName = account.specialityName
            accountcd.accountPrescription = account.accountPrescription
            accountcd.zoneName = account.zoneName
            accountcd.accountID = account.accountID
            accountcd.keyPerson = account.keyPerson
            accountcd.accountPotential = account.accountPotential
            do {
                try context().save()
                print("✅ Success")
            } catch let error as NSError {
                print(error)
            }
        }
        
    }
    
    func clearAccounts() {
        
        let context = context()
        let fetchRequestAccount: NSFetchRequest<AccountsCD> = AccountsCD.fetchRequest()
        let objects = try! context.fetch(fetchRequestAccount)
        
        for obj in objects {
            context.delete(obj)
        }
        
        do {
            try context.save()
        } catch {
            print("❌ Error Delete Object")
        }
    }
    
    func getAccounts () -> Accounts {
        let context = context()
        let fetchRequest: NSFetchRequest<AccountsCD> = AccountsCD.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        var accounts: Accounts = []
        for objc in objects {
            let account = Account(accountID: objc.accountID, accountName: objc.accountName, accountPotential: objc.accountPotential, accountPrescription: objc.accountPrescription, keyPerson: objc.keyPerson, accountLatitude: objc.accountLatitude, accountLongitude: objc.accountLongitude, specialityName: objc.specialityName, zoneName: objc.zoneName)
            accounts.append(account)
        }
        return accounts
    }
}
