//
//  DataManager.swift
//  JHMeMO
//
//  Created by 송정훈 on 2020/08/17.
//  Copyright © 2020 JH. All rights reserved.
//

import Foundation
import CoreData

class DataManager{
    static let shared = DataManager()
    private init(){
        //Singleton 싱글톤
    }
    var mainContext:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    var memoList = [Memo]()
    //DB 접근 메소드 시작
    func fetchMemo(){ //fetch -> DB 로부터 데이터를 읽어 오는 것
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        let sortByDateDesc = NSSortDescriptor(key:"insertDate",ascending:false)
        request.sortDescriptors = [sortByDateDesc]
        do{
           memoList = try mainContext.fetch(request)
        }catch{
            print(error)
        }
    }
    func addNewMemo(_ memo:String?){
        let newMemo = Memo(context:mainContext) //Memo는 DB의 Memo 이기 때문에 파라미터로 context를 전달해야함
        //-> 비어있는 Memo 인스턴스 생성
        newMemo.content = memo
        newMemo.insertDate = Date()
        memoList.insert(newMemo,at:0)
        saveContext()
    }
    func deleteMemo(_ memo:Memo?){
        if let memo = memo {
            mainContext.delete(memo)
            saveContext()
        }
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "JHMeMO")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    
}
