
import re, string, random, glob, operator, heapq, sys
from collections import defaultdict
from math import log10
# from ngrams import * 


def makeprob(worddict, totalcount):
    probdict = dict()
    for word in worddict: 
        probdict[word] = log10(worddict[word] / totalcount )
    return probdict

def makecharprob(subdict):
    chardict = dict()
    charcount = 0
    for word in worddict: 
        prevchar = " "
        for i in range (len(word)):
            char = prevchar + 
            if bigram not in chardict: 
                chardict[bigram] = 1 
            elif bigram in chardict: 
                chardict[bigram] += 1

            charcount += 1 
    for bigram in chardict: 
        chardict[char] = log10(chardict[char] / charcount)
    return chardict 



def main (): 
    worddict = dict()
    totalcount = 0
    with open('phrases2.txt', 'r')as f: 
        for line in f:
            line = line.strip()
            for word in line.split(" "): 
                if word in worddict: 
                    worddict[word] += 1
                elif word not in worddict: 
                    worddict[word] = 1 
                totalcount += 1 
        probdict = makeprob(worddict, totalcount)

    with open('hi.txt', 'w') as w:
        for word in probdict: 
            w.write(word +  " " +  str(probdict[word]) + "\n")




if __name__ == "__main__":
    main()










