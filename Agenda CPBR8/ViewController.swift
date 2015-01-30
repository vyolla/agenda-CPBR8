//
//  ViewController.swift
//  Agenda CPBR8
//
//  Created by Bruno Patrocinio on 23/01/15.
//  Copyright (c) 2015 Bruno Patrocinio. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class ViewController: UIViewController,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var names = [String]()
    var items = [NSManagedObject]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Agenda CPBR8"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Agenda")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            items = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    @IBAction func addName(sender: AnyObject) {
        self.Delete()
        var alert = UIAlertController(title: "Nome", message: "Adicionar Nome", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {(action:UIAlertAction!) in
        let textField = alert.textFields![0] as UITextField
            self.saveData(textField.text)
            self.names.append(textField.text)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: {(action: UIAlertAction!) in})
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in})
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    func Delete() {
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Agenda")
        var myList = context.executeFetchRequest(request, error: nil)!
        
        var bas: NSManagedObject!
        
        for bas: AnyObject in myList
        {
            context.deleteObject(bas as NSManagedObject)
        }
        
        myList.removeAll(keepCapacity: false)
        context.save(nil)
    }

    
    func saveData(name: String) {
        
        for index in 1...201 {
            
        DataManager.getAgendaWithSuccess { (agendaData) -> Void in
            let json = JSON(data: agendaData)
            
            var colortext: NSString
            colortext = self.getRgbColor(json[index]["stage"].string!)
            var dateTime : Double = json[index]["date"].double! / 1000
            var timeDate = NSDate(timeIntervalSince1970: dateTime)
           // cell.textLabel?.text = json[indexPath.row]["title"].string
            //cell.textLabel?.textColor = self.UIColorFromRGB(0xFFFFFF)
           // cell.backgroundColor = colortext
           
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContex = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Agenda", inManagedObjectContext: managedContex)
        
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContex)
        
        item.setValue(json[index]["title"].string, forKey: "title")
        item.setValue(json[index]["id"].string, forKey: "id")
        item.setValue(json[index]["stage"].string, forKey: "stage")
        item.setValue(timeDate, forKey: "datetime")
        item.setValue(colortext, forKey: "color")
        var error: NSError?
        if !managedContex.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        self.items.append(item)
             }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("AgendaCell", forIndexPath: indexPath) as UITableViewCell
        
        let item = items[indexPath.row]
        if let titleLabel = cell.viewWithTag(101) as? UILabel{
            titleLabel.text = item.valueForKey("title") as String?
            titleLabel.numberOfLines = 2
            titleLabel.lineBreakMode.hashValue
        }
        
        if let stageLabel = cell.viewWithTag(102) as? UILabel{
            stageLabel.text = item.valueForKey("stage") as String?
        }
        
        if let datetimeLabel = cell.viewWithTag(103) as? UILabel{
            var date = item.valueForKey("datetime") as NSDate
            datetimeLabel.text = self.dateformatterDate(date)
        }
        
        var cellColor: String = item.valueForKey("stage") as String!
        cell.backgroundColor = self.UIColorFromRGB(self.getRgbColorToInt(cellColor))
        println(item.valueForKey("color"))
        return cell
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(0.80)
        )
    }
    
    func dateformatterDate(date: NSDate) -> NSString
    {
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM HH:mm"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        return dateFormatter.stringFromDate(date)
    }
    
    func getRgbColor(color: NSString) ->NSString
    {
        switch(color){
        case "cpbr8-earth":
            return "0x3399ff"
        case "cpbr8-jupiter":
            return "0x8f468b"
        case "cpbr8-mars":
            return "0xf7a100"
        case "cpbr8-moon":
            return "0x003399"
        case "cpbr8-neptune":
            return "0x087c95"
        case "cpbr8-saturn":
            return "0x6ebb27"
        case "cpbr8-sun":
            return "0xd4d202"
        case "cpbr8-uranus":
            return "0x43d2f1"
        case "cpbr8-venus":
            return "0xb80168"
        case "cpbr8-workshop1":
            return "0x4ab1f3"
        case "cpbr8-workshop2":
            return "0x0083d6"
        case "cpbr8-workshop3":
            return "0x0066b4"
        case "cpbr8-crossspace":
            return "0x999999"
        case "cpbr8-startupmakers":
            return "0x666"
        case "cpbr8-workshopsstartupmakers":
            return "0x666"
            
        default:
            return "0xFFF"
        }
    }
    
    func getRgbColorToInt(color: NSString) -> UInt
    {
        switch(color){
        case "cpbr8-earth":
            return 0x3399ff
        case "cpbr8-jupiter":
            return 0x8f468b
        case "cpbr8-mars":
            return 0xf7a100
        case "cpbr8-moon":
            return 0x003399
        case "cpbr8-neptune":
            return 0x087c95
        case "cpbr8-saturn":
            return 0x6ebb27
        case "cpbr8-sun":
            return 0xd4d202
        case "cpbr8-uranus":
            return 0x43d2f1
        case "cpbr8-venus":
            return 0xb80168
        case "cpbr8-workshop1":
            return 0x4ab1f3
        case "cpbr8-workshop2":
            return 0x0083d6
        case "cpbr8-workshop3":
            return 0x0066b4
        case "cpbr8-crossspace":
            return 0x999999
        case "cpbr8-startupmakers", "cpbr8-workshopsstartupmakers":
            return 0x666
        default:
            return 0xFFF
        }
    }


}

