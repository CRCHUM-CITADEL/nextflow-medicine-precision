// modules/local/gene_cnv_fold_changes/main.nf

process GENE_CNV_FOLD_CHANGES {
    tag { output_file_name }   // helps logging/tracing per sample

    container "oras://ghcr.io/crchum-citadel/sdp-r:4.5.1"

    input:
      path somatic_cnv_vcf      // one vcf.gz file
      path gene_annotations     // one gene annotations file

    output:
      path "*.genes.cnv.tsv"
      

    script:
    """
    originalTumorName=`echo $somatic_cnv_vcf  | awk -F"/" '{print $NF}' | awk -F"." '{print $1}'`
    newTumorName=`echo $somatic_cnv_vcf  | awk -F"/" '{print $5}' | awk -F"-" '{print $1"-"$2"-"$3"-"$4".DT"}'`
    zcat $somatic_cnv_vcf  | grep "#" > tmp/\$newTumorName.somatic.cnv.vcf
    zcat $somatic_cnv_vcf  | grep PASS >> tmp/\$newTumorName.somatic.cnv.vcf

    gen_cnv_fold_changes.R \
      --vcf tmp/\$newTumorName.somatic.cnv.vcf \
      --annotation $gene_annotations \
      --output \$newTumorName.genes.cnv.tsv
    """
}
