//
//  RYTableViewController.swift
//  gitlab-iOS
//
//  Created by Xplorld on 2016/3/19.
//  Copyright © 2016年 dyweb. All rights reserved.
//

import UIKit

//TODO: (Table, Section) x (Headers, footers)
class RYTableViewController : UITableViewController {
    
    var scrollLoadEnabled = true
    var fetcher:PagedTableViewFetcher! {
        didSet {
            tryToLoadMore()
        }
    }
    //if there are only that much rows left, try to load more
    var loadMoreThreshold:Int = 5
//    var loadMoreThreshold:CGFloat = 100
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44 //as default, enable self sizing
    }
    
    var viewModels:[[TableViewCellViewModel]] = [] {
        didSet {
            tableView.reloadData()
            }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModels.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(viewModel.cellIdentifier, forIndexPath: indexPath)
        viewModel.configureCell(cell)
        
        cell.layoutIfNeeded()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewModel = viewModels[indexPath.section][indexPath.row]
        if (viewModel.resetAfterSelect ?? false) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        viewModel.didSelectCell?(indexPath,controller: self)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (viewModels.count == 0) { return }
        if (scrollLoadEnabled &&
            indexPath.section == viewModels.count-1 &&
            indexPath.row > viewModels.last!.count - loadMoreThreshold) {
            tryToLoadMore()
        }
    }
    
    //TODO:is is sufficient to
    //1. identify each action only by segue identifier?
    //2. allow only one action for each segue?
    //is it necessery to make it a Promise?
    private var seguePreparationActions:[String:(UIStoryboardSegue->Void)] = [:]
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let id = segue.identifier,
            let action = seguePreparationActions[id] {
                action(segue)
                seguePreparationActions[id] = nil
        }
    }
    func performSegueWithIdentifier(identifier: String,sender:AnyObject?, action:(UIStoryboardSegue->Void)) {
        seguePreparationActions[identifier] = action
        self.performSegueWithIdentifier(identifier, sender: sender)
    }
    
    func tryToLoadMore() {
        fetcher?.tryToFetchMore()
    }
}