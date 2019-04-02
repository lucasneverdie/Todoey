//
//  ViewController.swift
//  Todoey
//
//  Created by lucas on 2019/3/28.
//  Copyright © 2019 Lucas Huang. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // AppDelegate 是 class 是藍圖，我們創立一個物件來使用
    // UIApplication.shared 是一個 singleton 的 app 實體
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
        loadItems()
        
        
    }
    
    
    //MARK - TableView Datasource Methods
    
    
    //有幾個
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //製作內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAt indexPath=\(indexPath)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("didSelectRowAt indexPath= \(indexPath)")
        //print("itemArray[indexPath.row]= \(itemArray[indexPath.row])")
        
        //update 就是使用 setValue
        //itemArray[indexPath.row].setValue("新給得值", forKey: "title")
        //這樣也可以 setValue
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        //刪除
        //刪除 context 的先
        //context.delete(itemArray[indexPath.row])
        //刪除array，注意這邊跟 Core Data 無關，這邊是我們自己建立的 Array
        //itemArray.remove(at: indexPath.row)
        
        
        
        //
        
        saveItems()
        
        
        //加上動畫
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var 想要新增的項目 : UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "增加項目", style: .default) { (action) in
            
            
            
            //這邊是建立一個 Item 類別是 NSManagedObject
            //所以他其實是表格裡面的 row
            //後面的 self.context 是在上面自己創立的那一個，所以這一句我們已經改變了這個 context
            //給他多加一個 Item 進去了
            let newItem = Item(context: self.context)
            newItem.title = 想要新增的項目.text!
            newItem.done = false
            
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
        
        do{
            try context.save()
        }catch{
            print("error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(){
        
        //這個 Item 是類別，一般不用寫類別，但是這邊要
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            //所以我們這邊要抓取的是一個 Item 他是 NSManagedObject 類別，所以就是一個 row
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        
    }
    
    
    
}

