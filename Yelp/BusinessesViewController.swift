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
  var isMoreDataLoading = false
  var offset: Int = 0
  var s: UISearchController!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 120
    
        self.s = UISearchController(searchResultsController: nil)
        self.s.searchResultsUpdater = self
        self.s.searchBar.delegate = self
    
        self.s.hidesNavigationBarDuringPresentation = false
        self.s.dimsBackgroundDuringPresentation = false
    
        s.searchBar.sizeToFit()
    
        nav.titleView = s.searchBar
    
    Business.searchWithTerm(term: "", offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.filtered = businesses
          self.table.reloadData()
            if let businesses = businesses {
                /*for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }*/
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
  
  public func updateSearchResults(for searchController: UISearchController) {
    if let searched = searchController.searchBar.text {
      if searched.isEmpty {
        filtered = businesses
      }
      else
      {
        filtered = businesses!.filter({(dataItem: Business) -> Bool in
          let title = dataItem.name!
          if title.range(of: searched, options: .caseInsensitive) != nil {
            return true
          }
          else {
            return false
          }
        })
      }
      table.reloadData()
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if filtered != nil {
      return filtered.count
    }else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = table.dequeueReusableCell(withIdentifier: "busCell", for: indexPath) as! BusinessViewCell
    
    cell.restaurant = filtered[indexPath.row]
    return cell
  }
  
  func loadMoreData() {
    offset += 5
    
    Business.searchWithTerm(term: "", offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in

      self.isMoreDataLoading = false
      self.businesses.append(contentsOf: businesses!)
      //self.filtered.append(contentsOf: businesses!)
      
      self.table.reloadData()
    }
    )
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (!isMoreDataLoading) {
      
      let scrollViewContentHeight = table.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - table.bounds.size.height
      
      
      if(scrollView.contentOffset.y > scrollOffsetThreshold && table.isDragging) {
        
        isMoreDataLoading = true
        
        loadMoreData()
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let cell = sender as! BusinessViewCell
    let indexPath = table.indexPath(for: cell)
    //let business = filtered![indexPath!.item]
    
    let dViewController = segue.destination as! DetailsViewController
    
  }
}
