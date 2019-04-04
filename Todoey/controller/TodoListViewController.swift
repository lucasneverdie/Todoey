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
    
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    // AppDelegate 是 class 是藍圖，我們創立一個物件來使用
    // UIApplication.shared 是一個 singleton 的 app 實體
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        

        //loadItems()
        
    }
    
    
    //MARK: - TableView Datasource Methods
    
    
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
    
    //MARK: - TableView Delegate Methods
    
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
            newItem.parentCategory = self.selectedCategory
            
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
    
    // MARK: - model manupulation methods
    
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    // 如果沒有給 with 就給一個預設值 Item.fetchRequest()
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        // 塞選種類
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // 可增加變成兩種塞選機制 另一種是搜尋
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
        }
        else{
            // 如果 input 沒寫 predicate 就只要 塞選目前種類就好了
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//
//        request.predicate = predicate
        
        do{
            //所以我們這邊要抓取的是一個 Item 他是 NSManagedObject 類別，所以就是一個 row
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }  
    
}


//MARK: - search bar methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //建立一條新的請求
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //print(searchBar.text!)
        //在 title 搜尋包含 searchBar.text 的東西
        //https://academy.realm.io/posts/nspredicate-cheatsheet/
        //搜尋預設是對大小寫和讀音敏感的
        //c是case 大小寫 d 是diacritic ， 我們希望搜尋的時候對他們「不敏感」，所以加上cd
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //排序
        //sortDescriptor 是複數的，是一個 array ，但我們現在只需要一個排序的規則 ，所以放一個進去陣列裡面就好了
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        loadItems(with: request, predicate: predicate)
       
    }
    
    //文字有改變就會觸發
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //如果有改變文字，並且改成沒有文字就會觸發
        if searchBar.text?.count == 0 {
            loadItems()
            
            //dispatchQueue 是一個類似管理員的人，他覺得排哪一個隊伍(線程)
            //有的隊伍是24工作 有的是一天只工作一小時
            //我們現在把它排到主線程 main ，抓回主線程才可以按搜尋框框裡面的X就可以回復初始狀態
            //這裡看不懂，老師說要把他抓回「前景」主線程就對了
            //async 異步
            DispatchQueue.main.async {
                //回到編輯searchBar之前的狀態（鼠標、鍵盤消失）
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
    
}
