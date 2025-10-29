process FORMAT_CLINICAL {
    publishDir "${params.outdir}", mode: 'copy'

    container params.container_r

    tag { mode }

    input:
        val mode 
        tuple val(group), val(sample_list)

    output:
        path "data_clinical_${mode}.txt"

    script:
    """
    clin_format.R \
        --mode ${mode} \
        --patient ${sample_list.patient} \
        --diagnosis ${sample_list.diagnosis} \
        --treatment ${sample_list.treatment} \
        --surgeries ${sample_list.surgeries} \
        --systreat ${sample_list.systemic_treatment} \
        --specimen ${sample_list.specimen} \
        --radiotherapy ${sample_list.radio_therapy} \
        --output data_clinical_${mode}.txt
    """
}