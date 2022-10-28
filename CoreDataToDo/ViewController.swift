//
//  ViewController.swift
//  CoreDataToDo
//
//  Created by Daniel Karath on 10/28/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer .viewContext
    
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self , forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private var models =  [ToDoListitem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CoreData To Do List"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        getAllItems()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target:  self, action:  #selector(didTapAdd))
    }
    
    @objc private func didTapAdd( ) {
        let alert = UIAlertController(title: "New Task", message: "Please type in a new task", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            self?.createItem(name: text)
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath )
        cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "Edit task", message: item.name , preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default , handler: { _ in
            let alert = UIAlertController(title: "Edit task", message: "Please type in a new name for your task", preferredStyle: .alert)
            alert.addTextField()
            alert.textFields?.first?.attributedPlaceholder = NSAttributedString(string: item.name!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
            alert.textFields?.first?.becomeFirstResponder()
            //alert.textFields?.first?.selectAll(nil)
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newText = field.text, !newText.isEmpty else { return }
                self?.updateItem(item: item, newName: newText)
            }))
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self? .deleteItem(item: item)
        }))
        present(sheet, animated: true)
    }
    
    func getAllItems() {
        do {
            models = try context.fetch(ToDoListitem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            //error
        }
        
    }
    
    func createItem(name: String) {
        let newItem = ToDoListitem(context: context )
        newItem.name = name
        newItem.createdAt = Date()
        saveContext()
        getAllItems()
    }
    
    func deleteItem(item: ToDoListitem) {
        context.delete(item)
        saveContext()
    }
    
    func updateItem(item: ToDoListitem, newName: String ) {
        item.name = newName
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            //error
        }
    }
}

