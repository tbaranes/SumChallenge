//
//  SCHomeViewController.h
//  Sum Challenge
//
//  Created by Tom Baranes on 27/05/14.
//  Copyright (c) 2014 Tom Baranes. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "SCGameView.h"

@interface SCHomeViewController : UIViewController <GKGameCenterControllerDelegate, SCGameDelegate>

@property (strong, nonatomic) IBOutlet SCGameView *viewGame;

@property (strong, nonatomic) IBOutlet UIView *viewMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnRanking;
@property (strong, nonatomic) IBOutlet UIButton *btnLaunchGame;
@property (strong, nonatomic) IBOutlet UILabel *labelYourScore;
@property (strong, nonatomic) IBOutlet UILabel *labelBestScore;

@property (strong, nonatomic) IBOutlet UIView *viewOperation;
@property (strong, nonatomic) IBOutlet UILabel *labelFirstNumber;
@property (strong, nonatomic) IBOutlet UILabel *labelOperationSign;
@property (strong, nonatomic) IBOutlet UILabel *labelSecondNumber;
@property (strong, nonatomic) IBOutlet UILabel *labelEqualSign;
@property (strong, nonatomic) IBOutlet UILabel *labelResult;

@end
