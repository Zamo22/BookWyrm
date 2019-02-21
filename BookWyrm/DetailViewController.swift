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
    
    var inList = false
    
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
        
        
        
        checkIfInList() { check in
            if(!check) {
                self.readingListButton.setImage(UIImage(named: "bookmark"), for:  .normal)
            }
            else {
               self.readingListButton.setImage(UIImage(named: "bookmarkFilled"), for:  .normal)
            }
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
    
    func checkIfInList(callback: @escaping (_ check: Bool) -> Void)   {
        let oauthSwift : OAuth1Swift = self.oauthswift as! OAuth1Swift
        
        getGoodreadsUserID() {id in
            //Uses ID that was received to get a list of users books read
            let _ = oauthSwift.client.request(
                "https://www.goodreads.com/review/list/\(id).xml?key=9VcjOWtKzmFGW8o91rxXg&v=2", method: .GET,
                success: { response in
                    
                    var books : [String] = []
                    
                    let dataString = response.string!
                    let xml = SWXMLHash.parse(dataString)
                    
                    //Change this to include if statement inside for loop to speed up process
                    for elem in xml["GoodreadsResponse"]["reviews"]["review"].all {
                        //Add book ID to array
                        books.append(elem["book"]["id"].element!.text)
                    }
                    
                    self.getBookID(oauthSwift) { book_Id in

                        for book in books {
                            if (book_Id == book) {
                                self.inList = true
                            }
                        }
                        
                        callback(self.inList)
                    }
                    
            }, failure: { error in
                print(error)
            }
            )
        }
    }
    
    func getGoodreadsUserID(callback: @escaping (_ id: String) -> Void){
        let oauthSwift : OAuth1Swift = self.oauthswift as! OAuth1Swift
        
        let _ = oauthSwift.client.get(
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
    
    func modifyBookshelf(_ oauthswift: OAuth1Swift ) {
        
        if(!inList) {
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
        modifyBookshelf(self.oauthswift as! OAuth1Swift)
    }
    
    @IBAction func clickReadingLink(_ sender: UIButton) {
        //Add code to open google book ? on iOS ???
    }
    
}
