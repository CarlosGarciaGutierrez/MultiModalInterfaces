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
echo === Applying Porter ===
${PORTER_DIR}/PorterStemmer news.3cat.txt > ${NORM_DIR}/news.3cat.porter.txt
echo Porter applied

echo
echo === Applying NP ===
python ${NORM_DIR}/replaceEmails.py < news.3cat.txt > ${NORM_DIR}/news.3cat.mail.txt
echo Replace emails applied
python ${NORM_DIR}/removeSymbols.py < ${NORM_DIR}/news.3cat.mail.txt > ${NORM_DIR}/news.3cat.mail.sym.txt
echo Remove symbols applied
python ${NORM_DIR}/removeNumbers.py < ${NORM_DIR}/news.3cat.mail.sym.txt > ${NORM_DIR}/news.3cat.mail.sym.num.txt
echo Remove numbers applied
python ${NORM_DIR}/removeOneChars.py < ${NORM_DIR}/news.3cat.mail.sym.num.txt > ${NORM_DIR}/news.3cat.mail.sym.num.1char.txt
echo Remove one-char words applied
python ${NORM_DIR}/toLowerCase.py < ${NORM_DIR}/news.3cat.mail.sym.num.1char.txt > ${NORM_DIR}/news.3cat.np.txt
echo To lower case applied

echo
echo === Applying Porter + NP ===
python ${NORM_DIR}/replaceEmails.py < news.3cat.txt > ${NORM_DIR}/news.3cat.mail.txt
echo Replace emails applied
python ${NORM_DIR}/removeSymbols.py < ${NORM_DIR}/news.3cat.mail.txt > ${NORM_DIR}/news.3cat.mail.sym.txt
echo Remove symbols applied
python ${NORM_DIR}/removeNumbers.py < ${NORM_DIR}/news.3cat.mail.sym.txt > ${NORM_DIR}/news.3cat.mail.sym.num.txt
echo Remove numbers applied
${PORTER_DIR}/PorterStemmer ${NORM_DIR}/news.3cat.mail.sym.num.txt > ${NORM_DIR}/news.3cat.mail.sym.num.porter.txt
echo Porter applied
python ${NORM_DIR}/removeOneChars.py < ${NORM_DIR}/news.3cat.mail.sym.num.porter.txt > ${NORM_DIR}/news.3cat.mail.sym.num.porter.1char.txt
echo Remove one-char words applied
python ${NORM_DIR}/toLowerCase.py < ${NORM_DIR}/news.3cat.mail.sym.num.porter.1char.txt > ${NORM_DIR}/news.3cat.porter.np.txt
echo To lower case applied



echo
echo === Generating 1-Grams ===
${NGRAMS_DIR}/NGrams ${NORM_DIR}/news.3cat.porter.txt 1 ${NGRAMS_DIR}/news.3cat.porter.1Gram
echo
${NGRAMS_DIR}/NGrams ${NORM_DIR}/news.3cat.np.txt 1 ${NGRAMS_DIR}/news.3cat.np.1Gram
echo
${NGRAMS_DIR}/NGrams ${NORM_DIR}/news.3cat.porter.np.txt 1 ${NGRAMS_DIR}/news.3cat.porter.np.1Gram

echo
echo === Generating 2-Grams ===
${NGRAMS_DIR}/NGrams ${NORM_DIR}/news.3cat.porter.txt 2 ${NGRAMS_DIR}/news.3cat.porter.2Gram
echo
${NGRAMS_DIR}/NGrams ${NORM_DIR}/news.3cat.np.txt 2 ${NGRAMS_DIR}/news.3cat.np.2Gram
echo
${NGRAMS_DIR}/NGrams ${NORM_DIR}/news.3cat.porter.np.txt 2 ${NGRAMS_DIR}/news.3cat.porter.np.2Gram



