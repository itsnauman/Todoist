//
//  TodoItemsViewController.swift
//  Todoist
//
//  Created by Nauman Ahmad on 1/31/16.
//  Copyright © 2016 Nauman Ahmad. All rights reserved.
//

import UIKit
import Firebase

class TodoItemsViewController: UITableViewController {
    var items: [Todo] = []
    var ref: Firebase!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.ref.observeEventType(.Value, withBlock: { snapshot in
            var newItems: [Todo] = []
            for item in snapshot.children {
                newItems.append(Todo(snapshot: item as! FDataSnapshot))
            }
            self.items = newItems
            self.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Firebase(url: "https://todonauman.firebaseio.com/")
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addTodoItem")
        
        self.navigationItem.leftBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func addTodoItem() {
        let alertController = UIAlertController(title: "Add Item", message: "Please Enter a Todo Item", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) -> Void in
            let field = alertController.textFields![0]
            let todoItem = Todo(item: (field.text)!, completed: false)
            let todoItemRef = self.ref.childByAppendingPath(field.text?.lowercaseString)
            todoItemRef.setValue(todoItem.toDict())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Todo Item"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func toggleCheckmark(cell: UITableViewCell, completed: Bool) {
        if completed {
            cell.textLabel?.textColor = UIColor.grayColor()
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].item

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            items[indexPath.row].firebaseRef?.removeValue()
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let toggledCompletion = !items[indexPath.row].completed
        toggleCheckmark(cell!, completed: toggledCompletion)
        items[indexPath.row].firebaseRef?.updateChildValues(["completed": toggledCompletion])
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = items[sourceIndexPath.row]
        items.removeAtIndex(sourceIndexPath.row)
        items.insert(itemToMove, atIndex: destinationIndexPath.row)
    }
    

}
