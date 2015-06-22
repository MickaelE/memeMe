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
    @IBOutlet weak var tableView: UITableView!
    
        var memes: [memeObject]!
    override func viewDidLoad() {
        super.viewDidLoad()
        editorView = MemeEditorController();
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "memTableCell")

    }
    override func viewWillAppear(animated: Bool) {
        //super.viewWillAppear()
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()
       
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
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("memTableCell") as! UITableViewCell
        cell.imageView?.image = memes[indexPath.row].memeImage;

    }

    @IBAction func openMemeEditor(sender: AnyObject) {
       //Open editor.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MemeEditorController") as! MemeEditorController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}