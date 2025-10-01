// modules/local/gene_cnv_fold_changes/main.nf

process EXTRACT_GENE_CNV_FOLD_CHANGES {
    tag { sample_id }   // helps logging/tracing per sample

    container "oras://ghcr.io/crchum-citadel/sdp-r:4.5.1"

    input:
      tuple val(sample_id), path(somatic_cnv_vcf)      // one sample id + corresponding vcf.gz file
      path gene_annotations                             // one gene annotations file

    output:
      path "*.genes.cnv.tsv"
      

    script:
    """
    zcat $somatic_cnv_vcf  | grep "#" > ${sample_id}.somatic.cnv.vcf
    zcat $somatic_cnv_vcf  | grep PASS >> ${sample_id}.somatic.cnv.vcf

    gen_gene_cnv_fold_changes.R \
      --vcf ${sample_id}.somatic.cnv.vcf \
      --annotation $gene_annotations \
      --output ${sample_id}.genes.cnv.tsv
    """
}
