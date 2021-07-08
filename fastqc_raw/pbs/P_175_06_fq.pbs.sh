
cd '/scratch/cqs/shengq2/jennifer/20200407_lindsay_exomeseq_3772_hg38/fastqc_raw/result/P_175_06'

set -o pipefail



fastqc  --extract -t 2 -o `pwd` "/scratch/cqs/shengq2/jennifer/20200407_lindsay_exomeseq_3772_hg38/dedup_fastq/result/P_175_06.dedup.1.fastq.gz" "/scratch/cqs/shengq2/jennifer/20200407_lindsay_exomeseq_3772_hg38/dedup_fastq/result/P_175_06.dedup.2.fastq.gz" 2> >(tee P_175_06.fastqc.stderr.log >&2)

fastqc --version | cut -d ' ' -f2 | awk '{print "FastQC,"$1}' > `pwd`/fastqc.version
