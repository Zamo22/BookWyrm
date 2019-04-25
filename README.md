# BookWyrm

[![codecov](https://codecov.io/gh/Zamo22/BookWyrm/branch/develop/graph/badge.svg)](https://codecov.io/gh/Zamo22/BookWyrm) [![Build Status](https://app.bitrise.io/app/df34b9a35b9f6f07/status.svg?token=a03LtFXbiPc4cR8VzDpqmw&branch=develop)](https://app.bitrise.io/app/df34b9a35b9f6f07) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/649ba797436e45c397a22621559b5767)](https://app.codacy.com/app/Zamo22/BookWyrm?utm_source=github.com&utm_medium=referral&utm_content=Zamo22/BookWyrm&utm_campaign=Badge_Grade_Dashboard)
[![Build status](https://build.appcenter.ms/v0.1/apps/e566ce5e-8287-4093-b520-931906484da0/branches/develop/badge)](https://appcenter.ms)

An iOS application intended for bookworms to discover and keep track of books that they're interested in.

## Features

### Book Search
The application makes use of Google's massive database of books to help users find the books they want, regardless of how obscure it may be.

<img src = "./Screenshots/Empty Search Screen Portrait.png"  width = "300"  height = "550">   &nbsp;&nbsp;&nbsp;&nbsp; <img src = "./Screenshots/Search Screen with Results Portrait.png"  width = "300"  height = "550"> 

### Book Details
Naturally, you should be able to do more than just see high level search results. Selecting a book allows you to see important information to help you find your next read. An average Goodreads rating, Critic Review snippets and other similar books are just some of the information presented to you.

<img src = "./Screenshots/Artemis Fowl Time Paradox Details Portrait.png"  width = "300"  height = "550">  &nbsp;&nbsp;&nbsp;&nbsp;  <img src = "./Screenshots/Artemis Fowl Time Paradox Bottom Details Portrait.png"  width = "300"  height = "550"> 

#### Critic Reviews
Using the iDreamBooks API, the application fetches relevant book reviews by reputable and recognizable critics to help you decide on a book.

<img src = "./Screenshots/Critic Reviews Portrait.png"  width = "300"  height = "550"> 

#### Posting your own Review
As an avid book fan, you would of course want to share your thoughts on the book you just read, positive or negative. The application allows you to leave your review for a book which will later be used when recommending you books.

<img src = "./Screenshots/Empty Review Portrait.png"  width = "300"  height = "550"> &nbsp;&nbsp;&nbsp;&nbsp;  <img src = "./Screenshots/Filled Review Portrait.png"  width = "300"  height = "550"> 

### Bookshelf
Of course you, may want to bookmark certain books that you have read or may want to read (which you can do very conventiently with the bookmark icon). Books that you have bookmarked show up on your personal bookshelf for easy revisiting and are utilized when generating recommendations for you.

<img src = "./Screenshots/Bookshelf Portrait.png"  width = "300"  height = "550">  &nbsp;&nbsp;&nbsp;&nbsp;  <img src = "./Screenshots/Bookshelf Landscape.png"  width = "400"  height = "250"> 

### Recommendations
Uses your personal tastes to recommend books that may interest you

<img src = "./Screenshots/Recommendations Portrait.png"  width = "300"  height = "550">

## Technologies Used

Implements Alamofire, SWXMLHash and SwiftyJSON for speedy and fluent data retrieval and parsing
Uses OAuthSwift to manage oauth tokens and sessions
Makes use of ShelfView to create an aesthetically pleasing and easily managed bookshelf
Uses Firebase Core to provide Application analytics

Makes use of the Google Books and iDreamBooks apis as data sources
Uses GoodReads api to manage the virtual bookshelf
Also accesses a self-made swift backend service that partially relies on the iDreamBooks (found here: insert github url) which assists with the speedy retrieval of popular recommendations.

## Requirements

- iOS 12.0+
- Xcode 10.2
- Swift 4.2

More information to come....
