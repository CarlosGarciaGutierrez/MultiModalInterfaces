if test $3.a = .a
then
  echo "SelectDocsByCategory.sh repository ext cat1 ... catn"
  echo " repository: basename for .cat and .txt files"
  echo " ext: extension of the new repository files created"
  echo " cat1 ... catn: set of categories to select" 
  echo "There must exist reposiroty.cat repository.txt"
  echo "Create repository.ext.cat repository.ext.txt with the documents tagged"
  echo " with, at least one, of the cat1,...,catn categories"
  exit
fi

# Input and output files

CAT=$1.cat
TXT=$1.txt
OCAT=$1.$2.cat
OTXT=$1.$2.txt
TMP=$1.$2.tmp

shift
shift

# Creating regular expresion for grep

E=""
First="Y"
while test $1.a != .a
do
 if test $First = "Y"
 then
   E=$1
   First="N"
 else
   E=$E"|"$1
 fi
 shift
done

# Select the lines with the categories from CAT
grep -nE $E $CAT > $TMP

# Creating the CAT file as the second ':' field
cut -d: -f 2 < $TMP > $OCAT

# Selecting from TXT the lines numbered in the first colum of $TMP 
./News2Txt/FilterLines $TXT $TMP > $OTXT


rm $TMP