#Introduction

Development for mobile devices becomes a trand now. 
We can consider developing in native languages (i.e. ObjectiveC for IOS or Java for Android),
but usually for for new developers learning curve is high.
Another option would be using 3rd party proxies (like Titanium, PhoneGap) and develop in preferred 
language of your choice while targeting new mobile platform.

In this article I would like to demonstrate similar approach for developers known with object pascal and Delphi.
As you might remember. Borland Delphi was quite popular at the beginning of the century, and still has a large community.

Althouth Inprise(Borland) company is not developing it's product any more, the another company, Embarcadero was able
to bring Delphi on a new level with it's new Delphi XE2 product. This is language and IDE that have born from original Delphi,
thus learning curve is much lower.

What perfect thing could be found in XE2 - is ability to develop applications for IOS (and in future for Android) with it's FireMonkey
framework. 

In this article I would demonstrate as a proof of concept process of development simplified Go game on a 3x3 field for IOS.


#Background

What is needed to try the demo?

a) trial version of the Embarcadero Delphi XE2

(I have spent at least 42% of the total time spent to fill all forms and get the tool)

b) Mac ñ Lion 10.2+ with free XCode from AppStore

c) Borrowed IPhone with Jailbreak for checking the solution on a live device (or a Developer certificate for signing)

d) Simple task to program - in this case simplified go game on 3x3 square.


Impressions:

Development environment is almost the same as on Delphi 7.0, thus any developer known of Delphi would feel very comfortable with XE2.  XE2 is the dialect of object pascal with modern features like namespaces, etc. 
I would not be very surprised, if they have implemented there also closures and generic types.

Developer license cost is high - starting from USD2.5-3k for RAD studio.

Important features: ability to write in Delphi cross platform applications for Windows 32, Mac and IOS. In order to support Mac embarcadero purchased solution from one of xUSSR software companies. Basically, they have 
implemented alternate to VCL controls & components tree, and developer will use them in application development process.

In order to develop an application for IOS platform - you have to select special project type "Firemonkey HD IOS Application".
We see a typical Delphi project have been created: one form looking like IPhone surface.


<table>
  <tr>
    <td><img src="https://raw.github.com/Voronenko/GO-IOS-DELPHI/master/_readme/1_newproject.jpg" alt="New Project"/></td>
    <td><img src="https://raw.github.com/Voronenko/GO-IOS-DELPHI/master/_readme/2_formview.jpg" alt="Form view"/></td>
    <td><img src="https://raw.github.com/Voronenko/GO-IOS-DELPHI/master/_readme/3_formwithbuttons.jpg" alt="Form with controls"/></td>   
  </tr>
</table>




#Using the code

Time to code the game. Typical approach for such game expects using the MiniMax strategy http://en.wikipedia.org/wiki/Minimax
I am copiing the summary of the definition here:

Minimax (sometimes minmax) is a decision rule used in decision theory, game theory, statistics and philosophy for minimizing the possible loss for a worst case (maximum loss) scenario. Alternatively, it can be thought 
of as maximizing the minimum gain (maximin).

The minimax theorem states
For every two-person, zero-sum game with finitely many strategies, there exists a value V and a mixed strategy for each player, such that
(a) Given player 2's strategy, the best payoff possible for player 1 is V, and
(b) Given player 1's strategy, the best payoff possible for player 2 is -V.
Equivalently, Player 1's strategy guarantees him a payoff of V regardless of Player 2's strategy, and similarly Player 2 can guarantee himself a payoff of -V. The name minimax arises because each player minimizes the maximum
 payoff possible for the other—since the game is zero-sum, he also minimizes his own maximum loss (i.e. maximize his minimum payoff).
 
 Let's implement in Delphi (code is present on github, and also can be downloaded from this page)
 

## Game class

