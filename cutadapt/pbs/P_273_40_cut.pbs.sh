
cd '/scratch/cqs/shengq2/jennifer/20200407_lindsay_exomeseq_3772_hg38/cutadapt/result'

set -o pipefail



cutadapt -j 2 -n 2 -O 1 -q 20 -a AGATCGGAAGAGCACACGTC -A AGATCGGAAGAGCGTCGTGT -m 30 -a "A{50}" -a "T{50}" -a "G{50}" -a "C{50}" -A "A{50}" -A "T{50}" -A "G{50}" -A "C{50}" -o P_273_40_clipped.1.fastq.gz -p P_273_40_clipped.2.fastq.gz  --too-short-output=P_273_40_clipped.1.fastq.short.gz --too-short-paired-output=P_273_40_clipped.2.fastq.short.gz /scratch/cqs/shengq2/jennifer/20200407_lindsay_exomeseq_3772_hg38/dedup_fastq/result/P_273_40.dedup.1.fastq.gz /scratch/cqs/shengq2/jennifer/20200407_lindsay_exomeseq_3772_hg38/dedup_fastq/result/P_273_40.dedup.2.fastq.gz 1> >(tee P_273_40.stdout.log ) 2> >(tee P_273_40.stderr.log >&2)
status=$?
if [[ $status -eq 0 ]]; then
  touch P_273_40.succeed
  md5sum P_273_40_clipped.1.fastq.gz > P_273_40_clipped.1.fastq.gz.md5
  md5sum P_273_40_clipped.2.fastq.gz > P_273_40_clipped.2.fastq.gz.md5
else
  touch P_273_40.failed
fi


cutadapt --version 2>&1 | awk '{print "Cutadapt,v"$1}' > P_273_40.version
