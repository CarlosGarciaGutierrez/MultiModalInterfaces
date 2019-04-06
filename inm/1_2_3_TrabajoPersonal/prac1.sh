#!/bin/bash

clear

PORTER_DIR="../2_3TextClassification/Normalization/PorterStemmer"
NGRAMS_DIR="../2_3TextClassification/NGrams"

echo === Extracting top three categories ===
./SelectDocsByCategory.sh news 3cat alt.atheism comp.graphics comp.os.ms-windows.misc

echo === Applying NP ===
python ${PORTER_DIR}/../NormPython/quitaSim.py < news.3cat.txt > news.3cat.qsim.txt
python ${PORTER_DIR}/../NormPython/quita1car.py < news.3cat.qsim.txt > news.3cat.qsim.q1car.txt

echo === Applying Porter ===
${PORTER_DIR}/PorterStemmer news.3cat.qsim.q1car.txt > news.3cat.qsim.q1car.porter.txt

echo === Generating 1-Grams ===
${NGRAMS_DIR}/NGrams news.3cat.qsim.q1car.porter.txt 1 news.3cat.qsim.q1car.porter.1Gram

echo === Generating 2-Grams ===
${NGRAMS_DIR}/NGrams news.3cat.qsim.q1car.porter.txt 2 news.3cat.qsim.q1car.porter.2Gram