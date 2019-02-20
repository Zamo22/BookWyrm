//
//  DetailViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/02/11.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit
import OAuthSwift
import SafariServices
import SWXMLHash
import  Alamofire

class DetailViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var readingListButton: UIButton!
    @IBOutlet weak var readingLinkButton: UIButton!
    
    //Why do I not just directly assign?? --research
    var selectedTitle: String?
    var selectedAuthor: String?
    var selectedGenre: String?
    var selectedPublishedDate: String?
    var selectedIsbn: String?
    var selectedNumPages: String?
    var selectedDescription: String?
    var reviewDetailsToSend: String?
    var readingLink: String?
    
    var oauthswift: OAuthSwift?
    var oAuthUserID: String?
    
    private let apiFetcher = APIRequestFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    func setupView () {
        if let titleToLoad = selectedTitle {
            self.titleLabel.text = titleToLoad
            self.titleLabel.textColor = .white
        }
        
        if let authorToLoad = selectedAuthor {
            self.authorLabel.text = authorToLoad
            self.authorLabel.textColor = .white
        }
        
        if let descriptionToLoad = selectedDescription {
            self.descriptionText.text = descriptionToLoad
            self.descriptionText.textColor = .white
        }
        
        if let genreToLoad = selectedGenre {
            self.genreLabel.text = genreToLoad
            self.genreLabel.textColor = .white
        }
        
        if let publishedToLoad = selectedPublishedDate {
            self.publishedLabel.text = publishedToLoad
            self.publishedLabel.textColor = .white
        }
        
        if let isbnToLoad = selectedIsbn {
            self.isbnLabel.text = isbnToLoad
            self.isbnLabel.textColor = .white
        }
        
        if let pagesToLoad = selectedNumPages {
            self.pagesLabel.text = pagesToLoad
            self.pagesLabel.textColor = .white
        }
        
        
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
        //Maybe use threads here to do this asyncrhonously
        
        if(true) { //Modify this later to check if book is already bookmarked first, stays as true for now
            readingListButton.setImage(UIImage(named: "bookmark"), for:  .normal)
        }
        
        apiFetcher.checkReviews(reviewData: self.reviewDetailsToSend!, completionHandler: {
            [weak self] check, error in
            
           if (!check) {
                self?.reviewsButton.isHidden = true
            }
        })
        
        if (readingLink == nil) {
            self.readingLinkButton.isHidden = true
        }
        
        
    }
    
    func doOAuthGoodreads() {
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
                self.testOauthGoodreads(oauthswift)
        },
            failure: { error in
                print( "ERROR ERROR: \(error.localizedDescription)", terminator: "")
        }
        )
    }
    
    
    func testOauthGoodreads(_ oauthswift: OAuth1Swift ) {
       
        getBookID(oauthswift) { book_Id in
            let params: [String : Any] = [
                "name": "read",
                "book_id": book_Id
            ]
            
                let _ = oauthswift.client.post("https://www.goodreads.com/shelf/add_to_shelf.xml", parameters: params,
                    success: {response in
                    print(response.data)},
                    failure: {error in
                    print(error)
                    })
            
            
            
        }
        
    }
    
    func getBookID (_ oauthswift: OAuth1Swift, callback: @escaping (_ id: String) -> Void) {
        let urlWithSpaces = "https://www.goodreads.com/search/index.xml?key=9VcjOWtKzmFGW8o91rxXg&q=\(reviewDetailsToSend ?? "Harry Potter")&search[title]"
        guard let url = urlWithSpaces.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        let _ = oauthswift.client.get(url,
            success: {response in
            let dataString = response.string!
            let xml = SWXMLHash.parse(dataString)
                                        
            guard let book_id = xml["GoodreadsResponse"]["search"]["results"]["work"][0]["best_book"]["id"].element?.text else {
                return
            }
                                        
            callback(book_id)
                                        
        }, failure: {
            error in
            print(error)
        })
    }
    
    
    // token alert
    func showTokenAlert(name: String?, credential: OAuthSwiftCredential) {
        var message = "oauth_token:\(credential.oauthToken)"
        if !credential.oauthTokenSecret.isEmpty {
            message += "\n\noauth_token_secret:\(credential.oauthTokenSecret)"
        }
        //self.showAlertView(title: name ?? "Service", message: message)
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
    
    
    @IBAction func clickReviews(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Reviews") as? ReviewsTableViewController {
            vc.reviewDetails = reviewDetailsToSend
            vc.title = "Reviews for: \(reviewDetailsToSend ?? "Error - No book")"
        navigationController?.pushViewController(vc, animated: true)
    }
        
    }
    
    
    @IBAction func clickReadingList(_ sender: UIButton) {
        //Add or remove item from reading list
        doOAuthGoodreads()
    }
    
    @IBAction func clickReadingLink(_ sender: UIButton) {
        //Add code to open google book ? on iOS ???
    }
    
}
