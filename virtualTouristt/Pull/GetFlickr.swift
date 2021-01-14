//
//  GetFlickr.swift
//  virtualTouristt
//
//  Created by Jieun Bae on 1/6/21.
//

import Foundation
import UIKit

class GetFlickr

  {
    
   
    static let source = "https://api.flickr.com/services/rest?method=flickr.photos.search&api_key=37bf4c51bc2e4f0d67fbea0aa6b66464&extras=url_n&format=json&safe_search=1&per_page=30&page=1&nojsoncallback=1"

    
   
    static func location(pin: Pin) -> String
    
        {
            let lowestLong = max(pin.lat - 0.25, -90)
            let lowestLat = max(pin.lon - 0.25, -175)
            let highestLat = min(pin.lat + 0.25, 90)
            let highestLong = min(pin.lon + 0.25, 175)
            return "\(lowestLong),\(lowestLat),\(highestLat),\(highestLong)"
        }

  
    //retrieve info
    class func showResult(latitude: Double, longitude: Double, pin: Pin, completion: @escaping([FlickrPhoto]?, Error?)->Void)
    {
    
        
        let url = URL(string: source + "&lat=\(latitude)&lon=\(longitude)")
        print(url)
        
        guard let unwrappedURL = url else {
            return
        }

        let task = URLSession.shared.dataTask(with: unwrappedURL) { (data, response, error) in
        if error != nil

        {
            fatalError("\(error!.localizedDescription)")
        }


        do
        {

        let decoder = JSONDecoder()

        let responseData = try decoder.decode(DataFile.self, from: data!)

        DispatchQueue.main.async
        {
          completion(responseData.photos.photo, nil)
        }

        } catch

        {
        completion(nil, error)
        return
      }
    }


        task.resume()
  }

    //downloads image from flickr website
    class func retrieveFile(imageURL: URL , pin: Pin, completion: @escaping (Data?, Error?)->Void)
    
    {
    let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
    guard let data = data else
    
        {
        
        //notify if there is an error dowloading
        fatalError(error!.localizedDescription)
        }
        
      completion(data, nil)
    }
        
    task.resume()
    }
    
}
