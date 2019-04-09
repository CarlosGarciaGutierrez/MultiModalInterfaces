#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""

@author: quevedo
"""

# 70 prepositions from: https://www.englishclub.com/grammar/prepositions-list.htm
prepList=['aboard','about','above','across','after','against','along','amid','among','anti','around','as','at','before','behind','below','beneath','beside','besides','between','beyond','but','by','concerning','considering','despite','down','during','except','excepting','excluding','following','for','from','in','inside','into','like','minus','near','of','off','on','onto','opposite','outside','over','past','per','plus','regarding','round','save','since','than','through','to','toward','towards','under','underneath','unlike','until','up','upon','versus','via','with','within','without'];

def isPrep(w):
    for i in range(len(prepList)):
        if w==prepList[i]:
            return True;
    return False;
