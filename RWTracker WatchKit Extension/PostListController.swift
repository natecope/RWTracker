import WatchKit
import Foundation

class PostListController: WKInterfaceController {
    
    @IBOutlet weak var table: WKInterfaceTable!
    
    let coreDataStack = CoreDataStack()
    var posts = [Post]()
    
    lazy var dateFormatter: NSDateFormatter = {
        let dateFmt = NSDateFormatter()
        dateFmt.dateStyle = .MediumStyle
        dateFmt.timeStyle = .NoStyle
        return dateFmt
        }()
    
    @IBAction func browseAllPressed() {
        let controllers = Array<String>(count: posts.count, repeatedValue: "PostDetailsController")
        
        presentControllerWithNames(controllers, contexts: posts)
    }
    override func awakeWithContext(context: AnyObject!) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        NSLog("%@ awake", self)
        
        posts = coreDataStack.allPosts()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        
        refreshTable()
    }
    
    func refreshTable() {
        table.setNumberOfRows(posts.count, withRowType: "PostRowType")
        for (index, post) in enumerate(posts) {
            if let row = table.rowControllerAtIndex(index) as? PostRowController {
                row.titleLabel.setText(post.title)
                row.dateLabel.setText(dateFormatter.stringFromDate(post.timestamp))
                
                if post.category == "Announcements" {
                    row.categoryImage.setImageNamed("announcement")
                } else if post.category == "Podcast Episodes" {
                    row.categoryImage.setImageNamed("podcast")
                } else if post.category == "Video Tutorials" {
                    row.categoryImage.setImageNamed("video")
                } else {
                    row.categoryImage.setImageNamed("written")
                }
            }
        }
    }
    /*
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        NSLog("Showing post details from code")
        let post = posts[rowIndex]
        pushControllerWithName("PostDetailsController", context: post)
    }*/
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let post = posts[rowIndex]
        let postContent = ["title": post.title, "content": post.content]
        
        if post.category == "Podcast Episodes"{
            presentControllerWithNames(["PostDetailsController", "PostContentController", "PodcastPlayController"], contexts: [post, postContent, []])
            
        } else {
            
            presentControllerWithNames(["PostDetailsController", "PostContentController"], contexts: [post, postContent])
        }
    }
    
    @IBAction func sortByName() {
        posts.sort { (a, b) -> Bool in
            return a.title.compare(b.title, options: .CaseInsensitiveSearch,
                range: nil, locale: nil) == .OrderedAscending
        }
        refreshTable()
    }
    
    @IBAction func sortByDate() {
        posts.sort { (a, b) -> Bool in
            return a.timestamp.compare(b.timestamp) == .OrderedDescending
        }
        refreshTable()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        NSLog("Showing post details from segue")
        return posts[rowIndex]
    }
    
    override func contextsForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> [AnyObject]? {
        let post = posts[rowIndex]
        let postContent = ["title": post.title, "content": post.content]
        
        return [post, postContent]
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }
    
}
