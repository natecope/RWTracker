
import Foundation
import CoreData

class CoreDataStack {
  // MARK: - Core Data things

  var context: NSManagedObjectContext
  var psc: NSPersistentStoreCoordinator
  var model: NSManagedObjectModel
  var store: NSPersistentStore?

  init() {
    let bundle = NSBundle.mainBundle()
    let modelURL = bundle.URLForResource("RWTracker", withExtension:"momd")
    model = NSManagedObjectModel(contentsOfURL: modelURL!)!
    
    psc = NSPersistentStoreCoordinator(managedObjectModel:model)
    
    context = NSManagedObjectContext()
    context.persistentStoreCoordinator = psc

    var error: NSError? = nil
    store = psc.addPersistentStoreWithType(NSInMemoryStoreType,
      configuration: nil,
      URL: nil,
      options: nil,
      error:&error)
    
    if store == nil {
      println("Error adding persistent store: \(error)")
      abort()
    }

    loadStarterData()
  }
  
  func saveContext() {
    var error: NSError? = nil
    if context.hasChanges && !context.save(&error) {
      println("Could not save: \(error), \(error?.userInfo)")
    }
  }

  // MARK: - RWTracker helpers

  func loadStarterData() {
    if let starterDataURL = NSBundle(forClass: CoreDataStack.self).URLForResource("rw_feed", withExtension: "plist") {
      if let starterData = NSArray(contentsOfURL: starterDataURL) as? [NSDictionary] {
        for post in starterData {
          var itemObject: NSManagedObject!

          let fetch = NSFetchRequest(entityName: "Post")
          fetch.predicate = NSPredicate(format: "identifier = %@", argumentArray: [post["identifier"]!])

          if let results = context.executeFetchRequest(fetch, error: nil) {
            if let existingItem = results.first as? NSManagedObject {
              itemObject = existingItem
            }
          }

          if itemObject == nil {
            itemObject = NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: context) as NSManagedObject
          }

          itemObject.setValue(post["category"], forKey: "category")
          itemObject.setValue(post["identifier"], forKey: "identifier")
          itemObject.setValue(post["link"], forKey: "link")
          itemObject.setValue(post["timestamp"], forKey: "timestamp")
          itemObject.setValue(post["title"], forKey: "title")
          itemObject.setValue(post["content"], forKey: "content")
        }
      }
    }

    saveContext()
  }

  func allPosts() -> [Post] {
    let fetch = NSFetchRequest(entityName: "Post")
    fetch.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
    if let results = context.executeFetchRequest(fetch, error: nil) as? [Post] {
      return results
    }

    return []
  }

  func mostRecentPost() -> Post? {
    let results = allPosts()
    if let item = results.first {
      return item
    }

    return nil
  }

  func mostRecentPostForCategory(category: String) -> Post? {
    let fetch = NSFetchRequest(entityName: "Post")
    fetch.predicate = NSPredicate(format: "category like %@", argumentArray: [category])
    fetch.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
    if let results = context.executeFetchRequest(fetch, error: nil) {
      if let item = results.first as? Post {
        return item
      }
    }

    return nil
  }
}
