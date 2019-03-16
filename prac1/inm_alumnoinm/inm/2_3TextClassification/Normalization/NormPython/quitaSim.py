import sys

# Use standard input for reading
F=sys.stdin

c=F.read(1); # First character
while c != '': # While character exists
  if c!='.' and c!=',' and c!='-':     # Filter criterium
    sys.stdout.write(c)
  
  c=F.read(1) # Next character

F.close(); 
