//
//  PhotoFetchResult.swift
//  virtualTouristt
//
//  Created by Jieun Bae on 1/7/21.
//

import UIKit
import CoreData

    extension PhotoViewController: NSFetchedResultsControllerDelegate
    
        {
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            
            //functions for collectionview cell
            switch type
                {
                case .insert:
                    collectionView.insertItems(at: [newIndexPath!])
                case .delete:
                    collectionView.deleteItems(at: [indexPath!])
                case .update:
                    collectionView.reloadItems(at: [newIndexPath!])
                case .move:
                    collectionView.moveItem(at: indexPath!, to: newIndexPath!)
                default:
                fatalError("error")
                }
            
        }

        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
        
            {

            let indexSet = IndexSet(integer: sectionIndex)
            switch type
                {
                case .insert:
                    collectionView.insertSections(indexSet)
                case .delete:
                    collectionView.deleteSections(indexSet)
                default:
                fatalError("error")
                }
            }

        }

