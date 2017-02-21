//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate, UISearchResultsUpdating {
  
  @IBOutlet weak var nav: UINavigationItem!
  @IBOutlet weak var table: UITableView!
  var businesses: [Business]!
  var filtered: [Business]!
  var search: UISearchBar!
  var isMoreDataLoading = false
  var offset: Int = 0
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 120
      
        search = UISearchBar()
        search.sizeToFit()
        nav.titleView = search
      
    Business.searchWithTerm(term: "Chinese", offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
          self.table.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if businesses != nil {
      return businesses.count
    }else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = table.dequeueReusableCell(withIdentifier: "busCell", for: indexPath) as! BusinessViewCell
    
    cell.restaurant = businesses[indexPath.row]
    return cell
  }
  
  @available(iOS 8.0, *)
  public func updateSearchResults(for searchController: UISearchController) {
    //
  }
  
  func loadMoreData() {
    offset += 5
    
    Business.searchWithTerm(term: "Chinese", offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
      
      //self.businesses = businesses
      self.isMoreDataLoading = false
      self.businesses.append(contentsOf: businesses!)
      self.filtered = businesses
      
      self.table.reloadData()
    }
    )
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (!isMoreDataLoading) {
      // Calculate the position of one screen length before the bottom of the results
      let scrollViewContentHeight = table.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - table.bounds.size.height
      
      // When the user has scrolled past the threshold, start requesting
      if(scrollView.contentOffset.y > scrollOffsetThreshold && table.isDragging) {
        
        isMoreDataLoading = true
        
        // Code to load more results
        loadMoreData()
      }
    }
  }
}
