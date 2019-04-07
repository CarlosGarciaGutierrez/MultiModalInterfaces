#!/bin/bash

clear

NORM_DIR="./Normalization"
PORTER_DIR="../2_3TextClassification/Normalization/PorterStemmer"
NGRAMS_DIR="../2_3TextClassification/NGrams"
SVM_DIR="../2_3TextClassification/SVMRepresentation"
ML_DIR="../2_3TextClassification/MachineLearning"
BIN_DIR="../../bin/svm_light"



echo === Extracting top three categories ===
./SelectDocsByCategory.sh news 3cat alt.atheism comp.graphics comp.os.ms-windows.misc



echo
echo === Applying NP ===
python ${NORM_DIR}/replaceEmails.py < news.3cat.txt > news.3cat.mail.txt
python ${NORM_DIR}/removeSymbols.py < news.3cat.mail.txt > news.3cat.mail.sym.txt
python ${NORM_DIR}/replaceNumbers.py < news.3cat.mail.sym.txt > news.3cat.mail.sym.num.txt
python ${NORM_DIR}/removeOneChars.py < news.3cat.mail.sym.num.txt > news.3cat.mail.sym.num.1char.txt
python ${NORM_DIR}/toLowerCase.py < news.3cat.mail.sym.num.1char.txt > news.3cat.np.txt



echo
echo === Generating 1-Grams ===
${NGRAMS_DIR}/NGrams news.3cat.np.txt 1 news.3cat.np.1Gram

echo
echo === Generating 2-Grams ===
${NGRAMS_DIR}/NGrams news.3cat.np.txt 2 news.3cat.np.2Gram