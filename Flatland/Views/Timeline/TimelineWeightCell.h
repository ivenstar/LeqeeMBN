//
//  TimelineWeightCell.h
//  Flatland
//
//  Created by Bogdan Chitu on 29/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineEntryCell.h"
#import "TimelineEntryWeight.h"

@interface TimelineWeightCell : TimelineEntryCell

- (void) setUpWithWeight:(TimelineEntryWeight*) weight;

@end
