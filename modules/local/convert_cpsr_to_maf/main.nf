process CONVERT_CPSR_TO_MAF {

    tag { sample_id }

    container params.container_r

    input:
    tuple val(sample_id), path(som_dna_rna_maf)
    path ger_dna_tsv


    output:
    path "*.somatic_rna_germline.maf"
    

    script:
    """
    convert_cpsr_to_maf.R \
        $ger_dna_tvs \
        $som_dna_rna_maf \
        ${sample_id}.somatic_rna_germline.maf
    """

}