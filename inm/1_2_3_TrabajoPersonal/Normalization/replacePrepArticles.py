import sys

prepList=['aboard','about','above','across','after','against','along','amid','among','anti','around','as','at','before','behind','below','beneath','beside','besides','between','beyond','but','by','concerning','considering','despite','down','during','except','excepting','excluding','following','for','from','in','inside','into','like','minus','near','of','off','on','onto','opposite','outside','over','past','per','plus','regarding','round','save','since','than','through','to','toward','towards','under','underneath','unlike','until','up','upon','versus','via','with','within','without'];

articleList=['a','an','the'];

def isPrep(w):
    for i in range(len(prepList)):
        if w==prepList[i]:
            return True;
    return False;

def isArticle(w):
    for i in range(len(articleList)):
        if w==articleList[i]:
            return True;
    return False;

# Use standard input for reading
F = sys.stdin

L = F.readline(); # First line

while L != '': # While line exists
  
  # Use L
  L = L.split('\n')[0] # Remove the last \n (if exists)
  Toks = L.split(' '); # Tokens are words separated by ' '
  N = ''               # New line

  for T in Toks:

    if isPrep(T): # Checks if it is a prep
      T = "#P"
    else:
      if isArticle(T):  # Checks if it is an article
        T = "#A"
    
    if len(N) == 0:
      N = T
    else:
      N = N + ' ' + T

  print N # Add \n at the end of the string
  
  L = F.readline(); # Next line

F.close(); 