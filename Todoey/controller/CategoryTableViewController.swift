//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by LI WEI HUANG on 2019/4/3.
//  Copyright © 2019 Lucas Huang. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
       
    }
    
    //MARK: - TableView Datasource Methods
    
    //有幾個
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    //製作內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAt indexPath=\(indexPath)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    
    
    
    //MARK: - Data Manipulation Methods
    func saveCategories(){
        
        do{
            try context.save()
        }catch{
            print("error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    // 如果沒有給 with 就給一個預設值 Item.fetchRequest()
    func loadCategories(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            //所以我們這邊要抓取的是一個 Item 他是 NSManagedObject 類別，所以就是一個 row
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    //MARK: - 增加新的 category
    @IBAction func addButton按下(_ sender: UIBarButtonItem) {
        var 想要新增的項目 : UITextField = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "增加項目", style: .default) { (action) in

            //這邊是建立一個 Item 類別是 NSManagedObject
            //所以他其實是表格裡面的 row
            //後面的 self.context 是在上面自己創立的那一個，所以這一句我們已經改變了這個 context
            //給他多加一個 Item 進去了
            let newCategory = Category(context: self.context)
            newCategory.name = 想要新增的項目.text!
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "新增 Category 名稱"
            想要新增的項目 = textField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    

    
    
    

    
    
}
