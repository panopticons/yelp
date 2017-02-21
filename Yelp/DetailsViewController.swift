//
//  DetailsViewController.swift
//  Yelp
//
//  Created by fer on 2/20/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailsViewController: UIViewController {

  @IBOutlet weak var map: MKMapView!
  @IBOutlet weak var navig: UINavigationItem!
  @IBOutlet weak var revPic: UIImageView!
  @IBOutlet weak var revLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var addLabel: UILabel!
  @IBOutlet weak var pic: UIImageView!
  var address: String!
  var reviewPic : UIImage!
  var reviewLabel : String!
  var typeLab : String!
  var resPic: UIImage!
  let regionRadius: CLLocationDistance = 5000
  
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
      addLabel.text = address
      revPic.image = reviewPic
      revLabel.text = reviewLabel
      typeLabel.text = typeLab
      pic.image = resPic
    
    
      let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
      goToLocation(location: centerLocation)
      addAnnotationAtAddress(address: address, title: navig.title!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerOn(_ location: CLLocation)
    {
      let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
    
      map.setRegion(coordinateRegion, animated: true)
    }
  
  func goToLocation(location: CLLocation) {
    let span = MKCoordinateSpanMake(0.1, 0.1)
    let region = MKCoordinateRegionMake(location.coordinate, span)
    map.setRegion(region, animated: false)
  }
  
  // add an annotation with an address: String
  func addAnnotationAtAddress(address: String, title: String) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address) { (placemarks, error) in
      if let placemarks = placemarks {
        if placemarks.count != 0 {
          let coordinate = placemarks.first!.location!
          let annotation = MKPointAnnotation()
          annotation.coordinate = coordinate.coordinate
          annotation.title = title
          self.map.addAnnotation(annotation)
        }
      }
    }
  }
  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
