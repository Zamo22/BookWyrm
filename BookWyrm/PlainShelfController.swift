//
//  PlainShelfController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import ShelfView
import OAuthSwift
import SWXMLHash
import SafariServices

class PlainShelfController: UIViewController, PlainShelfViewDelegate {
    var shelfView: PlainShelfView!
    
    //Create the oAuth token(?) that we'll use to hold our authentication and make requests
    var oauthswift: OAuthSwift?
    var books : [BookModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Authenticate user, calls methods to populate shelfView
        doOAuthGoodreads()
        
        //Create shelfview
        shelfView = PlainShelfView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height : UIScreen.main.bounds.height),
                                   bookModel: books, bookSource: PlainShelfView.BOOK_SOURCE_URL)
        shelfView.tag = 100
        
        shelfView.delegate = self
        self.view.addSubview(shelfView)
    }
    
    //Will Add code here
    func onBookClicked(_ shelfView: PlainShelfView, index: Int, bookId: String, bookTitle: String) {
        print("I just clicked \"\(bookTitle)\" with bookId \(bookId), at index \(index)")
    }
    
    
    func doOAuthGoodreads(){
        //1 . create an instance of OAuth1 with keys, maybe make keys hidden later
        let oauthswift = OAuth1Swift(
            consumerKey:        "9VcjOWtKzmFGW8o91rxXg",
            consumerSecret:     "j7GVH7skvvgQRwLIJ7RGlEUVTN3QsrhoCt38VTno",
            requestTokenUrl:    "https://www.goodreads.com/oauth/request_token",
            authorizeUrl:       "https://www.goodreads.com/oauth/authorize?mobile=1",
            accessTokenUrl:     "https://www.goodreads.com/oauth/access_token"
        )
        
        //Set these details to global oauth profile
        self.oauthswift=oauthswift
        oauthswift.allowMissingOAuthVerifier = true
        oauthswift.authorizeURLHandler = getURLHandler()
        /** 2 . authorize with a redirect url **/
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "BookWyrm://oauth-callback/goodreads")!,
            success: { credential, response, parameters in
                
                //After authorizing, run method to verify authentication and get users id
                self.testOauthGoodreads(oauthswift) {id in
                    //Uses ID that was received to get a list of users books read
                    let _ = oauthswift.client.request(
                        "https://www.goodreads.com/review/list/\(id).xml?key=9VcjOWtKzmFGW8o91rxXg&v=2", method: .GET,
                        success: { response in
                            
                            
                            let dataString = response.string!
                            let xml = SWXMLHash.parse(dataString)
                            
                            //Iterate over books that user has read
                            for elem in xml["GoodreadsResponse"]["reviews"]["review"].all {
                                //Add each book to books model
                                self.books.append(BookModel(bookCoverSource: elem["book"]["image_url"].element!.text,
                                                       bookId: elem["book"]["id"].element!.text,
                                                       bookTitle: elem["book"]["title"].element!.text))
                                
                              
                            }
                            
                            //Reload shelfview with update book model
                            self.shelfView.reloadBooks(bookModel: self.books)
                            
                    
                            
                    }, failure: { error in
                        print(error)
                    }
                    )
                }
            
        },
            failure: { error in
                print( "ERROR ERROR: \(error.localizedDescription)", terminator: "")
        }
        )
        
    }
    
    //Runs an escaping method that fetches users ID
    func testOauthGoodreads(_ oauthswift: OAuth1Swift, callback: @escaping (_ id: String) -> Void){
        let _ = oauthswift.client.get(
            "https://www.goodreads.com/api/auth_user",
            success: { response in
                
                /** parse the returned xml to read user id **/
                let dataString = response.string!
                let xml = SWXMLHash.parse(dataString)
                let userID  =  (xml["GoodreadsResponse"]["user"].element?.attribute(by: "id")?.text)!
                callback(userID)
                
        }, failure: { error in
            print(error)
        }
        )
        
       
    }
    
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        if #available(iOS 9.0, *) {
            let handler = SafariURLHandler(viewController: self, oauthSwift: self.oauthswift!)
            /* handler.presentCompletion = {
             print("Safari presented")
             }
             handler.dismissCompletion = {
             print("Safari dismissed")
             }*/
            handler.factory = { url in
                let controller = SFSafariViewController(url: url)
                // Customize it, for instance
                if #available(iOS 10.0, *) {
                    // controller.preferredBarTintColor = UIColor.red
                }
                return controller
            }
            
            return handler
        }
        return OAuthSwiftOpenURLExternally.sharedInstance
    }
    
    //Handles removing current subview and 
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        shelfView = PlainShelfView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height : UIScreen.main.bounds.height),
                                   bookModel: books, bookSource: PlainShelfView.BOOK_SOURCE_URL)
        shelfView.tag = 100
        
        self.view.addSubview(shelfView)
    }
    
}

