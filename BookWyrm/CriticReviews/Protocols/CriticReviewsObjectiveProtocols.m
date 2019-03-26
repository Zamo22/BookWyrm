//
//  CriticReviewsObjectiveProtocols.m
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/03/19.
//  Copyright © 2019 DVT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReviewsControllable <NSObject>

- (void )reloadTable;
- (void )displayErrorPopup : (NSString*) error : (NSString*) title;

@end
