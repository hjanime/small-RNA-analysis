set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -v
set -x
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
GENOME="/home/lpantano/projects/index/ody_copy/hg19"

for S in 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1; do
    echo "running $S "
    OUT="similarity$S"
    if [ ! -e $OUT  ] ; then
        mkdir -p  $OUT/res
        seqcluster prepare -c config -o $OUT
        bowtie -a --best --strata -m 5000 -f $GENOME $OUT/seqs.fa -S  $OUT/seqs.sam
        samtools view -Sbh $OUT/seqs.sam | samtools sort -o /dev/stdin  tmp | samtools view -h /dev/stdin > $OUT/seqs.sort.sam
        seqcluster cluster -a $OUT/seqs.sort.sam -m $OUT/seqs.ma -o $OUT/res --similar $S  
    fi
done
