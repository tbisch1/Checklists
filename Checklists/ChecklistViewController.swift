//
//  ViewController.swift
//  Checklists
//
//  Created by Tyler Bischoff on 1/22/22.
//

import UIKit

class ChecklistViewController: UITableViewController, itemDetailViewContorllerDelegate {

    var checklist: Checklist!
    var items = [ChecklistItem]() //creates array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadChecklistItems()
        title = checklist.name
        
//        print("Documents folder is \(documentsDirectory())")
//        print("Data file path is \(dataFilePath())")
    }

    // MARK: - Table View Data Source
    override func tableView( //returns the amount of items in the array which is how many rows there should be
        _ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        return items.count
    }
    
    override func tableView( //configures the cells/rows
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem",
            for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item) //adds text for cell
        configureCheckmark(for: cell, with: item) //adds check or not for cell
        
        return cell
    }

    // MARK: - Table View Delegate
    override func tableView( //checks if cell is selected if one is toggles √
      _ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
          let checklist = items[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    //configures the delete function
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveChecklistItems()
    }
    
    // MARK: - Actions
    //looks at ChecklistItem and determines whether it is set to checked or not and sets the label accordingly
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        }
        else {
            label.text = ""
        }
    }
    //looks at ChecklistItem and determines the text it should have and updates the label accordingly
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK: - Add Item ViewController Delegates
    //cancel button functionality
    func itemDetailViewControllerDidCancel(_ controller: itemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    //Done in the add screen/ adds new row
    func itemDetailViewController(_ controller: itemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated:true)
        saveChecklistItems()
    }
    //done in the edit screen changes edited row
    func itemDetailViewController(_ controller: itemDetailViewController, didFinishEditing item: ChecklistItem){
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
      navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    // MARK: - Navigation
    //defines segues and where to deliver the information
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! itemDetailViewController
            controller.delegate = self
        }
        else if segue.identifier == "EditItem" {
            let controller = segue.destination as! itemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
        // MARK: File functions
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }
        catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems() {
        let path = dataFilePath()
        if let data = try? Data (contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([ChecklistItem].self, from: data)
            }
            catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}