echo
echo === Generating 1-Gram binary SVM representation ===
${SVM_DIR}/SVMRep ${NORM_DIR}/news.3cat.porter.txt 1 ${NGRAMS_DIR}/news.3cat.porter.1Gram ${SVM_DIR}/news.3cat.porter.1Gram.b.svm bin
echo
${SVM_DIR}/SVMRep ${NORM_DIR}/news.3cat.np.txt 1 ${NGRAMS_DIR}/news.3cat.np.1Gram ${SVM_DIR}/news.3cat.np.1Gram.b.svm bin
echo
${SVM_DIR}/SVMRep ${NORM_DIR}/news.3cat.porter.np.txt 1 ${NGRAMS_DIR}/news.3cat.porter.np.1Gram ${SVM_DIR}/news.3cat.porter.np.1Gram.b.svm bin

echo
echo === Generating 2-Gram binary SVM representation ===
${SVM_DIR}/SVMRep ${NORM_DIR}/news.3cat.porter.txt 2 ${NGRAMS_DIR}/news.3cat.porter.2Gram ${SVM_DIR}/news.3cat.porter.2Gram.b.svm bin
echo
${SVM_DIR}/SVMRep ${NORM_DIR}/news.3cat.np.txt 2 ${NGRAMS_DIR}/news.3cat.np.2Gram ${SVM_DIR}/news.3cat.np.2Gram.b.svm bin
echo
${SVM_DIR}/SVMRep ${NORM_DIR}/news.3cat.porter.np.txt 2 ${NGRAMS_DIR}/news.3cat.porter.np.2Gram ${SVM_DIR}/news.3cat.porter.np.2Gram.b.svm bin



echo
echo === Generating binary 1-Gram training labels for first category ===
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.porter.1Gram.b.svm alt.atheism ${ML_DIR}/news.3cat.porter.1Gram.b.1c.train
echo
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.np.1Gram.b.svm alt.atheism ${ML_DIR}/news.3cat.np.1Gram.b.1c.train
echo
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.porter.np.1Gram.b.svm alt.atheism ${ML_DIR}/news.3cat.porter.np.1Gram.b.1c.train

echo
echo === Generating binary 2-Gram training labels for first category ===
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.porter.2Gram.b.svm alt.atheism ${ML_DIR}/news.3cat.porter.2Gram.b.1c.train
echo
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.np.2Gram.b.svm alt.atheism ${ML_DIR}/news.3cat.np.2Gram.b.1c.train
echo
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.porter.np.2Gram.b.svm alt.atheism ${ML_DIR}/news.3cat.porter.np.2Gram.b.1c.train

echo
echo === Generating binary 1-Gram training labels for second category ===
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.porter.1Gram.b.svm comp.graphics ${ML_DIR}/news.3cat.porter.1Gram.b.2c.train
echo
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.np.1Gram.b.svm comp.graphics ${ML_DIR}/news.3cat.np.1Gram.b.2c.train
echo
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.porter.np.1Gram.b.svm comp.graphics ${ML_DIR}/news.3cat.porter.np.1Gram.b.2c.train

echo
echo === Generating binary 2-Gram training labels for second category ===
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.porter.2Gram.b.svm comp.graphics ${ML_DIR}/news.3cat.porter.2Gram.b.2c.train
echo
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.np.2Gram.b.svm comp.graphics ${ML_DIR}/news.3cat.np.2Gram.b.2c.train
echo
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.porter.np.2Gram.b.svm comp.graphics ${ML_DIR}/news.3cat.porter.np.2Gram.b.2c.train

echo
echo === Generating binary 1-Gram training labels for third category ===
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.porter.1Gram.b.svm comp.os.ms-windows.misc ${ML_DIR}/news.3cat.porter.1Gram.b.3c.train
echo
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.np.1Gram.b.svm comp.os.ms-windows.misc ${ML_DIR}/news.3cat.np.1Gram.b.3c.train
echo
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.porter.np.1Gram.b.svm comp.os.ms-windows.misc ${ML_DIR}/news.3cat.porter.np.1Gram.b.3c.train

