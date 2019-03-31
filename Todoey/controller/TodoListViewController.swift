//
//  ViewController.swift
//  Todoey
//
//  Created by lucas on 2019/3/28.
//  Copyright © 2019 Lucas Huang. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var mydefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let newItem = Item()
        newItem.title = "find"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "find"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "find"
        itemArray.append(newItem3)
        
        
        
        
        // 把存在裝置的 user default 抓回來餵給 itemArray
        if let items = mydefaults.array(forKey:"TodoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    
    
    //MARK - TableView Datasource Methods
    
    
    //有幾個
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //製作內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        //        if item.done == true{
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        //
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
        //這一句跟下面五句是一樣的
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //        if itemArray[indexPath.row].done == false {
        //            itemArray[indexPath.row].done = true
        //        }
        //        else {
        //            itemArray[indexPath.row].done = false
        //        }
        
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        
        //已經點了再點一次會取消，反之相反
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }
        //        else{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        
        
        tableView.reloadData()
        
        
        //加上動畫
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var 想要新增的項目 : UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "增加項目", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = 想要新增的項目.text!
            
            //print("點了增加項目按鈕")
            //print(想要新增的項目.text!)
            self.itemArray.append(newItem)
            
            self.mydefaults.set(self.itemArray, forKey: "TodoListArray")
            
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

