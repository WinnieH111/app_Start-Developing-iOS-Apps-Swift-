//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Winnie Hou on 2020-01-21.
//  Copyright © 2020 Winnie Hou. All rights reserved.
//
// EVENT-DRIVEN PROGRAMMING

// View 和 Controller的区别？
// A view displays content, whereas a control is used to modify the content in some way. A control (UIControl) is a subclass of UIView

// Storyboard和source code的联系
// Scene：1个screen的内容和1个view controller
// View Controller implement app‘s behavior，管理1个single content view以及他们的subviews，协调app的data model信息，显示data，输入反馈，管理content views的life cycle，管理硬件位置，

// Create multiple sense in a single view controller, manage loading and unloading views

// Delegate: an object that acts on behalf of, or in coordination with, another object.
import UIKit

// import the os.log to create unwind/wind segue.
// unwind segue moves backward through one or more segues to return the user to a scene managed by an existing view controller. You can return to view controllers that already exist. Use unwind segues to implement navigation back to an existing view controller.
// While regular segune create a new instance of the destination view controller
import os.log
// How a textfield delegate works? communicates with text field while the user is editing the text, and know when important events occur, use the information to save or clear data at the right time, dismiss keyboard, etc.
// Any object can serve as a delegate for another object as long as it conforms to the appropriate protocol.
// The protocol that defines a text field's delegate is called UITextFieldDelegate.

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Properties
    // IBOutlet: can connect to the nameTextField proerty from Interface Builder
    // weak: the reference does not prevent the system from deallocating the refernced object
    //! : the UITextField type is an implicitly unwrapped optional, which is an optional type that will always have a value after it is first set.(THE VALID VALUE NEED TO BE SET BEFORE INITIALIZATION!)
    //OUTLET: let you refer to your interface elements in code.
    //ACTION: how user interact with the elements.
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    /*
     This value is either passed by 'MealTableViewController'
     in 'prepare(for:sender:)' or constructed as part of adding a new meals.
     */
    var meal: Meal?
    //UIViewController methods:
    //viewDidLoad（）: 当view controller的content view（hierarchy最高级）created and loaded from storyboard时调用，一般只调用一次，就是app开始的时候。
    //viewWillAppear（）：called just before the view controller's content view is added to the app's view hierarchy. Use this method to trigger any operations that need to occur before the content view is presented on screen, indicates that the content view is about to be added to the app's view hierarchy.
    // viewDidAppear(): called just after the view controller's content view has been added to the app's view hierarchy. trigger any operations that need to occur as soon as the view is presented onscreen, such as fetching data or showing an animation, indicates the content view has been added to the app's view hierarchy
    // viewWillDisappear(): called just before the view controller's content view is removed from the app's view hierarchy. to cleanup tasks like committing changes, resigning the first responder status.
    // viewDidDisappear(): called just after the view controller's content view has been removed from the app's view hierarchy. perform additional teardown activitie.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field's user input through delegate callbacks.
        // "self" refers to "ViewController" class, inside the scope of MealViewController class definition.
        nameTextField.delegate = self
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // Enable the save button only if the text field has a valid Meal name
        updateSaveButtonState()
    }

    // MARK: Navigation

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in 2 diferent ways.
        let isPresentinginAddMealMode = presentingViewController is UINavigationController
        if isPresentinginAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        // Else, the user is editing an existing meal. The meal detail scene was pushed onto a navigation stack when the user selected a meal from the meal list. If the view controller has been pushed onto a navigation stack, this proerty contains a reference to the stack's navigation controller.
        // popViewController can pops the current view controller (the meal detail scene) off the navigation stack and animates the transition.
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    
    // This method lets you configure a view controller before it's presented
   override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        super.prepare(for: segue, sender: sender)
 
        // Configure the destination view controller only when the save button is pressed.
        // Verify the sender is a button. check s　that
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
    
        // Set the meal to be passed to MealTableViewController after the unwind segue
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    
    // MARK: Actions
    // Target-Action Pattern
    //@IBAction func setDefaultLabelText(_ sender: UIButton) {
    //    mealNameLabel.text = "Default Text"
    // }
    
    // MARK: UITextFieldDelegate
    // 当returnd之后，就resign first responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        // whether the system should process the press of Return key.
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 之前的mealNameLabel在“Create a table view” 里面删除了，这段内容也不relevent了
        // textField 编辑结束，讲期值赋给mealNameLabel
        //mealNameLabel.text = textField.text
        //Check if the text field has text in it, to decide enable save button or not
        updateSaveButtonState()
        // Set the navigation title with the text
        navigationItem.title = textField.text
    }
    
    
    // 图片本身并不能建立Action，所以需要gesture建立Action
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // 激活图片响应的时候，隐藏textfield的键盘
        nameTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
    // UIImagePickerController的对象，imagePickerCOntroller的来源是photolibrary，也就是camara roll。
        // photolibrary其实是UIImagePickerControllerSourceType.photoLibrary的缩写。
        imagePickerController.sourceType = .photoLibrary
        // Make sure MealViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        //  The method asks MealViewController to present the view controller defined by imagePickerController. Passing true to the animated parameter animates the presentation of the image picker controller. The completion parameter refers to a completion handler, a piece of code that executes after this method completes. Because you don’t need to do anything else, you indicate that you don’t need to execute a completion handler by passing in nil.
        present(imagePickerController, animated: true, completion: nil)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    // MARK: UIImagePickerControllerDelegate
    // 当user 取消选择图片时候的动作
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // 下面的func imagePickerController里，info是一个字典，包含selected original image，可能包含dedited version of the image。 这这里，使用original image
    // 在selectedImage里面，unwrap the dict，and casts it as a UIImage object
    // 如果cast出现错误，fatalError就会抛出和记录console错误。
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {fatalError("Expected a dictionary containing and image, but was provided the following:\(info)")
            }
        
        //Set photoImageView to display the selected image
        photoImageView.image = selectedImage

       //Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    // MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}

