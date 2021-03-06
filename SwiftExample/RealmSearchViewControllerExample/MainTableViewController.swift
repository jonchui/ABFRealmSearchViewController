//
//  MainTableViewController.swift
//  RealmSearchViewControllerExample
//
//  Created by Jonathan Chui on 4/4/18.
//  Copyright © 2018 Adam Fish. All rights reserved.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController, UISearchBarDelegate, RealmSearchResultsDelegate {

    var objects = [QuickNote]()

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.performSegue(withIdentifier: "pushquicknote", sender: self)
        return false
    }

    let realm = try! Realm(configuration: Realm.Configuration.defaultConfiguration)


    override func viewDidLoad() {
        super.viewDidLoad()

            self.title = "search or add an object"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitlecell", for: indexPath)

        cell.textLabel?.text = objects[indexPath.row].note

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            objects.remove(at: indexPath.row)
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

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let detailVC = segue.destination as! RealmSearchViewController

        if let indexPath = tableView.indexPathForSelectedRow{
            let cell = tableView.cellForRow(at: indexPath)
            detailVC.entityName = cell?.textLabel?.text
            detailVC.searchPropertyKeyPath = cell?.detailTextLabel?.text
        } else if segue.identifier == "pushquicknote" {
            let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0))
            detailVC.entityName = "QuickNote"
            detailVC.searchPropertyKeyPath = "note"
        }

        detailVC.realm = self.realm
        detailVC.resultsDelegate = self
    }

    func searchViewController(_ controller: RealmSearchViewController, didSelectObject anObject: Object, atIndexPath indexPath: IndexPath) {
        let quicknoteObject : QuickNote
        if let addObject = anObject as? AddRecommendationObject {
            quicknoteObject = QuickNote.init(note: addObject.potentialString, isSelected: true)
            try! self.realm.write {
                self.realm.add(quicknoteObject)
            }
        } else {
            quicknoteObject = anObject as! QuickNote
        }

//        controller.searchBar.resignFirstResponder()
        objects.append(quicknoteObject)

        self.dismiss(animated: true) { [weak self] in
            let row = min(0,(self?.objects.count)!-1)
//            self?.tableView.reloadRows(at: [IndexPath.init(row: row, section: 0)], with: UITableViewRowAnimation.bottom)
        }
        self.tableView.reloadData()
        print("selected object: \(anObject)")
    }

    func searchViewController(_ controller: RealmSearchViewController, willSelectObject anObject: Object, atIndexPath indexPath: IndexPath) {
        print("will select")
    }


}
