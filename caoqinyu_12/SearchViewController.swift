
//
//  SearchViewController.swift
//  caoqinyu_12
//
//  Created by student on 2018/12/6.
//  Copyright © 2018年 2016110302. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nameTextField: UITextField!
    var ageTextField: UITextField!
    var tableView: UITableView!
    var persons = [Person]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        self.title = "Search"
        
        nameTextField = UITextField(frame: CGRect(x: 10, y: 100, width: 200, height: 44))
        nameTextField.layer.borderWidth = 1
        self.view.addSubview(nameTextField)
        
        let nameBtn = UIButton(frame: CGRect(x: 250, y: 100, width: 100, height: 44))
        nameBtn.setTitle("按姓名查找", for: .normal)
        nameBtn.setTitleColor(UIColor.cyan, for: .normal)
        nameBtn.setTitleColor(UIColor.brown, for: .highlighted)
        nameBtn.addTarget(self, action: #selector(searchWithName), for: .touchUpInside)
        self.view.addSubview(nameBtn)
        
        ageTextField = UITextField(frame: CGRect(x: 10, y: 150, width: 200, height: 44))
        ageTextField.layer.borderWidth = 1
        self.view.addSubview(ageTextField)
        
        let ageBtn = UIButton(frame: CGRect(x: 250, y: 150, width: 100, height: 44))
        ageBtn.setTitle("按年龄查找", for: .normal)
        ageBtn.setTitleColor(UIColor.cyan, for: .normal)
        ageBtn.setTitleColor(UIColor.brown, for: .highlighted)
        ageBtn.addTarget(self, action: #selector(searchWithAge), for: .touchUpInside)
        self.view.addSubview(ageBtn)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: self.view.frame.height - 200))
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
    }
    
    @objc func searchWithName() {
        ageTextField.text = ""
        //通过appDelegate获取上下文
        let context = appDelegate.persistentContainer.viewContext
        let name = nameTextField.text
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        if name != nil {
            request.predicate = NSPredicate(format: "name = %@", name!)
        }
        if let persons = try? context.fetch(request) {
            self.persons = persons
            tableView.reloadData()
        }
    }
    //年龄查找
    @objc func searchWithAge() {
        nameTextField.text = ""
        let context = appDelegate.persistentContainer.viewContext
        
        let age = Int16(ageTextField.text!)
        
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        if age != nil {
            request.predicate = NSPredicate(format: "age = %d", age!)
        }
        if let persons = try? context.fetch(request) {
            self.persons = persons
            tableView.reloadData()
        }
    }
    
    // MARK: data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        cell?.textLabel?.text = persons[indexPath.row].name
        cell?.detailTextLabel?.text = String(persons[indexPath.row].age)
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
