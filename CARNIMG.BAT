: This file will split the Total Carnage Image files
: into the appropriate ROM files.  It will then concantenate the files
: into 2 MBit eprom files.
:
:	P Cox	08 Nov. 1991	Initial Creation
:	P Cox	26 Nov. 1991	Deleted path spec for SREC
:
:	Split the Image file
echo "Beginning Image File Build Process..."
srec <carnimg.lrn
:
: Delete the unused *.03 Image Files
echo "Deleting unused split image files (*.03)..."
del *.03
:
echo "Beginning Image File Combine Process..."
:
copy /b carn20.00 + carn24.00 carnu111.pp
copy /b carn20.01 + carn24.01 carnu95.pp
copy /b carn20.02 + carn24.02 carnu106.pp
copy /b carn28.00 + carn2c.00 carnu112.pp
copy /b carn28.01 + carn2c.01 carnu96.pp
copy /b carn28.02 + carn2c.02 carnu107.pp
copy /b carn30.00 + carn34.00 carnu113.pp
copy /b carn30.01 + carn34.01 carnu97.pp
copy /b carn30.02 + carn34.02 carnu108.pp
copy /b carn38.00 + carn3c.00 carnu114.pp
copy /b carn38.01 + carn3c.01 carnu98.pp
copy /b carn38.02 + carn3c.02 carnu109.pp
:
echo "Deleting split 1 MBit image files (*.00, *.01, *.02)..."
del *.0?
:
:
:	
