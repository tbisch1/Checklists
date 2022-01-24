//
//  itemDetailViewController.swift
//  Checklists
//
//  Created by Tyler Bischoff on 1/23/22.
//

import UIKit

protocol itemDetailViewContorllerDelegate: AnyObject {
    func itemDetailViewControllerDidCancel(_ controller: itemDetailViewController)
    func itemDetailViewController(_ controller: itemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: itemDetailViewController, didFinishEditing item: ChecklistItem)
}

class itemDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    
    var itemToEdit: ChecklistItem?
    
    weak var delegate: itemDetailViewContorllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    // MARK: - Actions
    @IBAction func cancel(){
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    @IBAction func done(){
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        }
        else {
            let item = ChecklistItem()
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    // Mark: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    // MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
