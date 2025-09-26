// modules/local/gene_cnv_fold_changes/main.nf

process GENE_CNV_FOLD_CHANGES_TO_CBIOPORTAL {
    tag { output_file_name }   // helps logging/tracing per sample

    container "oras://ghcr.io/crchum-citadel/sdp-r:4.5.1"

    input:
      path somatic_cnv_vcf      // one vcf.gz file
      path fold_changes_per_gene_cnv     // one gene annotations file

    output:
      path "*_data_cna_hg38.seg"
      

    script:
    """
    originalTumorName=`echo $somatic_cnv_vcf | awk -F"/" '{print \$NF}' | awk -F"." '{print \$1}'`
    newTumorName=`echo $somatic_cnv_vcf | awk -F"/" '{print \$5}' | awk -F"-" '{print \$1"-"\$2"-"\$3"-"\$4".DT"}'`
    
    gen_cbioportal-converter.R \
      --vcf tmp/\$newTumorName.somatic.cnv.vcf \
      --tsv output/\$newTumorName.genes.cnv.tsv \
      --sample_id \$newTumorName \
      --output_dir output
    """
}
