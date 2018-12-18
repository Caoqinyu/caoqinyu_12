//
//  InsertViewController.swift
//  caoqinyu_12
//
//  Created by student on 2018/12/6.
//  Copyright © 2018年 2016110302. All rights reserved.
//

import UIKit
import CoreData

class InsertViewController: UIViewController {
    
    var row: Int?
    //定义两个文本框，分别输入姓名年龄
    var nameTextField: UITextField!
    var ageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        nameTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 44))
        nameTextField.layer.borderWidth = 1
        nameTextField.placeholder="name"
        self.view.addSubview(nameTextField)
        
        ageTextField = UITextField(frame: CGRect(x: 20, y: 200, width: 300, height: 44))
        ageTextField.layer.borderWidth = 1
        ageTextField.placeholder="age"
        self.view.addSubview(ageTextField)
        //完成按钮
        let btn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = btn
        
        if row == nil {
            self.title = "Add"
        } else {
            self.title = "Edit"
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request: NSFetchRequest<Person> = Person.fetchRequest()
            if let persons = try? context.fetch(request) {
                nameTextField.placeholder = persons[row!].name
                ageTextField.placeholder = String(persons[row!].age)
            }
        }
    }
    
    @objc func done() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //从文本框获取姓名年龄
        let name = self.nameTextField.text!
        let age = Int16(self.ageTextField.text!)
        
        if row == nil {
            if !name.isEmpty && age != nil {
                let person = Person(context: context)
                person.name = name
                person.age = age!
            }
        } else {
            let request: NSFetchRequest<Person> = Person.fetchRequest()
            if let persons = try? context.fetch(request) {
                if !name.isEmpty {
                    persons[row!].name = name
                }
                if age != nil {
                    persons[row!].age = age!
                }
            }
        }
        appDelegate.saveContext()
        self.navigationController?.popViewController(animated: true)
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
