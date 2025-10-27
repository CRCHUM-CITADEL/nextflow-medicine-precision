process FORMAT_CLINICAL {
    publishDir "${params.outdir}", mode: 'copy'

    tag { mode }

    input:
        val mode 
        val sample_list 

    output:
        path "data_clinical_${mode}.txt"

    script:
    """
    
    clin_format.R \
        $sample_list \
        $mode \
        >> data_clinical_${mode}.txt
    """
}