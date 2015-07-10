//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Mickael Eriksson on 2015-06-15.
//  Copyright (c) 2015 Mickenet. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController :UIViewController, UITableViewDelegate,UITableViewDataSource {
    var editorView:MemeEditorController?
    var memes: [memeObject]!
    var currentRow: NSIndexPath!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editorView = MemeEditorController();
        
        //Register custom tablecell.
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "memeTableCell")
        tableView.rowHeight = 60
        //Handle tab and navbar.
        if  self.tabBarController?.tabBar.hidden ==  true {
             self.tabBarController?.tabBar.hidden = false
        }
                self.navigationItem.leftBarButtonItem = self.editButtonItem();
    }
    
    override func viewWillAppear(animated: Bool) {
        //First fetch appdelegate object.
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        //Then fetch global object-
        memes = appDelegate.memes
        //Reload the datasource.
        self.tableView.reloadData()
        self.navigationController?.setToolbarHidden(true, animated: animated)
       
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //If memes object is emty, then open editor.
        if(!NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch1.0")){
            //Put any code here and it will be executed only once.
            println("Is a first launch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstlaunch1.0")
            self.performSegueWithIdentifier("memeEditorSeuge", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(memes.count)
        return memes.count

    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        
        //Create editing
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath){
            
            if editingStyle == .Delete{
                /* First remove this object from the source */
                memes.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            }
            
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        // Create menuitem for Update
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        })
        var UpdateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Detail" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.currentRow = indexPath
            self.performSegueWithIdentifier("MemeDetailSegue2", sender: self)
        })
        return [deleteAction,UpdateAction]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let customCell = self.tableView.dequeueReusableCellWithIdentifier("memeTableCell") as! CustomTableViewCell
        
        var imageName = memes[indexPath.row].memeImage
        
        let title = memes[indexPath.row].topString + " " + memes[indexPath.row].bottomString;
        customCell.loadItem(title: title, image: imageName)
        return customCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Open detail view
        performSegueWithIdentifier("MemeDetailSegue2", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
       
            //And the right seque
            if (segue.identifier == "MemeDetailSegue2") {
                // Get an handle to the object
                var viewController = segue.destinationViewController as! MemeDetailViewController
                // And pass value. If anytning is selected.
                if let indexPath = self.tableView?.indexPathForSelectedRow() {
                    viewController.detailMeme =  memes[indexPath.row]
                } else if  self.currentRow != nil {
                     viewController.detailMeme =  memes[currentRow.row]
                }
                viewController.hidesBottomBarWhenPushed  = true;
            }
         else if(segue.identifier == "memeEditorSeuge"){
            var editController = segue.destinationViewController as! MemeEditorController
            editController.hidesBottomBarWhenPushed  = true;

        }
    }
    
    @IBAction func openMemeEditor(sender: AnyObject) {
        //Open editor
        performSegueWithIdentifier("memeEditorSeuge", sender: self)
          }
}