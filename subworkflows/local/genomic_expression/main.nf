include { GET_TPM } from '../../../modules/local/get_tpm'
include { MERGE_EXPRESSION_FILES_TO_CBIOPORTAL } from '../../../modules/local/merge_expression_files_to_cbioportal'

workflow GENOMIC_EXPRESSION {
    take:
        somatic_expression // tuple (sample_id, filepath)
        gencode_annotations // gene annotation file 

    main:

        tpm_file_ch = GET_TPM(
            somatic_expression,
            gencode_annotations
            )

        // TODO : merge files

        tpm_file_list = tpm_file_ch.collect()

        cbioportal_genomic_expression = MERGE_EXPRESSION_FILES_TO_CBIOPORTAL(
            tpm_file_list
            )


    emit:
        cbioportal_genomic_expression

}
