//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Winnie Hou on 2020-02-01.
//  Copyright © 2020 Winnie Hou. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    // MARK: Properties
    // Initial the meals which is an empty array of Meal
    // the meals is mutable, which is a variable, with var
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        //Load any saved meals, otherwise load sample data.
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            loadSampleMeals()
        }
        
        // Load the sample data
        loadSampleMeals()
    }

    // MARK: - Table view data source
    // 显示dynamic data，table view需要两个helpers：data source和delegate
    // data source: 提供显示在table view里的数据
    // delegate:管理table view里的cell selection和其他跟显示数据有关的事宜。
    // 以下三个function就是table view的protocol implementation
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // numberOfSections，返回需要显示的section个数
        // Section是dvisual groupings of cells within table views
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 返回table viewd里的row个数
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are resued and should be dequeued using a cell iderntifier. Creating the identifier
        let cellIdentifier = "MealTableViewCell"
        // the dequeueReusableCell method requests a cell from the table view.
        // When the user scrolls, the table can try to reuse the cells when possible, instead of delete and create new cells
        // If no cells are available, the function instantiates a new one.
        // The function's identifier tells which type of cell it should create or reuse.
        // The as? attempts to downcast the returned object from the UITableViewCell class to MealtableViewCell, and the returns optional
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the dat source layout
        let meal = meals[indexPath.row]

        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        super.prepare(for: segue, sender: sender)
           
           switch(segue.identifier ?? "") {
               
           case "addItem":
               os_log("Adding a new meal.", log: OSLog.default, type: .debug)
               
           case "showDetail":
               guard let mealDetailViewController = segue.destination as? MealViewController else {
                   fatalError("Unexpected destination: \(segue.destination)")
               }
               
               guard let selectedMealCell = sender as? MealTableViewCell else {
                   fatalError("Unexpected sender: \(sender)")
               }
               
               guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                   fatalError("The selected cell is not being displayed by the table")
               }
               
               let selectedMeal = meals[indexPath.row]
               mealDetailViewController.meal = selectedMeal
               
           default:
               fatalError("Unexpected Segue Identifier; \(segue.identifier)")
           }
    }
    
    
    //MARK: Actions:
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        // downcast segue's source view controller to a MealViewController instance.
        // If the meal proerty is non-nil, the code assigns the value of that proerty to the local constant meal and executes the if statement.
        // If downcast succeeds, the code assigns the MealViewController instance to the local constant sourceViewController, and checks to see if the meal proerty on sourceViewController is nil. If the meal property is non-nil, the code assigns the value of that proerty to the local constant meal and executes the if statement.
        // If either the downcast failes, or the meal proerty on sourceViewController is nil, the condition evauluates to false.
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
           // Modify an existing meal
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // add a new meal
                //caculate the position of new meal in the tableview for a new table view cell.
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals
            saveMeals()
        }
    }

    // MARK: Private Methods
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")

        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }

        meals += [meal1, meal2, meal3]
    }
    
    private func saveMeals() {
        // attemp to archive the meals array to the URL path.
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals ...", log: OSLog.default, type: .error
            )
        }
    }
    // Return a list of Meal, or nil
    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
}
