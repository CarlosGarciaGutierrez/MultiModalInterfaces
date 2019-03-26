rm -f reuters.cat reuters.txt reuters.tags
cat OriginalData/reut2-* > TrainReuters.sgm
./XML2MLText TrainReuters.sgm reuters.cat reuters.txt reuters.tags
rm -f TrainReuters.sgm

