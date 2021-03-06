# author: Eugen Saraci
# date  : 03/12/18


# checking if it's being executed from the correct dir
if [ ! -f terrier/bin/trec_terrier.sh ]; then
    echo "[-] terrier/bin/trec_terrier.sh not found!"
    echo "[-] Please be sure to execute this script just outside of the terrier directory."
    exit 1
fi

# creating/deleting folders needed for correct execution
if [ ! -d "terrier/var/indexes" ]
then
    mkdir terrier/var/indexes
fi

if [ -d "terrier/var/indexes/full" ]
then
    rm -r terrier/var/indexes/full
fi
mkdir terrier/var/indexes/full

if [ -d "terrier/var/indexes/nostop" ]
then
    rm -r terrier/var/indexes/nostop
fi
mkdir terrier/var/indexes/nostop

if [ -d "terrier/var/indexes/none" ]
then
    rm -r terrier/var/indexes/none
fi
mkdir terrier/var/indexes/none


echo "[+] -- INDEXING IS STARTING --"

# command params
#
# -Dterrier.index.path  --> name of the index we are creating
# -Dtermpipelines       --> pipeline steps (stemmer, stopwords)
#

index_1() {

    sh terrier/bin/trec_terrier.sh -i \
    -Dterrier.index.path=indexes/full \
    -Dtermpipelines=Stopwords,PorterStemmer  
}

index_2() {

    sh terrier/bin/trec_terrier.sh -i \
    -Dterrier.index.path=indexes/nostop \
    -Dtermpipelines=PorterStemmer
}

index_3() {

    sh terrier/bin/trec_terrier.sh -i \
    -Dterrier.index.path=indexes/none \
    -Dtermpipelines=
}

# executing them concurrently
index_1 & index_2 & index_3

# waiting for the processes to finish
wait

echo "[+] -- INDEXING IS OVER --"
