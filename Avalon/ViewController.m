//
//  ViewController.m
//  Avalon
//
//  Created by Yi Lang Mok on 10/17/15.
//  Copyright © 2015 Jabberrock. All rights reserved.
//

#import "ViewController.h"
#import "AVFoundation/AVFoundation.h"

static NSTimeInterval ThumbsPhaseDelay = 1 * NSEC_PER_SEC;
static NSTimeInterval IdentifyPhaseDelay = 4 * NSEC_PER_SEC;
static NSTimeInterval BetweenPhasesDelay = 2 * NSEC_PER_SEC;

typedef NS_ENUM(NSInteger, GameState)
{
    GameStateStart,
    GameStateGoToSleep,
    GameStateGoToSleepWait,
    GameStateBadGuysAwake,
    GameStateBadGuysWait,
    GameStateBadGuysSleep,
    GameStateBadGuysSleepWait,
    GameStateMerlinBadGuysThumbsUp,
    GameStateMerlinBadGuysThumbsUpWait,
    GameStateMerlinAwake,
    GameStateMerlinWait,
    GameStateMerlinSleep,
    GameStateMerlinSleepWait,
    GameStatePercivalMerlinMorganaThumbsUp,
    GameStatePercivalMerlinMorganaThumbsUpWait,
    GameStatePercivalAwake,
    GameStatePercivalWait,
    GameStatePercivalSleep,
    GameStatePercivalSleepWait,
    GameStateAwaken,
    GameStateComplete
};

@interface ViewController () <AVSpeechSynthesizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnMordred;
@property (weak, nonatomic) IBOutlet UIButton *btnMorgana;
@property (weak, nonatomic) IBOutlet UIButton *btnAssassin;
@property (weak, nonatomic) IBOutlet UIButton *btnOberon;
@property (weak, nonatomic) IBOutlet UIButton *btnMinions;
@property (weak, nonatomic) IBOutlet UIButton *btnPercival;

@property (nonatomic) AVSpeechSynthesizer *synth;
@property (nonatomic) NSMutableDictionary *toggleStates;
@property (nonatomic) GameState gameState;

@end

@implementation ViewController

-(void)viewDidLoad
{
    self.synth = [[AVSpeechSynthesizer alloc] init];
    [self.synth setDelegate:self];
    
    self.toggleStates = [[NSMutableDictionary alloc] init];
    
    [super viewDidLoad];
}

-(IBAction)toggleCharacterButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSValue *buttonKey = [NSValue valueWithNonretainedObject:button];
    
    NSNumber *toggleState = [self.toggleStates objectForKey:buttonKey];
    if (!toggleState)
    {
        toggleState = [NSNumber numberWithBool:NO];
    }
    
    BOOL newToggleState = ![toggleState boolValue];
    
    [self.toggleStates setObject:[NSNumber numberWithBool:newToggleState] forKey:buttonKey];
    
    button.layer.backgroundColor = newToggleState ? [[UIColor yellowColor] CGColor] : [[UIColor clearColor] CGColor];
}

-(BOOL)isCharacterSelected:(UIButton *)button
{
    NSValue *buttonKey = [NSValue valueWithNonretainedObject:button];
    
    NSNumber *toggleState = [self.toggleStates objectForKey:buttonKey];
    
    return [toggleState boolValue];
}

-(IBAction)startGame:(id)sender
{
    self.gameState = GameStateStart;
    
    [self advanceGameState];
}

-(void)advanceGameState
{
    switch (self.gameState)
    {
        case GameStateStart:
        {
            self.gameState = GameStateGoToSleep;
            break;
        }
            
        case GameStateGoToSleep:
        {
            self.gameState = GameStateGoToSleepWait;
            break;
        }
            
        case GameStateGoToSleepWait:
        {
            self.gameState = GameStateBadGuysAwake;
            break;
        }
            
        case GameStateBadGuysAwake:
        {
            self.gameState = GameStateBadGuysWait;
            break;
        }
            
        case GameStateBadGuysWait:
        {
            self.gameState = GameStateBadGuysSleep;
            break;
        }
            
        case GameStateBadGuysSleep:
        {
            self.gameState = GameStateBadGuysSleepWait;
            break;
        }
            
        case GameStateBadGuysSleepWait:
        {
            self.gameState = GameStateMerlinBadGuysThumbsUp;
            break;
        }
            
        case GameStateMerlinBadGuysThumbsUp:
        {
            self.gameState = GameStateMerlinBadGuysThumbsUpWait;
            break;
        }
            
        case GameStateMerlinBadGuysThumbsUpWait:
        {
            self.gameState = GameStateMerlinAwake;
            break;
        }
            
        case GameStateMerlinAwake:
        {
            self.gameState = GameStateMerlinWait;
            break;
        }
            
        case GameStateMerlinWait:
        {
            self.gameState = GameStateMerlinSleep;
            break;
        }
            
        case GameStateMerlinSleep:
        {
            self.gameState = GameStateMerlinSleepWait;
            break;
        }
            
        case GameStateMerlinSleepWait:
        {
            if ([self isCharacterSelected:self.btnPercival])
            {
                self.gameState = GameStatePercivalMerlinMorganaThumbsUp;
            }
            else
            {
                self.gameState = GameStateAwaken;
            }
            
            break;
        }
            
        case GameStatePercivalMerlinMorganaThumbsUp:
        {
            self.gameState = GameStatePercivalMerlinMorganaThumbsUpWait;
            break;
        }
            
        case GameStatePercivalMerlinMorganaThumbsUpWait:
        {
            self.gameState = GameStatePercivalAwake;
            break;
        }
            
        case GameStatePercivalAwake:
        {
            self.gameState = GameStatePercivalWait;
            break;
        }
            
        case GameStatePercivalWait:
        {
            self.gameState = GameStatePercivalSleep;
            break;
        }
            
        case GameStatePercivalSleep:
        {
            self.gameState = GameStatePercivalSleepWait;
            break;
        }
            
        case GameStatePercivalSleepWait:
        {
            self.gameState = GameStateAwaken;
            break;
        }
            
        case GameStateAwaken:
        {
            self.gameState = GameStateComplete;
            break;
        }
            
        case GameStateComplete:
        {
            break;
        }
    }
    
    [self performGameStateAction];
}

