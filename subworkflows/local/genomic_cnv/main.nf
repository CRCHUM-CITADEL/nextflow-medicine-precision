include { EXTRACT_GENE_CNV_FOLD_CHANGES } from '../../../modules/local/extract_gene_cnv_fold_changes'
include { GENE_CNV_FOLD_CHANGES_TO_CBIOPORTAL } from '../../../modules/local/gene_cnv_fold_changes_to_cbioportal'

workflow GENOMIC_CNV {
    take:
    cnv_vcf_files // ex: ../../data/dna/*/*/*.WGS_somatic-tumor_normal.cnv.vcf.gz
    gene_annotations_file // gene annotation file (e.g. : "/lustre06/project/6079532/citadelomique/resources/genomes/grch38/annotations/ensembl/biomart_grch38_ensembl_113.tsv")


    main:

    fold_change_per_gene_cnv = EXTRACT_GENE_CNV_FOLD_CHANGES(
        cnv_vcf_files,
        gene_annotations_file
        )

    cbioportal_genomic_cnv = GENE_CNV_FOLD_CHANGES_TO_CBIOPORTAL(
        cnv_vcf_files,
        fold_change_per_gene_cnv
        )


    emit:
    cbioportal_genomic_cnv

}