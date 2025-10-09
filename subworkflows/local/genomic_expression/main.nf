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
        tpm_file_list = tpm_file_ch
            .collect()
            .map { files ->
                if (files.size() < 2) {
                    log.warn "GENOMIC_EXPRESSION: Found ${files.size()} TPM file(s). Need at least 2 files to merge. Skipping merge step."
                    return null
                }
                return files
            }
            .filter { it != null }

        tpm_file_list = tpm_file_ch.collect()

        cbioportal_genomic_expression = MERGE_EXPRESSION_FILES_TO_CBIOPORTAL(
            tpm_file_list
            )


    emit:
        cbioportal_genomic_expression

}
