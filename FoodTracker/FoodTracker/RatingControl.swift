//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Winnie Hou on 2020-01-25.
//  Copyright © 2020 Winnie Hou. All rights reserved.
//

import UIKit

//IBDesignable class adding support for interface builder. 
@IBDesignable class RatingControl: UIStackView {
    //MARK: Properties
    //ratingButtons contains a list of UIButtons
    private var ratingButtons = [UIButton]()
    //initialize the rating value to 0
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    //Define the size and number of buttons in the control. 所以IBInspectable的意思就是，可以在Inspector里面找到的property
    //IBDesignable的意思就是，可以在Design view里看到的内容
    //the didSet is property observer, which observe and responds to chnges in a property's value, and update the control
    //可以改变property，update size和count，但是没法把旧的内容清除
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        // Call superclass' initializer
        super.init(frame: frame)
        // Add the button in initializer
        setupButtons()
    }
    
    //initializer
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }

    //MARK: Private Methods
    private func setupButtons() {
        // clear existing buttons before create the ones
        //First, remove the button from list of views, then from the stack view
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        //Then, clear the ratingButtons array
        ratingButtons.removeAll()
        
        //Load button image. The images load from asset catalog, which is in the App's main bundle.
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar  = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        // 5 UIButtons required in as Rating buttons. Thus, put the setup process in loop, to create 5 of them
        for _ in 0..<starCount {
            //Create the button
            let button = UIButton()
            // button.backgroundColor = UIColor.red
            // Button 的不同状态，根据状态给出button的图片。
            // Buttons have five different states: normal, highlighted, focused, selected, and disabled. By default, the button modifies its appearance based on its state, for example a disabled button appears grayed out. A button can be in more than one state at the same time, such as when a button is both disabled and highlighted.
            // Buttons always start in the normal state (not highlighted, selected, focused, or disabled). A button is highlighted whenever the user touches it. You can also programmatically set a button to be selected or disabled. The focused state is used by focus-based interfaces, like Apple TV.
            // In the code above, you are telling the button to use the empty star image for the normal state. This is the button’s default image. The system uses this image (possibly with an added effect) whenever a state or combination of states doesn’t have an image of their own.

            // Next, the code above sets the filled image for the selected state. If you programmatically set the button as selected, it will change from the empty star to the filled star.

            // Finally, you set the highlighted image for both the highlighted and the selected and highlighted states. When the user touches the button, whether or not it is selected, the system will show the highlighted button image.
            button.setImage(filledStar, for: .selected)
            button.setImage(emptyStar, for: .normal)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            // Add constrains
            //disable buttons's automatically generated constrains.
            button.translatesAutoresizingMaskIntoConstraints = false
            // following 2 lines define the hight and width of button.
            button.heightAnchor.constraint(equalToConstant: starSize.width).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.height).isActive = true
            
            //Add accessible
            button.accessibilityLabel = "Set \(index) star rating"
            // Selector returns the selector value. When the button is tapped, system call the action method, which is ratingButtonTapped method
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            // Add the button to the stack, the stack is the view just created, add the view as a subview of RatingControl, also create the constrains.
            addArrangedSubview(button)
            // Append the new created button in the ratingButtons list.
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button \(button) is not in rating button array \(ratingButtons)")
        }
        
        // Calcuate the selected button's index
        let selectedRating = index + 1
        
        
        if selectedRating == rating {
            // If selected star is the current rating, reset the rating
            rating = 0
        } else {
            // Otherwise, set the rating to selected rating
            rating = selectedRating
        }
       // print("rating is \(rating)")
    }
 
    private func updateButtonSelectionStates () {
        for (index, button) in ratingButtons.enumerated() {
            // if the button's index is smaller than the rating, all the buttons should be selected.
            button.isSelected = index < rating

            // Set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
             
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
             
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}

