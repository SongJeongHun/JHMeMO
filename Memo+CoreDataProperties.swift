//
//  Memo+CoreDataProperties.swift
//  JHMeMO
//
//  Created by 송정훈 on 2020/09/21.
//  Copyright © 2020 JH. All rights reserved.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var content: String?
    @NSManaged public var insertDate: Date?

}
