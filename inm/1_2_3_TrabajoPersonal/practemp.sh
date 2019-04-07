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
python ${NORM_DIR}/quitaSim.py < news.3cat.txt > news.3cat.qsim.txt
python ${NORM_DIR}/quita1car.py < news.3cat.qsim.txt > news.3cat.qsim.q1car.txt



echo
echo === Generating 1-Grams ===
${NGRAMS_DIR}/NGrams news.3cat.qsim.q1car.txt 1 news.3cat.qsim.q1car.1Gram

echo
echo === Generating 2-Grams ===
${NGRAMS_DIR}/NGrams news.3cat.qsim.q1car.txt 2 news.3cat.qsim.q1car.2Gram
