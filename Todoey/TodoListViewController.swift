//
//  ViewController.swift
//  Todoey
//
//  Created by lucas on 2019/3/28.
//  Copyright © 2019 Lucas Huang. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["第一個","第二個","第三個"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //MARK - TableView Datasource Methods
    

    //有幾個
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //製作內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
   
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        
        //已經點了再點一次會取消，反之相反
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //加上動畫
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var 想要新增的項目 : UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "增加項目", style: .default) { (action) in
            //print("點了增加項目按鈕")
            //print(想要新增的項目.text!)
            self.itemArray.append(想要新增的項目.text!)
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "新增項目名稱"
            想要新增的項目 = textField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    

}

