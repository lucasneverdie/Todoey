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
    
    
    //creatie a file path to the documents folder
    //創建資料夾的檔案路徑？ 創立檔案路徑給資料夾？
    // FileManager.default 也是一個 singleton
    // 因為這是一個 array 所以first (集合的第一個元素)
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadItems()
        
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
        
        saveItems()
        
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
            
            self.saveItems()
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "新增項目名稱"
            想要新增的項目 = textField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK - model manupulation methods
    
    func saveItems(){
        //編碼器
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath!)
        }catch{
            print("erro encoding item array, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("loadItems錯誤, \(error)")
            }
        }
    }
    
    
    
}

