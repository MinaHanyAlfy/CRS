//
//  ReportManager.swift
//  CRS
//
//  Created by John Doe on 2023-03-25.
//

import Foundation
import CoreData

//MARK: - Product Table Info
extension CoreDataManager {
    func saveReport(url: String) {
        let reportCD = ReportCD(context: context())
        reportCD.url = url

        do {
            try context().save()
            print("✅ Success")
        } catch let error as NSError {
            print(error)
        }
    }
    
    func deleteReport(url: String) {
        let fetchRequest: NSFetchRequest<ReportCD> = ReportCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url = %@ ",url)
        let results = try! context().fetch(fetchRequest)
        if results.count != 0 { // Atleast one was returned
            context().delete(results.first!)
        }
        do {
            try context().save()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
   
    func clearReports() {
        let context = context()
        let fetchRequest: NSFetchRequest<ReportCD> = ReportCD.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            context.delete(obj)
        }
        
        do {
            try context.save()
        } catch {
            print("❌ Error Delete Object")
        }
    }
    
    func getReports () -> [String] {
        let context = context()
        let fetchRequest: NSFetchRequest<ReportCD> = ReportCD.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        var reports: [String] = []
        for objc in objects {
            reports.append(objc.url ?? "")
        }
        return reports
    }
}
