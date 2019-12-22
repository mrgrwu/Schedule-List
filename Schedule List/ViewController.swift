//
//  ViewController.swift
//  Schedule List
//
//  Created by Greg Wu on 11/1/19.
//  Copyright © 2019 Greg Wu. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var itemArray = [Item]()  // Create array of custom Item struct objects
    var numberItemsComplete: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up navigation bar
        title = "My Schedule"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        // Create toolbar item objects
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)  // flexible spacer "spring"
        let edit = editButtonItem
        
        toolbarItems = [spacer, edit]  // Set toolbar items array property
        navigationController?.isToolbarHidden = false  // Show toolbar
    }
    
    // Actions to perform when + (add) bar button is pressed
    @objc func addItem() {
        var newItem = Item(description: "", complete: false)  // Create new Item object for list
        
        // Create alert controller and Submit, Cancel actions
        let ac = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] (action) in
            guard let description = ac?.textFields?[0].text else { return }  // Safely unwrap optional text field
            if description != "" {  // If text field was not an empty string:
                newItem.description = description
                self?.itemArray.append(newItem)
                
                // Insert row at end of table view list and load new item
                let indexPath = IndexPath(row: (self?.itemArray.count)! - 1, section: 0)
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    // Actions to clear list
    @objc func clearList() {
        itemArray = []
        numberItemsComplete = 0
        tableView.reloadData()
    }
    
    // Check if all items are marked complete, and provide option to clear list
    func checkAllItemsComplete() {
        if numberItemsComplete == itemArray.count {
            let ac = UIAlertController(title: "Good Job", message: "Everything is done! Do you want to clear the list?", preferredStyle: .alert)
            let clearAction = UIAlertAction(title: "Clear", style: .default) { (action) in
                self.clearList()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(clearAction)
            ac.addAction(cancelAction)
            present(ac, animated: true)
        }
    }
    
    // Table view delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = "- \(itemArray[indexPath.row].description)"
        cell.accessoryType = itemArray[indexPath.row].complete ? .checkmark : .none  // Add checkmark accessory to cell depending on Item.complete property
        return cell
    }
    
    // Toggle Item.complete property and list checkmark when row is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].complete = !itemArray[indexPath.row].complete
        if itemArray[indexPath.row].complete {
            numberItemsComplete += 1
        } else {
            numberItemsComplete -= 1
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        checkAllItemsComplete()
    }
    
    // Make table rows swipable/edit-deletable, and define delete action (code snippet from HackingWithSwift.com)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if itemArray[indexPath.row].complete { numberItemsComplete -= 1 }
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
            checkAllItemsComplete()
        }
    }
    
    // Make table rows edit-reorderable, and define data source reorder actions (code info from Ron Mourant, https://medium.com/@ronm333/delete-and-reorder-tableview-rows-ba5900379662
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = itemArray[sourceIndexPath.row]
        itemArray.remove(at: sourceIndexPath.row)
        itemArray.insert(itemToMove, at: destinationIndexPath.row)
    }


}

