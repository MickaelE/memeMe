//
//  MemeEditorController.swift
//  MemeMe
//
//  Created by Mickael Eriksson on 2015-06-11.
//  Copyright (c) 2015 Mickenet. All rights reserved.
//

import Foundation
import UIKit

class MemeEditorController : UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var imagePicker = UIImagePickerController()
    var memeImage: UIImage!
    var activeTextField: UITextField!
    var editMeme: memeObject!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var BottomText: UITextField!
    @IBOutlet weak var TopText: UITextField!
    @IBOutlet weak var openCameraButton: UIBarButtonItem!
    @IBOutlet weak var shareMeme: UIBarButtonItem!
    @IBOutlet weak var navBarOutlet: UINavigationItem!
    @IBOutlet weak var memeToolBar: UIToolbar!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName :-3]

    override func viewDidLoad() {
        super.viewDidLoad()
      
        //Configure imageView.
        imageView.contentMode = .ScaleAspectFill
       
        // Configure top textbox
        TopText.text = "Top";
        formatTextField(TopText) //Changed
    
        // Configure bottom textbox
        BottomText.text = "Bottom";
        formatTextField(BottomText) //Changed
       
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
        
        //If its edit time.
        if editMeme != nil {
            TopText.text = editMeme.topString
            BottomText.text = editMeme.bottomString
            imageView.image = editMeme.orginalImage
             self.memeToolBar.hidden = false
        }
    }
    
    func formatTextField(text: UITextField){
        //Common formatting.
        text.defaultTextAttributes = memeTextAttributes;
        text.textAlignment = NSTextAlignment.Center;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        //Subscribe to notifcations
        self.subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func subscribeToKeyboardNotifications() {
        // Create notifications.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        //Remove supscriptions.
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if activeTextField.tag == 1 {
            self.view.frame.origin.y = -getKeyboardHeight(notification)
        }     }
    
    func keyboardWillHide(notification: NSNotification) {
        if activeTextField.tag == 1 {
            //Changed.
            view.frame.origin.y = 0 //Changed
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func openImageCatalog(sender: AnyObject) {
        //Open library
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func openCamera(sender: AnyObject) {
        //Open camera if present.
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //Open imagepicker.
        let pickedImage = image as UIImage
        imageView.contentMode = .ScaleAspectFit
        imageView.image = pickedImage
        if shareMeme.enabled == false {
            shareMeme.enabled = true;
        }
        dismissViewControllerAnimated(true, completion: nil)
        memeToolBar.hidden = false
    }
    //Meme section
    
    func save() {
        //Stop unwanted saves.
        if memeImage != nil {
        //Save to global object.
            var meme = memeObject(topString: TopText.text,bottomString: BottomText.text,orginalImage: imageView.image!,memeImage: memeImage)
            // Add it to the memes array in the Application Delegate
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme)
         }
    }
    
    func generateMemedImage() -> UIImage {
        //Hide toolbar and navbar.
        memeToolBar.hidden = true
        navigationController?.setToolbarHidden(true, animated:
            true)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        memeToolBar.hidden = false
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        return memedImage
    }
    
    func shareMemeFuction() {
        //Create the meme
        memeImage = generateMemedImage()
        
        //Open standard share controller.
        let activityViewController = UIActivityViewController(
            activityItems: [memeImage],
            applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler  = {  (activity, success, items, error) in
            if success == true{
                self.save();
                self.dismissViewControllerAnimated(false, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        // Cancel button.
        navigationController?.popToRootViewControllerAnimated(true)
    }
}