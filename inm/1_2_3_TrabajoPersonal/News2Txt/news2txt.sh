echo -n > news.cat
echo -n > news.txt
for f in `find 20_newsgroups -type f`
do
   ./news2txt $f news.cat news.txt
done