echo
echo === Generating binary 2-Gram training labels for third category ===
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.porter.2Gram.b.svm comp.os.ms-windows.misc ${ML_DIR}/news.3cat.porter.2Gram.b.3c.train
echo
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.np.2Gram.b.svm comp.os.ms-windows.misc ${ML_DIR}/news.3cat.np.2Gram.b.3c.train
echo
${ML_DIR}/OneLabelSVM news.3cat.txt ${SVM_DIR}/news.3cat.porter.np.2Gram.b.svm comp.os.ms-windows.misc ${ML_DIR}/news.3cat.porter.np.2Gram.b.3c.train




echo
echo === Creating linear model for binary 1-Gram labels of first category ==
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.porter.1Gram.b.1c.train ${BIN_DIR}/news.3cat.porter.1Gram.b.1c.model
echo
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.np.1Gram.b.1c.train ${BIN_DIR}/news.3cat.np.1Gram.b.1c.model
echo
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.porter.np.1Gram.b.1c.train ${BIN_DIR}/news.3cat.porter.np.1Gram.b.1c.model

echo
echo === Creating linear model for binary 2-Gram labels of first category ==
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.porter.2Gram.b.1c.train ${BIN_DIR}/news.3cat.porter.2Gram.b.1c.model
echo
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.np.2Gram.b.1c.train ${BIN_DIR}/news.3cat.np.2Gram.b.1c.model
echo
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.porter.np.2Gram.b.1c.train ${BIN_DIR}/news.3cat.porter.np.2Gram.b.1c.model

echo
echo === Creating linear model for binary 1-Gram labels of second category ==
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.porter.1Gram.b.2c.train ${BIN_DIR}/news.3cat.porter.1Gram.b.2c.model
echo
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.np.1Gram.b.2c.train ${BIN_DIR}/news.3cat.np.1Gram.b.2c.model
echo
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.porter.np.1Gram.b.2c.train ${BIN_DIR}/news.3cat.porter.np.1Gram.b.2c.model

echo
echo === Creating linear model for binary 2-Gram labels of second category ==
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.porter.2Gram.b.2c.train ${BIN_DIR}/news.3cat.porter.2Gram.b.2c.model
echo
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.np.2Gram.b.2c.train ${BIN_DIR}/news.3cat.np.2Gram.b.2c.model
echo
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.porter.np.2Gram.b.2c.train ${BIN_DIR}/news.3cat.porter.np.2Gram.b.2c.model

echo
echo === Creating linear model for binary 1-Gram labels of third category ==
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.porter.1Gram.b.3c.train ${BIN_DIR}/news.3cat.porter.1Gram.b.3c.model
echo
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.np.1Gram.b.3c.train ${BIN_DIR}/news.3cat.np.1Gram.b.3c.model
echo
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.porter.np.1Gram.b.3c.train ${BIN_DIR}/news.3cat.porter.np.1Gram.b.3c.model

echo
echo === Creating linear model for binary 2-Gram labels of third category ==
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.porter.2Gram.b.3c.train ${BIN_DIR}/news.3cat.porter.2Gram.b.3c.model
echo
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.np.2Gram.b.3c.train ${BIN_DIR}/news.3cat.np.2Gram.b.3c.model
echo
${BIN_DIR}/svm_learn ${ML_DIR}/news.3cat.porter.np.2Gram.b.3c.train ${BIN_DIR}/news.3cat.porter.np.2Gram.b.3c.model



echo
echo === Classifying data for binary 1-Gram labels of first category ==
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.porter.1Gram.b.1c.train ${BIN_DIR}/news.3cat.porter.1Gram.b.1c.model ${BIN_DIR}/news.3cat.porter.1Gram.b.1c.eval
echo
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.np.1Gram.b.1c.train ${BIN_DIR}/news.3cat.np.1Gram.b.1c.model ${BIN_DIR}/news.3cat.np.1Gram.b.1c.eval
echo
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.porter.np.1Gram.b.1c.train ${BIN_DIR}/news.3cat.porter.np.1Gram.b.1c.model ${BIN_DIR}/news.3cat.porter.np.1Gram.b.1c.eval

