import Foundation
import CoreData

@objc(Post)
class Post: NSManagedObject {

  @NSManaged var category: String
  @NSManaged var content: String
  @NSManaged var identifier: String
  @NSManaged var link: String
  @NSManaged var timestamp: NSDate
  @NSManaged var title: String

}
