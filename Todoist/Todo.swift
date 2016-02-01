//
//  FirebaseModels.swift
//  Todoist
//
//  Created by Nauman Ahmad on 1/31/16.
//  Copyright © 2016 Nauman Ahmad. All rights reserved.
//

import Foundation
import Firebase

struct Todo {
    var item: String
    var firebaseRef: Firebase?
    var completed: Bool
    
    init(item: String, completed: Bool) {
        self.item = item
        self.completed = completed
    }
    
    init(snapshot: FDataSnapshot) {
        item = snapshot.value["name"] as! String
        firebaseRef = snapshot.ref
        completed = snapshot.value["completed"] as! Bool
    }
    
    func toDict() -> NSDictionary {
        return ["name": item, "completed": completed]
    }
}