import sys

# Use standard input for reading
F = sys.stdin

c = F.read(1); # First character

while c != '': # While character exists

  # Filter criterium
  if c in ['\t', '\'', '\\', ',', '.', ';', '-', '_', ':', '*', '|', '/',
    '=', '+', '#', '$', '&', '%', '@', '^', '~', '(', ')', '<', '>', '{',
    '}', '[', ']', '`', '"', '!', '?'] or ord(c) in [0x08, 0x1b]:
    sys.stdout.write(' ')
  else:
    sys.stdout.write(c)
  
  c = F.read(1) # Next character

F.close();