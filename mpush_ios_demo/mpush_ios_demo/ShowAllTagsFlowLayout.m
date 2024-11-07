//
//  ShowAllTagsFlowLayout.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/11/1.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "ShowAllTagsFlowLayout.h"

@implementation ShowAllTagsFlowLayout

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newAttributesArray = [NSMutableArray array];

    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        UICollectionViewLayoutAttributes *newAttributes = [attributes copy];
        [newAttributesArray addObject:newAttributes];
    }

    // Adjust frames according to 3 columns logic
    for (UICollectionViewLayoutAttributes *attributes in newAttributesArray) {
        CGRect frame = attributes.frame;
        CGFloat totalWidth = self.collectionView.bounds.size.width;
        CGFloat itemWidth = (totalWidth - 16 - 32) / 3;
        NSInteger row = attributes.indexPath.item / 3;
        NSInteger column = attributes.indexPath.item % 3;

        frame.origin.x = 16 + column * (itemWidth + 8);
        frame.size.width = itemWidth;
        frame.size.height = 36;
        frame.origin.y = 8 + row * (frame.size.height + 8);

        attributes.frame = frame;
    }

    return newAttributesArray;
}

@end
