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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editorView = MemeEditorController();
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "memTableCell")

    }
    override func viewWillAppear(animated: Bool) {
        //First fetch appdelegate object.
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        //Then fetch global object-
        memes = appDelegate.memes
        //Reload the datasource.
        self.tableView.reloadData()
        
        //If memes object is emty, then open editor.
        if memes.count == 0 {
            openMemeEditor(self)
        }
       
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(memes.count)
        return memes.count

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("memTableCell") as! UITableViewCell
        var imageName = memes[indexPath.row].memeImage
    
        cell.imageView?.contentMode  = .ScaleAspectFit
        cell.imageView?.image = imageName;
    
        cell.textLabel?.text = memes[indexPath.row].bottomString;
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("MemeDetailSegue2", sender: self)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        // If anytning is selected.
         if let indexPath = self.tableView?.indexPathForSelectedRow() {
            //And the right seque
            if (segue.identifier == "MemeDetailSegue2") {
                // Get an handle to the object
                var viewController = segue.destinationViewController as! MemeDetailViewController
                // And pass value.
                viewController.singleMeme =  memes[indexPath.row].memeImage
            }
        }
    }
    
    @IBAction func openMemeEditor(sender: AnyObject) {
       //Open segue editor.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MemeEditorController") as! MemeEditorController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}