Class is quite simple

  TGameXOImpl = class
    private
      MovePatterns: array[0..4] of TXOPoint;  //First steps
       //matched to external X/O/' '  layout button texts
      GamePane: array[0..2,0..2] of char;
      Moves: array[0..2,0..2] of byte;

      SignComputer: char;
      SignPlayer: char;
    protected
      procedure ResetGamePane();
      function AnalyzeTurn (Computer: Boolean; Step: Integer): Integer;  //MiniMax analysis
    public
      constructor Create();
      function ComputerTurn():TXOPoint;
      function CheckGameIsCompleted(Mark: Char):integer;
      procedure StartGame(PlayerSign: char);
      function PlayTurn(Turn:TXOPoint):integer;

      property ComputerSign : char read SignComputer ;
      property PlayerSign : char read SignPlayer;

  end;
 
 
 
## First turn

  We have to define first steps that might allow us to win or at least not to lose.

  MovePatterns[0] := TXOPoint.Create(0,0);
  MovePatterns[1] := TXOPoint.Create(0,2);
  MovePatterns[2] := TXOPoint.Create(1,1);
  MovePatterns[3] := TXOPoint.Create(2,2);

 
## Minimax strategy

Function below analyzes game situation for the next turn, and for each possible empty cell
provides a grade: -1 - game will be continued,  0- nobody will won, game ower.  1 - next step will won.
Results of this function is used by AI to consider next turn.


(**
*   @Mark char X|O check win criteria for passed mark
*
*   return  -1 game in progress,  0 - nobody won, 1 - passed mark has won
*)
function TGameXOImpl.AnalyzeTurn(Computer: Boolean; Step: Integer): Integer;
var i, j, checkturn, weight, max: Integer;
begin
  max := -1;
  for i := 0 to 2 do
    for j := 0 to 2 do
    begin
      weight := -2;
      if GamePane[i,j] = ' ' then
      begin
        if Computer then begin
          GamePane[i,j] := self.SignComputer;
        end else begin
         GamePane[i,j] := self.SignPlayer;
        end;

        if Computer then checkturn := CheckGameIsCompleted(self.SignComputer)
                    else checkturn := CheckGameIsCompleted (self.SignPlayer);
        if (checkturn < 0) then begin
          weight := - AnalyzeTurn(not Computer, Step + 1);
        end else begin
          weight := checkturn;
        end;
        if (weight > Max) then begin
          max := weight;
        end;
        GamePane[i,j] := ' ';

        if ((max = 1) and (step > 0)) then
        begin
          Result := Max;
          break;
        end;
      end;
      if (Step = 0) then Moves[i,j] := weight;
    end;
  Result := Max;
end;

## Game in action
 Let's test game in action:
 


#Exporting to Mac

So we were able to see our game in action, but on windows.
In order to port project to Mac's XCode there is a special utility that needs to be configured in a following manner: 

As a result of execution new folder titled 'XCode' can be found in the project. It contains XCode project file that you can open under Mac.

Also conversion utility appears to be coded poor:


I have spent more than 20 minutes with SysInternals Filemon to detect what the issue was.



#Compiling for IOS and deploying to device

First try and first issue:  I have failed to compile project under Mac, as XCode implementation of TPoint does not contain constructor taking two arguments x,y. What's a pity! 
I had to implement my own TXOPoint instead. The product costing $3K could warn me on such problems during porting, couldn't it?
Good moment: I had no issues to run project in emulator after TXOPoint implementation.


In order to deploy application to live device you need a developer certificate (cost is > $100 / year).

In case if you have jailbreaked iphone in your desposition, you can create installation in ipa form using typical 7Zip archiever. You just need to get ipa from another workable program, and 
change the project folder in Payload directory. (Don't forget to set the minimal required IOS version in XCode project options - it will save you a time if you phone 
is not IOS5)


After several simple steps we have application on the IPhone:
 



#Points of Interest

Advantages:

fact, that I was able to get working IOS application on the phone without need to study one more programming language Objective C - is a good point. Taking into consideraton that there are applications
different from angry birds, I belive market for Firemonkey based solutions is present.

Disadvantages:

I think technology is not stable yet. You can download XE Patch 3 on a trial, while site tells that Patch4 is already present. According to release notes, patch4 refers to IOS development issues. 
I hope trial will be updated to test Patch4 improvements.

Source code of this lab is available on GitHub:

https://github.com/Voronenko/GO-IOS-DELPHI

#History

