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
    
    var oauthswift: OAuthSwift?
    var books : [BookModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let books = [
            BookModel(bookCoverSource: "https://files.kerching.raywenderlich.com/covers/d5693015-46b6-44f8-bf7b-7a222b28d9fe.png",
                      bookId: "0",
                      bookTitle: "Realm: Building Modern Swift Apps with Realm"),
            BookModel(bookCoverSource: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYEkCQ_wu8HoGJzzs_gUH_FVusgI2RhntBKQ-WkmqnDJZnriwY6Q",
                      bookId: "1",
                      bookTitle: "iOS 10 by Tutorials: Learning the new iOS APIs with Swift 3")
        ]
 */
        
        
        doOAuthGoodreads()
        
        shelfView = PlainShelfView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height : UIScreen.main.bounds.height),
                                   bookModel: books, bookSource: PlainShelfView.BOOK_SOURCE_URL)
        
        shelfView.delegate = self
        self.view.addSubview(shelfView)
    }
    
    func onBookClicked(_ shelfView: PlainShelfView, index: Int, bookId: String, bookTitle: String) {
        print("I just clicked \"\(bookTitle)\" with bookId \(bookId), at index \(index)")
    }
    
    //API TESTING SECTION
    
    func doOAuthGoodreads(){
        /** 1 . create an instance of OAuth1 **/
        let oauthswift = OAuth1Swift(
            consumerKey:        "9VcjOWtKzmFGW8o91rxXg",
            consumerSecret:     "j7GVH7skvvgQRwLIJ7RGlEUVTN3QsrhoCt38VTno",
            requestTokenUrl:    "https://www.goodreads.com/oauth/request_token",
            authorizeUrl:       "https://www.goodreads.com/oauth/authorize?mobile=1",
            accessTokenUrl:     "https://www.goodreads.com/oauth/access_token"
        )
        self.oauthswift=oauthswift
        oauthswift.allowMissingOAuthVerifier = true
        oauthswift.authorizeURLHandler = getURLHandler()
        /** 2 . authorize with a redirect url **/
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "BookWyrm://oauth-callback/goodreads")!,
            success: { credential, response, parameters in
                
                self.testOauthGoodreads(oauthswift) {id in
                    let _ = oauthswift.client.request(
                        "https://www.goodreads.com/review/list/\(id).xml?key=9VcjOWtKzmFGW8o91rxXg&v=2", method: .GET,
                        success: { response in
                            
                            /** parse the returned xml to read user id **/
                            let dataString = response.string!
                            let xml = SWXMLHash.parse(dataString)
                       
                            var i = 0
                            for elem in xml["GoodreadsResponse"]["reviews"]["review"].all {
                                self.books.append(BookModel(bookCoverSource: elem["book"]["image_url"].element!.text,
                                                       bookId: elem["book"]["id"].element!.text,
                                                       bookTitle: elem["book"]["title"].element!.text))
                                
                                //print(elem["book"]["isbn"].element!.text)
                               i = i + 1
                            }
                            //print("---- RAW:\(dataString)")
                            //print("---- XML:\(xml)")
                            
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
    
    
    func testOauthGoodreads(_ oauthswift: OAuth1Swift, callback: @escaping (_ id: String) -> Void){
        let _ = oauthswift.client.get(
            "https://www.goodreads.com/api/auth_user",
            success: { response in
                
                /** parse the returned xml to read user id **/
                let dataString = response.string!
                let xml = SWXMLHash.parse(dataString)
                let userID  =  (xml["GoodreadsResponse"]["user"].element?.attribute(by: "id")?.text)!
                //print("---- RAW:\(dataString)")
                //print("---- XML:\(xml)")
                print("---- USER ID:\(userID)")
                callback(userID)
                
                
        }, failure: { error in
            print(error)
        }
        )
        
       
    }
    
    
    // token alert
    func showTokenAlert(name: String?, credential: OAuthSwiftCredential) {
        var message = "oauth_token:\(credential.oauthToken)"
        if !credential.oauthTokenSecret.isEmpty {
            message += "\n\noauth_token_secret:\(credential.oauthTokenSecret)"
        }
        self.showAlertView(title: name ?? "Service", message: message)
    }
    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
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
    
}

