: This file will split the Total Carnage Program files
: into the appropriate ROM files.  It will then concantenate the files
: into 2 MBit eprom files.
:
:	P Cox	08 Nov. 1991	Initial Creation
:	P Cox	26 Nov. 1991	Deleted path spec for SREC
:
:	Split the Program file
echo "Beginning Program File Build Process..."
srec <carnprog.lrn
:
:
echo "Beginning Program File Combine Process..."
:
copy /b carnfc.0 + carnfe.0 carnu105.pp
copy /b carnfc.1 + carnfe.1 carnu89.pp
:
echo "Deleting 1 MBit program files..."
:
del carnf?.0
del carnf?.1
:
:	