-(void)performGameStateAction
{
    switch (self.gameState)
    {
        case GameStateStart:
            break;
            
        case GameStateGoToSleep:
        {
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"Everyone, please close your eyes and put your fists in front of you."];
            [self.synth speakUtterance:utterance];
            
            break;
        }
            
        case GameStateGoToSleepWait:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, BetweenPhasesDelay), dispatch_get_main_queue(), ^{
                [self advanceGameState];
            });
            break;
        }
            
        case GameStateBadGuysAwake:
        {
            NSMutableString *characters = [[NSMutableString alloc] initWithString:@"Villains"];
            if ([self isCharacterSelected:self.btnOberon])
            {
                [characters appendString:@", except Oberon"];
            }
            
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:[NSString stringWithFormat:@"%@, please wake up and identify each other.", characters]];
            [self.synth speakUtterance:utterance];
            
            break;
        }
            
        case GameStateBadGuysWait:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, IdentifyPhaseDelay), dispatch_get_main_queue(), ^{
                [self advanceGameState];
            });
            break;
        }
            
        case GameStateBadGuysSleep:
        {
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"Please go to sleep"];
            [self.synth speakUtterance:utterance];
            
            break;
        }
            
        case GameStateBadGuysSleepWait:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, BetweenPhasesDelay), dispatch_get_main_queue(), ^{
                [self advanceGameState];
            });
            break;
        }
            
        case GameStateMerlinBadGuysThumbsUp:
        {
            NSMutableArray *wakeUp = [[NSMutableArray alloc] init];
            if ([self isCharacterSelected:self.btnMorgana])
            {
                [wakeUp addObject:@"Morgana"];
            }
            
            if ([self isCharacterSelected:self.btnAssassin])
            {
                [wakeUp addObject:@"Assassin"];
            }
            
            if ([self isCharacterSelected:self.btnMinions])
            {
                [wakeUp addObject:@"Minions of Mordred"];
            }
            
            if ([self isCharacterSelected:self.btnOberon])
            {
                [wakeUp addObject:@"Oberon"];
            }
            
            NSMutableString *characters = [[NSMutableString alloc] init];
            for (NSInteger i = 0; i < [wakeUp count]; ++i)
            {
                if (i == 0)
                {
                    // Do nothing
                }
                if (i == [wakeUp count] - 1)
                {
                    [characters appendString:@", and "];
                }
                else if (i > 0)
                {
                    [characters appendString:@", "];
                }
                
                [characters appendString:[wakeUp objectAtIndex:i]];
            }
            
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:[NSString stringWithFormat:@"%@, please put your thumbs up.", characters]];
            [self.synth speakUtterance:utterance];
            
            break;
        }
            
        case GameStateMerlinBadGuysThumbsUpWait:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, ThumbsPhaseDelay), dispatch_get_main_queue(), ^{
                [self advanceGameState];
            });
            break;
        }
            
        case GameStateMerlinAwake:
        {
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:[NSString stringWithFormat:@"Merlin, please wake up and identify the villains."]];
            [self.synth speakUtterance:utterance];

            break;
        }
            
        case GameStateMerlinWait:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, IdentifyPhaseDelay), dispatch_get_main_queue(), ^{
                [self advanceGameState];
            });
            break;
        }
            
        case GameStateMerlinSleep:
        {
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"Merlin, please go to sleep. Everyone, put your thumbs down."];
            [self.synth speakUtterance:utterance];
            
            break;
        }
            
        case GameStateMerlinSleepWait:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, BetweenPhasesDelay), dispatch_get_main_queue(), ^{
                [self advanceGameState];
            });
            break;
        }
            
        case GameStatePercivalMerlinMorganaThumbsUp:
        {
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"Merlin, and Morgana, please put your thumbs up."];
            [self.synth speakUtterance:utterance];
            
            break;
        }
            
        case GameStatePercivalMerlinMorganaThumbsUpWait:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, ThumbsPhaseDelay), dispatch_get_main_queue(), ^{
                [self advanceGameState];
            });
            break;
        }
            
        case GameStatePercivalAwake:
        {
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"Percival, please wake up."];
            [self.synth speakUtterance:utterance];
            
            break;
        }
            
        case GameStatePercivalWait:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, IdentifyPhaseDelay), dispatch_get_main_queue(), ^{
                [self advanceGameState];
            });
            break;
        }
            
        case GameStatePercivalSleep:
        {
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"Percival, please go to sleep. Everyone, put your thumbs down."];
            [self.synth speakUtterance:utterance];
            
            break;
        }
            
        case GameStatePercivalSleepWait:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, BetweenPhasesDelay), dispatch_get_main_queue(), ^{
                [self advanceGameState];
            });
            break;
        }
            
        case GameStateAwaken:
        {
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"Everyone, please wake up."];
            [self.synth speakUtterance:utterance];
            
            break;
        }
            
        case GameStateComplete:
        {
            break;
        }
    }
}

#pragma mark - AVSpeechSynthesizerDelegate

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [self advanceGameState];
}

@end
