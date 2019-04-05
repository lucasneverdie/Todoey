//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by LI WEI HUANG on 2019/4/3.
//  Copyright © 2019 Lucas Huang. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    //這邊不用管! 這樣就可以 不用搞其他的
    let realm = try! Realm()
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
       
    }
    
    //MARK: - TableView Datasource Methods
    
    //有幾個
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //製作內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAt indexPath=\(indexPath)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "還沒有種類喔"
        
        return cell
    }
    

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    func save(category : Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    // 如果沒有給 with 就給一個預設值 Item.fetchRequest()
    func loadCategories(){
        
       categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    
    //MARK: - 增加新的 category
    @IBAction func addButton按下(_ sender: UIBarButtonItem) {
        var 想要新增的項目 : UITextField = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "增加項目", style: .default) { (action) in

            let newCategory = Category()
            newCategory.name = 想要新增的項目.text!
           
            self.save(category: newCategory)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "新增 Category 名稱"
            想要新增的項目 = textField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }

    
}
