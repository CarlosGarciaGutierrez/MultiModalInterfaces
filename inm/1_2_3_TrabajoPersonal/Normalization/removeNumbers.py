import sys

# Use standard input for reading
F = sys.stdin

L = F.readline(); # First line

while L != '': # While line exists
  
  # Use L
  L = L.split('\n')[0] # Remove the last \n (if exists)
  Toks = L.split(' '); # Tokens are words separated by ' '
  N = ''               # New line

  for T in Toks:

    if not T.isdigit(): # Checks if it is a number
      if len(N) == 0:
        N = T
      else:
        N = N + ' ' + T

  print N # Add \n at the end of the string
  
  L = F.readline(); # Next line

F.close(); 