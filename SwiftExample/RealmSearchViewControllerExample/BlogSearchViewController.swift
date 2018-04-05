//
//  BlogSearchViewController.swift
//  RealmSearchViewControllerExample
//
//  Created by Adam Fish on 10/2/15.
//  Copyright © 2015 Adam Fish. All rights reserved.
//

import UIKit
import RealmSwift
import TOWebViewController

class BlogSearchViewController: RealmSearchViewController {

    @IBAction func didTapAddRecommendation(_ sender: Any) {
        let searchText = "test recommendation"
        self.realm.add(Recommendation.init(recommendationString: searchText))
    }

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 88
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.register(UINib(nibName: "BlogPostTableViewCell", bundle: nil), forCellReuseIdentifier: BlogCellIdentifier)

        self.title = self.entityName

    }

    /// Performs the search again with the current text input and base predicate
    override func refreshSearchResults() {
        let searchString = self.searchBar.text

        // Add an "add [searchString]"

        // refereshes with the search string
        super.refreshSearchResults()
    }
    
    @IBAction func addARecommendation(_ sender: Any) {
        let searchText = "test recommendation"
        try! self.realm.write {
            self.realm.add(Recommendation.init(recommendationString: searchText))
        }
    }
    override func searchViewController(_ controller: RealmSearchViewController, cellForObject object: Object, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: BlogCellIdentifier) as! BlogPostTableViewCell

        // delete everything first
        cell.emojiLabel.text = nil
        cell.contentLabel.text = nil
        cell.dateLabel.text = nil

        if let blog = object as? BlogObject {
            cell.emojiLabel.text = blog.emoji
            
            cell.titleLabel.text = blog.title
            
            cell.contentLabel.text = blog.content
            
            cell.dateLabel.text = self.dateFormatter.string(from: blog.date)
        } else if let rec = object as? Recommendation {
            cell.titleLabel.text = rec.recommendationString
        } else if let qn = object as? QuickNote {
            cell.titleLabel.text = qn.note
        }
        
        return cell
    }
    
    override func searchViewController(_ controller: RealmSearchViewController, didSelectObject anObject: Object, atIndexPath indexPath: IndexPath) {
        controller.tableView.deselectRow(at: indexPath, animated: true)
        
        if let blog = anObject as? BlogObject {
            let webViewController = TOWebViewController(urlString: blog.urlString)
            
            let navigationController = UINavigationController(rootViewController: webViewController!)
            
            self.present(navigationController, animated: true, completion: nil)
        } else if let addObject = anObject as? AddRecommendationObject {
            try! self.realm.write {
                if self.entityName == "Recommendation" {
                    self.realm.add(Recommendation.init(recommendationString: addObject.potentialString))
                } else if self.entityName == "QuickNote" {
                    self.realm.add(QuickNote.init(note: addObject.potentialString, isSelected: true))
                } else {
                    print("no support for object type: \(self.entityName)")
                }
            }
            // act as if you clicked this object
        }
    }

}
