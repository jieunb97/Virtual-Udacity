//
//  PhotoFetch.swift
//  virtualTouristt
//
//  Created by Jieun Bae on 1/7/21.
//

import Foundation
import UIKit


    extension PhotoViewController: UICollectionViewDataSource
    
        {

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
            {
            return fetchedResultsController.fetchedObjects?.count ?? 0
            }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        
            {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoAlbumCell", for: indexPath) as! PhotoAlbumCell
            
   
                if let imageData = fetchedResultsController.object(at: indexPath).photoFile
                {
                    cell.imageView.image = UIImage(data: imageData)
                }
                    return cell
                }

        
        
        func numberOfSections(in collectionView: UICollectionView) -> Int
        
            {
            return 1
            }

  
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        
            {
            self.dataController.viewContext.delete(self.fetchedResultsController.object(at: indexPath))
            try? self.dataController.viewContext.save()
            }
        
        
            }

