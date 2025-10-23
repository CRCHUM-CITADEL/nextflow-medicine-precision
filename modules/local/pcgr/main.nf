process PCGR {
    tag { sample_id }
    label 'process_medium_memory'

    container params.container_pcgr

    input:
        tuple val(sample_id), path(ger_dna_vcf)
        path vep_cache
        path ref_data

    output:
    path "${sample_id}.cpsr.grch38.classification.tsv.gz"

    script:
    """
    # tabix vcf
    tabix -p vcf $ger_dna_vcf

    cpsr \
    --input_vcf $ger_dna_vcf \
    --vep_dir $vep_cache \
    --refdata_dir $ref_data \
    --output_dir . \
    --genome_assembly grch38 \
    --panel_id 0 \
    --sample_id $sample_id
    """
}
