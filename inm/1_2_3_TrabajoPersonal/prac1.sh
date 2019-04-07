#!/bin/bash

clear

PORTER_DIR="../2_3TextClassification/Normalization/PorterStemmer"
NGRAMS_DIR="../2_3TextClassification/NGrams"
SVM_DIR="../2_3TextClassification/SVMRepresentation"
ML_DIR="../2_3TextClassification/MachineLearning"
BIN_DIR="../../bin/svm_light"



echo === Extracting top three categories ===
./SelectDocsByCategory.sh news 3cat alt.atheism comp.graphics comp.os.ms-windows.misc



echo
echo === Applying NP ===
python ${PORTER_DIR}/../NormPython/quitaSim.py < news.3cat.txt > news.3cat.qsim.txt
python ${PORTER_DIR}/../NormPython/quita1car.py < news.3cat.qsim.txt > news.3cat.qsim.q1car.txt



echo
echo === Applying Porter ===
${PORTER_DIR}/PorterStemmer news.3cat.qsim.q1car.txt > news.3cat.qsim.q1car.porter.txt



echo
echo === Generating 1-Grams ===
${NGRAMS_DIR}/NGrams news.3cat.qsim.q1car.porter.txt 1 news.3cat.qsim.q1car.porter.1Gram

echo
echo === Generating 2-Grams ===
${NGRAMS_DIR}/NGrams news.3cat.qsim.q1car.porter.txt 2 news.3cat.qsim.q1car.porter.2Gram



echo
echo === Generating 1-Gram binary SVM representation ===
${SVM_DIR}/SVMRep news.3cat.qsim.q1car.porter.txt 1 news.3cat.qsim.q1car.porter.1Gram news.3cat.qsim.q1car.porter.1Gram.b.svm bin

echo
echo === Generating 2-Gram binary SVM representation ===
${SVM_DIR}/SVMRep news.3cat.qsim.q1car.porter.txt 2 news.3cat.qsim.q1car.porter.2Gram news.3cat.qsim.q1car.porter.2Gram.b.svm bin

echo
echo === Generating 1-Gram count SVM representation ===
${SVM_DIR}/SVMRep news.3cat.qsim.q1car.porter.txt 1 news.3cat.qsim.q1car.porter.1Gram news.3cat.qsim.q1car.porter.1Gram.c.svm count

echo
echo === Generating 2-Gram count SVM representation ===
${SVM_DIR}/SVMRep news.3cat.qsim.q1car.porter.txt 2 news.3cat.qsim.q1car.porter.2Gram news.3cat.qsim.q1car.porter.2Gram.c.svm count

echo
echo === Generating 1-Gram proportional SVM representation ===
${SVM_DIR}/SVMRep news.3cat.qsim.q1car.porter.txt 1 news.3cat.qsim.q1car.porter.1Gram news.3cat.qsim.q1car.porter.1Gram.p.svm prop

echo
echo === Generating 2-Gram proportional SVM representation ===
${SVM_DIR}/SVMRep news.3cat.qsim.q1car.porter.txt 2 news.3cat.qsim.q1car.porter.2Gram news.3cat.qsim.q1car.porter.2Gram.p.svm prop



echo
echo === Generating binary 1-Gram training labels for first category ===
${ML_DIR}/OneLabelSVM news.3cat.txt news.3cat.qsim.q1car.porter.1Gram.b.svm alt.atheism news.3cat.qsim.q1car.porter.1Gram.b.1c.train

echo
echo === Generating binary 2-Gram training labels for first category ===
${ML_DIR}/OneLabelSVM news.3cat.txt news.3cat.qsim.q1car.porter.2Gram.b.svm alt.atheism news.3cat.qsim.q1car.porter.2Gram.b.1c.train

echo
echo === Generating binary 1-Gram training labels for second category ===
${ML_DIR}/OneLabelSVM news.3cat.txt news.3cat.qsim.q1car.porter.1Gram.b.svm comp.graphics news.3cat.qsim.q1car.porter.1Gram.b.2c.train

echo
echo === Generating binary 2-Gram training labels for second category ===
${ML_DIR}/OneLabelSVM news.3cat.txt news.3cat.qsim.q1car.porter.2Gram.b.svm comp.graphics news.3cat.qsim.q1car.porter.2Gram.b.2c.train

