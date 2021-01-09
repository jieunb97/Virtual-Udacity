//
//  DataController.swift
//  virtualTouristt
//
//  Created by Jieun Bae on 1/6/21.
//
import Foundation
import CoreData

class DataController

  {

  var container:NSPersistentContainer

  var viewContext:NSManagedObjectContext
  
    {
    return container.viewContext
    }

  init(modelName:String)
  
    {
    container = NSPersistentContainer(name: modelName)
    }
  
  func load(handler: (()->Void)?=nil)
  
    {
    container.loadPersistentStores { (storeDescription, error) in
      guard error == nil else
        {
        fatalError(error!.localizedDescription)
        }
      handler?()
    
    }
    
  }
}
