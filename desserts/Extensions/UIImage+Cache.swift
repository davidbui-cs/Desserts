//
//  UIImage+Cache.swift
//  desserts
//
//  Created by David Bui on 6/22/22.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
extension UIImageView {
    func loadRemoteImageFrom(urlString: String, completion: @escaping () -> Void){
    let url = URL(string: urlString)
    image = nil
    activityView.center = self.center
    self.addSubview(activityView)
    activityView.startAnimating()
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
        self.image = imageFromCache
        activityView.stopAnimating()
        activityView.removeFromSuperview()
        completion()
        return
    }
    URLSession.shared.dataTask(with: url!) {
        data, response, error in
        DispatchQueue.main.async {
            activityView.stopAnimating()
            activityView.removeFromSuperview()
        }
          if let response = data {
              DispatchQueue.main.async {
                if let imageToCache = UIImage(data: response) {
                    imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    self.image = imageToCache
                    completion()
                } else {
                    self.loadRemoteImageFrom(urlString: "https://via.placeholder.com/300/000000/FFFFFF/?text=Image%20Not%20Found") {}
                }
              }
          }
     }.resume()
  }
}