echo
echo === Generating binary 1-Gram training labels for third category ===
${ML_DIR}/OneLabelSVM news.3cat.txt news.3cat.qsim.q1car.porter.1Gram.b.svm comp.os.ms-windows.misc news.3cat.qsim.q1car.porter.1Gram.b.3c.train

echo
echo === Generating binary 2-Gram training labels for third category ===
${ML_DIR}/OneLabelSVM news.3cat.txt news.3cat.qsim.q1car.porter.2Gram.b.svm comp.os.ms-windows.misc news.3cat.qsim.q1car.porter.2Gram.b.3c.train



echo
echo === Creating linear model for binary 1-Gram labels of first category ==
${BIN_DIR}/svm_learn news.3cat.qsim.q1car.porter.1Gram.b.1c.train news.3cat.qsim.q1car.porter.1Gram.b.1c.model

echo
echo === Creating linear model for binary 2-Gram labels of first category ==
${BIN_DIR}/svm_learn news.3cat.qsim.q1car.porter.2Gram.b.1c.train news.3cat.qsim.q1car.porter.2Gram.b.1c.model

echo
echo === Creating linear model for binary 1-Gram labels of second category ==
${BIN_DIR}/svm_learn news.3cat.qsim.q1car.porter.1Gram.b.2c.train news.3cat.qsim.q1car.porter.1Gram.b.2c.model

echo
echo === Creating linear model for binary 2-Gram labels of second category ==
${BIN_DIR}/svm_learn news.3cat.qsim.q1car.porter.2Gram.b.2c.train news.3cat.qsim.q1car.porter.2Gram.b.2c.model

echo
echo === Creating linear model for binary 1-Gram labels of third category ==
${BIN_DIR}/svm_learn news.3cat.qsim.q1car.porter.1Gram.b.3c.train news.3cat.qsim.q1car.porter.1Gram.b.3c.model

echo
echo === Creating linear model for binary 2-Gram labels of third category ==
${BIN_DIR}/svm_learn news.3cat.qsim.q1car.porter.2Gram.b.3c.train news.3cat.qsim.q1car.porter.2Gram.b.3c.model



echo
echo === Classifying data for binary 1-Gram labels of first category ==
${BIN_DIR}/svm_classify news.3cat.qsim.q1car.porter.1Gram.b.1c.train news.3cat.qsim.q1car.porter.1Gram.b.1c.model news.3cat.qsim.q1car.porter.1Gram.b.1c.eval

echo
echo === Classifying data for binary 2-Gram labels of first category ==
${BIN_DIR}/svm_classify news.3cat.qsim.q1car.porter.2Gram.b.1c.train news.3cat.qsim.q1car.porter.2Gram.b.1c.model news.3cat.qsim.q1car.porter.2Gram.b.1c.eval

echo
echo === Classifying data for binary 1-Gram labels of second category ==
${BIN_DIR}/svm_classify news.3cat.qsim.q1car.porter.1Gram.b.2c.train news.3cat.qsim.q1car.porter.1Gram.b.2c.model news.3cat.qsim.q1car.porter.1Gram.b.2c.eval

echo
echo === Classifying data for binary 2-Gram labels of second category ==
${BIN_DIR}/svm_classify news.3cat.qsim.q1car.porter.2Gram.b.2c.train news.3cat.qsim.q1car.porter.2Gram.b.2c.model news.3cat.qsim.q1car.porter.2Gram.b.2c.eval

echo
echo === Classifying data for binary 1-Gram labels of third category ==
${BIN_DIR}/svm_classify news.3cat.qsim.q1car.porter.1Gram.b.3c.train news.3cat.qsim.q1car.porter.1Gram.b.3c.model news.3cat.qsim.q1car.porter.1Gram.b.3c.eval

echo
echo === Classifying data for binary 2-Gram labels of third category ==
${BIN_DIR}/svm_classify news.3cat.qsim.q1car.porter.2Gram.b.3c.train news.3cat.qsim.q1car.porter.2Gram.b.3c.model news.3cat.qsim.q1car.porter.2Gram.b.3c.eval