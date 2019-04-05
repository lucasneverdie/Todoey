//
//  Item.swift
//  Todoey
//
//  Created by LI WEI HUANG on 2019/4/5.
//  Copyright © 2019 Lucas Huang. All rights reserved.
//

import Foundation
import RealmSwift


class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    // LinkingObjects 連 Angela 都說很複雜，但事實上就只是定義了物件的反向關係
    // Category.self Angela 是說 Category 只是 class 不是 type ，加上 self 才是 type
    //後面的 items 是 modal 資料夾的 Category.swift 的 Category class 裡面創立的屬性 items
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
