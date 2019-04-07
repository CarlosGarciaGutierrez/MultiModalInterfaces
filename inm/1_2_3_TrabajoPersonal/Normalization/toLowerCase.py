import sys

# Use standard input for reading
F = sys.stdin

c = F.read(1); # First character

while c != '': # While character exists

  # Filter criterium
  if c.isupper():
    sys.stdout.write(c.lower())
  else:
    sys.stdout.write(c)
  
  c = F.read(1) # Next character

F.close();