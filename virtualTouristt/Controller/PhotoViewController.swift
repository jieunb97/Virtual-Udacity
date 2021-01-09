//
//  PhotoViewController.swift
//  virtualTouristt
//
//  Created by Jieun Bae on 12/30/20.
//

import UIKit
import CoreData



protocol FRCCollectionViewDelegate: class

    {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell}

    class PhotoViewController: UIViewController, UICollectionViewDelegate
    
        {
        
        var fetchedResultsController: NSFetchedResultsController<Photo>!
        var pin: Pin!
        var countPhotos = 0
        var list: [FlickrPhoto] = []
        var dataController: DataController!
     
        @IBOutlet weak var noImages: UILabel!
        @IBOutlet weak var newLoad: UIButton!
        @IBOutlet weak var collectionView: UICollectionView!
        let dispatchGroup = DispatchGroup()
        weak var delegate: FRCCollectionViewDelegate?
        var blockOperation = BlockOperation()
        
        override func viewDidLoad()
    
        {
            super.viewDidLoad()

            collectionView.delegate = self
           
            fetchResults()
        }

        override func viewWillAppear(_ animated: Bool)
        {
        
            super.viewWillAppear(animated)
            initialSetup()

            if let photos = pin.photo, photos.count > 0 {
                newLoad.isHidden = false
            }
            else {
                fetchPhoto(pin: pin)
            }
        
        }

        override func viewWillDisappear(_ animated: Bool)
        {
            super.viewWillDisappear(animated)
            fetchedResultsController = nil
            
        }

        
        func initialSetup()
        {
            noImages.isHidden = true
            newLoad.isHidden = true
        }

        //loads new photo everytime this button is clicked
        @IBAction func newCollection(_ sender: Any)
        {
        if let photos = fetchedResultsController.fetchedObjects
            {
                for photo in photos
                    {
                    self.dataController.viewContext.delete(photo)
                    try? self.dataController.viewContext.save()
                    }
            
            }
            
            fetchPhoto(pin: pin)
                }


      fileprivate func fetchResults()
      
      {
        
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pin", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(String(describing: pin))-photo")
        fetchedResultsController.delegate = self
            do
                {
                    try fetchedResultsController.performFetch()
                } catch {
                    
                fatalError(error.localizedDescription)
                }
        
        
            }

        func fetchPhoto(pin: Pin)
        
        {
            
            initialSetup()
            
            GetFlickr.showResult(latitude: Double, longitude: Double, pin: Pin) { (list, error) in
           
    
            self.countPhotos = list?.count ?? 0
            self.downloadPhotos(list: list!, pin: pin)
            DispatchQueue.main.async
                {
                if list?.count == 0
                    {
                    self.noImages.isHidden = false
                    }
                
                self.dispatchGroup.notify(queue: .main)
                    {
                    self.newLoad.isHidden = false
                    }
                
                self.collectionView.reloadData()
                }
            
            }
        }

        func downloadPhotos(list: [FlickrPhoto], pin: Pin)
        
        {
            
            
        for item in list
        
            {
            guard let imageURL = URL(string: item.url_n) else
            {
            return
            }
            GetFlickr.retrieveFile(imageURL: imageURL, pin: pin, completion: taskForDownload)
            
            }
            
        }
        
      
        
        func taskForDownload(data: Data?, error: Error?)
        
            {
            dispatchGroup.enter()
            let photo = Photo(context: self.dataController.viewContext)
            photo.photoFile = data
            photo.pin = self.pin
            try? self.dataController.viewContext.save()
            dispatchGroup.leave()
            do {
                
            }
                
            }
        }


