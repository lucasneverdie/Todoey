//
//  Category.swift
//  Todoey
//
//  Created by LI WEI HUANG on 2019/4/5.
//  Copyright © 2019 Lucas Huang. All rights reserved.
//

import Foundation
import RealmSwift


class Category : Object {
    @objc dynamic var name : String = ""
    // List 類似 Array 就是一個容器，裡面包的內容是 Item 的 class 建立出來的物件
    // 所以這句就是做了一個 items ，裡面放了一堆 Item 的 class 建立出來的物件
    let items = List<Item>()
}
