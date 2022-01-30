//
//  itemDetailViewController.swift
//  Checklists
//
//  Created by Tyler Bischoff on 1/23/22.
//

import UIKit
//adds a protocol to define itself as a delegate
protocol itemDetailViewContorllerDelegate: AnyObject {
    func itemDetailViewControllerDidCancel(_ controller: itemDetailViewController)
    func itemDetailViewController(_ controller: itemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: itemDetailViewController, didFinishEditing item: ChecklistItem)
}

class itemDetailViewController: UITableViewController, UITextFieldDelegate {
    //variables
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch!) {
        textField.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {_, _ in}
        }
    }
    
    var itemToEdit: ChecklistItem?
    
    weak var delegate: itemDetailViewContorllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit { //changes title if editing and enables the done button
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            datePicker.date = item.dueDate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder() //forces the textfield to be selected when screen opens
    }
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem! //another variable that should go with the others
    
    // MARK: - Actions
    @IBAction func cancel(){ //send command to the delegate to close screen
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    @IBAction func done(){ //if editing sends command to edit item
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        }
        else { //if not send command to add a row
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    // Mark: - Table View Delegates
    //makes it so you can't turn the textfield grey
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    // MARK: - Text Field Delegates
    //greys out the done button if there is no text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool { //when the clear button is hit disable the done button
        doneBarButton.isEnabled = false
        return true
    }
}
