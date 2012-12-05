DECLARE SUB demo ()
DECLARE SUB savehighscores ()
DECLARE SUB addscore (newname$, newscore!)
DECLARE SUB createfile ()
DECLARE SUB displayscores ()
DECLARE SUB loadhighscores ()
DECLARE SUB verifyfile ()

DIM SHARED name$(51)
DIM SHARED score(51)
COMMON SHARED errorflag, filename$, numscores

ON ERROR GOTO errorhandle

RANDOMIZE TIMER
CLS

' set the high score file name
filename$ = "high.scr"
' set the number of high scores in the list
numscores = 15


'make sure that there is a file with the name that is in "filename$"
verifyfile



' Load the high scores into the name$() and socre() arrays
loadhighscores



' This is the subroutine to use to add a new name


addscore "Your Name", 50


' Display the scores on the screen
displayscores


LOCATE 17, 10
PRINT "Press <space> to add a random score"
LOCATE 18, 10
PRINT "Press <n> to reset the scores and add one random score"
LOCATE 19, 10
PRINT "Press <Esc> to exit"


DO
a$ = INKEY$
IF a$ = " " THEN demo
IF a$ = "n" THEN
 createfile
 loadhighscores
 demo
END IF
LOOP UNTIL a$ = CHR$(27)


END


' NOTE: It is critical that you have the ON ERROR code included in this
' program, since it detects the non-existence of the high score file


errorhandle:

' Set the errorflag variable to signal that there was an error
' then let the program continue if the errors are able to be handled

errorflag = ERR

IF errorflag = 53 THEN RESUME NEXT   ' File Not Found
IF errorflag = 62 THEN RESUME NEXT   ' Input Past End Of File


PRINT "There is an error: code "; errorflag

END

SUB addscore (newname$, newscore)

' since the scores are already in order, adding a new score
' to the list is simple.  The following code checks for the
' highest place that the new score can go, moves the other
' scores down and puts the new socre in it's new place.
' score(1) is the highest, and score(numscores) is the lowest


' Check for a position to fill
' "found" is the place where the new score will go

found = 0
FOR t = numscores TO 1 STEP -1
 IF newscore > score(t) THEN found = t
NEXT t





IF found = 0 THEN

 ' The new score is not high enough to get onto the list
 ' Nothing happens

ELSE

 ' The score is high enough to get onto the list
 ' Shift the scores down

 FOR t = numscores TO (found + 1) STEP -1
  name$(t) = name$(t - 1)
  score(t) = score(t - 1)
 NEXT t

 ' Put the new name and score into place
 name$(found) = newname$
 score(found) = newscore


 ' If the score qualified to be on the list, it is now in the
 ' score() array, and the name is in its respective location
 ' Now the score has to be saved into the file

 savehighscores

END IF


END SUB

SUB createfile

' This subroutine creates a default high score file
zero = 0

OPEN filename$ FOR OUTPUT AS #2

 FOR t = 1 TO numscores
  PRINT #2, "Nobody"
  PRINT #2, zero
 NEXT t

CLOSE #2

END SUB

SUB demo

' demo: temp$ is a random character
'       scr is a random score
INPUT "Name"; temp$

scr = INT(RND * 100)

addscore temp$, scr

CLS
displayscores

LOCATE 17, 10
PRINT "Press <space> to add a random score"
LOCATE 18, 10
PRINT "Press <n> to reset the scores and add one random score"
LOCATE 19, 10
PRINT "Press <Esc> to exit"


END SUB

SUB displayscores

FOR t = 1 TO numscores

 ' draw a line for the name and score
 LOCATE t, 10
 PRINT "..............................."

 ' print the name and score
 LOCATE t, 10
 PRINT name$(t)
 LOCATE t, 40
 PRINT score(t)

NEXT t

END SUB

SUB loadhighscores

' Now that there is for sure a high score file, open it and retrieve
' all "numscores" of the names and scores in it

OPEN filename$ FOR INPUT AS #1
 FOR t = 1 TO numscores
  INPUT #1, name$(t)
  INPUT #1, score(t)
 NEXT t
CLOSE #1

END SUB

SUB savehighscores

' Open the high score file and save the new scoreboard to it

OPEN filename$ FOR OUTPUT AS #1
 FOR t = 1 TO numscores
  PRINT #1, name$(t)
  PRINT #1, score(t)
 NEXT t
CLOSE #1

END SUB

SUB verifyfile

' Try to open the high score file to see if it exists
' If it does not exist, it will cause an error.  The
' error handling code sets a flag to signal the error

OPEN "high.scr" FOR INPUT AS #1

' If there is no high score file, errorflag will equal 1
' so create the high score file and fill it with default
' information.  Then reset the errorflag

IF errorflag = 53 THEN createfile
errorflag = 0

CLOSE

END SUB

