
cd '/scratch/cqs/shengq2/jennifer/20200407_lindsay_exomeseq_3772_hg38/bwa/result'

set -o pipefail




if [[ -e /scratch/cqs/shengq2/jennifer/20200407_lindsay_exomeseq_3772_hg38/bwa/result/P_56B.unsorted.bam.failed ]]; then
  rm /scratch/cqs/shengq2/jennifer/20200407_lindsay_exomeseq_3772_hg38/bwa/result/P_56B.unsorted.bam.failed
fi


status=0
if [[ ! -e P_56B.unsorted.bam.succeed ]]; then
  echo bwa_mem=`date`
  bwa mem  -M -t 8 -R "@RG\tID:1\tPU:P_56B\tLB:P_56B\tSM:P_56B\tPL:ILLUMINA" /data/cqs/references/broad/hg38/v0/bwa_index_0.7.17/Homo_sapiens_assembly38.fasta "/scratch/cqs/shengq2/jennifer/20200407_lindsay_exomeseq_3772_hg38/cutadapt/result/P_56B_clipped.1.fastq.gz" "/scratch/cqs/shengq2/jennifer/20200407_lindsay_exomeseq_3772_hg38/cutadapt/result/P_56B_clipped.2.fastq.gz"  2> >(tee P_56B.bwa.stderr.log >&2) | samtools view -bS -o P_56B.unsorted.bam
  status=$?
  if [[ $status -eq 0 ]]; then
    touch P_56B.unsorted.bam.succeed
  else
    rm P_56B.unsorted.bam
    touch P_56B.unsorted.bam.failed
  fi
  bwa 2>&1 | grep Version | cut -d ' ' -f2 | cut -d '-' -f1 | awk '{print "bwa,v"$1}' > P_56B.bwa.version
fi

if [[ -e P_56B.unsorted.bam.succeed ]]; then
  echo bamStat=`date` 
  python3 /data/cqs/softwares/ngsperl/lib/Alignment/bamStat.py -i P_56B.unsorted.bam -o P_56B.bamstat
fi
    
if [[ (-e P_56B.unsorted.bam.succeed) && ((1 -eq $1) || (! -s P_56B.sortedByCoord.bam)) ]]; then
  echo sort_bam=`date`
  samtools sort -m 5G  -T bwa_P_56B -o P_56B.sortedByCoord.bam P_56B.unsorted.bam && touch P_56B.sortedByCoord.bam.succeed
  rm -rf bwa_P_56B
  if [[ ! -e P_56B.sortedByCoord.bam.succeed ]]; then
    rm P_56B.sortedByCoord.bam
  fi
fi

if [[ (-e P_56B.sortedByCoord.bam.succeed) && ((1 -eq $1) || (! -s P_56B.sortedByCoord.bam.bai)) ]]; then
  echo index_bam=`date`
  samtools index  P_56B.sortedByCoord.bam 
  samtools idxstats P_56B.sortedByCoord.bam > P_56B.sortedByCoord.bam.chromosome.count
fi




if [[ -e P_56B.sortedByCoord.bam.succeed && -s P_56B.sortedByCoord.bam.bai ]]; then
  echo flagstat=`date` 
  samtools flagstat P_56B.sortedByCoord.bam > P_56B.sortedByCoord.bam.stat 
fi

rm -rf bwa_P_56B 

if [[ -e P_56B.sortedByCoord.bam.succeed && -s P_56B.bamstat ]]; then
  rm  P_56B.unsorted.bam
fi
