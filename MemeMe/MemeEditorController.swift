//
//  MemeEditorController.swift
//  MemeMe
//
//  Created by Mickael Eriksson on 2015-06-11.
//  Copyright (c) 2015 Mickenet. All rights reserved.
//

import Foundation
import UIKit

class MemeEditorController : UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var memeImage: UIImage!
    var activeTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var BottomText: UITextField!
    @IBOutlet weak var TopText: UITextField!
    @IBOutlet weak var openCameraButton: UIBarButtonItem!
    @IBOutlet weak var memeNavBar: UINavigationBar!
    @IBOutlet weak var memeToolBar: UIToolbar!
    @IBOutlet weak var topRestraint: NSLayoutConstraint!
    @IBOutlet weak var shareMeme: UIBarButtonItem!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName :2]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure imageView.
        imageView.contentMode = .ScaleAspectFill
       
        // Configure top textbox
        TopText.text = "Top";
        TopText.defaultTextAttributes = memeTextAttributes;
        TopText.textAlignment = NSTextAlignment.Center;
    
        // Configure bottom textbox
        BottomText.text = "Bottom";
        BottomText.defaultTextAttributes = memeTextAttributes;
        BottomText.textAlignment = NSTextAlignment.Center;
       
        //Delegates
        imagePicker.delegate = self
        TopText.delegate = self;
        BottomText.delegate = self;
        
        //Sharebutton
        if shareMeme.enabled == true {
            shareMeme.enabled = false;
        }
        
        //Camerabutton
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            openCameraButton.enabled = true
        } else {
            openCameraButton.enabled = false
        }
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.hidesBarsWhenKeyboardAppears = true
}
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true

    }
    
    @IBAction func shareMemeAction(sender: AnyObject) {
        //Share the meme
        shareMemeFuction()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Remove default.
        textField.text.removeAll(keepCapacity: false)
        activeTextField = textField;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Hide keyboard
        textField.resignFirstResponder();
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
       
        if activeTextField.tag == 1 {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if activeTextField.tag == 1 {
        self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }


    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func openImageCatalog(sender: AnyObject) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func openCamera(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let pickedImage = image as UIImage
        imageView.contentMode = .ScaleToFill
        imageView.image = pickedImage
        dismissViewControllerAnimated(true, completion: nil)
        if shareMeme.enabled == false {
            shareMeme.enabled = true;
        }
        
        //Image and text adjustment.
      /*  let height =  imageView.frame.size.height - pickedImage.size.height / 2;
        println(height)
        let width = pickedImage.size.width;
        var dy = height - topRestraint.constant
        println(dy)
       topRestraint.constant =  dy*/
        
    }
    //Meme section
    
    func save() {
        var meme = memeObject(topString: TopText.text, bottomString: BottomText.text, orginalImage: imageView.image!, memeImage: memeImage)
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.memeToolBar.hidden = true
        self.memeNavBar.hidden = true
        self.navigationController?.setToolbarHidden(true, animated:
            true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        self.memeToolBar.hidden = false
        self.memeNavBar.hidden = false
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Set Tag.
        
        return memedImage
    }
    
    func shareMemeFuction() {
        //Create the meme
        memeImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(
            activityItems: [memeImage],
            applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler  = {  (activity, success, items, error) in
            if success == true{
                self.save();
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }


}
