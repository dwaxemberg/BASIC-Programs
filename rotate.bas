nop=120 'number of pixels  
ox=159
oy=99
an=(22/7)/180
dim sprite(nop,3)
for t=1 to nop
randomize timer
sprite (t,1)=int(rnd*16)'radius
sprite (t,2)=int(rnd*359)'degrees 
sprite (t,3)=int(rnd*100)'color
next

screen 13

gosub drawit

routinne:
a$=inkey$
if a$=chr$(0)+chr$(72) gosub turnleft
if a$=chr$(0)+chr$(77) gosub turnright
'not sure about scancodes
if a$=chr$(27) then end
goto routinne

turnleft:
for t=1 to nop
sprite (t,2)=sprite(t,2)+5
if sprite (t,2)>360 then sprite(t,2)=sprite(t,2)-360
next
gosub drawit
return

turnright:
for t=1 to nop
sprite (t,2)=sprite(t,2)-5
if sprite (t,2)<0 then sprite(t,2)=sprite(t,2)+360
next
gosub drawit
return

drawit:
cls
for t=1 to nop
pset (ox+(sprite(t,1)*cos(sprite(t,2)*an),oy-(sprite(t,1)*sin(sprite(t,2)*an)),sprite(t,3)
next
return