echo
echo === Classifying data for binary 2-Gram labels of first category ==
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.porter.2Gram.b.1c.train ${BIN_DIR}/news.3cat.porter.2Gram.b.1c.model ${BIN_DIR}/news.3cat.porter.2Gram.b.1c.eval
echo
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.np.2Gram.b.1c.train ${BIN_DIR}/news.3cat.np.2Gram.b.1c.model ${BIN_DIR}/news.3cat.np.2Gram.b.1c.eval
echo
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.porter.np.2Gram.b.1c.train ${BIN_DIR}/news.3cat.porter.np.2Gram.b.1c.model ${BIN_DIR}/news.3cat.porter.np.2Gram.b.1c.eval

echo
echo === Classifying data for binary 1-Gram labels of second category ==
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.porter.1Gram.b.2c.train ${BIN_DIR}/news.3cat.porter.1Gram.b.2c.model ${BIN_DIR}/news.3cat.porter.1Gram.b.2c.eval
echo
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.np.1Gram.b.2c.train ${BIN_DIR}/news.3cat.np.1Gram.b.2c.model ${BIN_DIR}/news.3cat.np.1Gram.b.2c.eval
echo
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.porter.np.1Gram.b.2c.train ${BIN_DIR}/news.3cat.porter.np.1Gram.b.2c.model ${BIN_DIR}/news.3cat.porter.np.1Gram.b.2c.eval

echo
echo === Classifying data for binary 2-Gram labels of second category ==
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.porter.2Gram.b.2c.train ${BIN_DIR}/news.3cat.porter.2Gram.b.2c.model ${BIN_DIR}/news.3cat.porter.2Gram.b.2c.eval
echo
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.np.2Gram.b.2c.train ${BIN_DIR}/news.3cat.np.2Gram.b.2c.model ${BIN_DIR}/news.3cat.np.2Gram.b.2c.eval
echo
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.porter.np.2Gram.b.2c.train ${BIN_DIR}/news.3cat.porter.np.2Gram.b.2c.model ${BIN_DIR}/news.3cat.porter.np.2Gram.b.2c.eval

echo
echo === Classifying data for binary 1-Gram labels of third category ==
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.porter.1Gram.b.3c.train ${BIN_DIR}/news.3cat.porter.1Gram.b.3c.model ${BIN_DIR}/news.3cat.porter.1Gram.b.3c.eval
echo
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.np.1Gram.b.3c.train ${BIN_DIR}/news.3cat.np.1Gram.b.3c.model ${BIN_DIR}/news.3cat.np.1Gram.b.3c.eval
echo
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.porter.np.1Gram.b.3c.train ${BIN_DIR}/news.3cat.porter.np.1Gram.b.3c.model ${BIN_DIR}/news.3cat.porter.np.1Gram.b.3c.eval

echo
echo === Classifying data for binary 2-Gram labels of third category ==
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.porter.2Gram.b.3c.train ${BIN_DIR}/news.3cat.porter.2Gram.b.3c.model ${BIN_DIR}/news.3cat.porter.2Gram.b.3c.eval
echo
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.np.2Gram.b.3c.train ${BIN_DIR}/news.3cat.np.2Gram.b.3c.model ${BIN_DIR}/news.3cat.np.2Gram.b.3c.eval
echo
${BIN_DIR}/svm_classify ${ML_DIR}/news.3cat.porter.np.2Gram.b.3c.train ${BIN_DIR}/news.3cat.porter.np.2Gram.b.3c.model ${BIN_DIR}/news.3cat.porter.np.2Gram.b.3c.eval