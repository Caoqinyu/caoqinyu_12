//
//  ViewController.swift
//  caoqinyu_12
//
//  Created by student on 2018/12/6.
//  Copyright © 2018年 2016110302. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var tableView: UITableView!
    var persons = [Person]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Persons"
        self.view.backgroundColor = UIColor.white
        
        tableView = UITableView(frame: self.view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        //添加按钮事件
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        self.navigationItem.leftBarButtonItem = searchBtn
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addBtn
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        if let i = try? context.fetch(request) {
            persons = i
        }
        tableView.reloadData()//重新加载数据
    }
    //search功能
    @objc func search() {
        let viewController = SearchViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    //add功能
    @objc func add() {
        let viewController = InsertViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = InsertViewController()
        viewController.row = indexPath.row
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // MARK: data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = persons[indexPath.row].name
        cell?.detailTextLabel?.text = String(persons[indexPath.row].age)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            persons.remove(at: indexPath.row)
            tableView.reloadData()
            DispatchQueue.global().async {//异步
                let context = self.appDelegate.persistentContainer.viewContext
                let request: NSFetchRequest<Person> = Person.fetchRequest()
                if let persons = try? context.fetch(request) {
                    context.delete(persons[indexPath.row])
                    self.appDelegate.saveContext()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
