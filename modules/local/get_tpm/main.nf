process GET_TPM {
    tag { sample_id }   // helps logging/tracing per sample

    container params.container_r

    input:
        tuple val(sample_id), path(somatic_expression_file)      // one sample id + corresponding .quant.genes.sf  file
        path gene_annotations                                    // one gene annotations file (gtf)

    output:
        path "${sample_id}.tpm.tsv"

    script:
    """
    grep -v "^#" $gene_annotations | \
        grep -v "pseudogene" | \
        grep -v "processed_transcript" | \
        awk '{for(i=1;i<=NF;i++) {if(\$i=="gene_id") gene_id=\$(i+1); if(\$i=="gene_name") gene_name=\$(i+1)}} gene_id!="" && gene_name!="" {gsub(/\\.[0-9]+/, "", gene_id); print gene_id, gene_name}' | \
        sed 's/"//g' | sed 's/;//g' | \
        sort -u | \
        awk '{print \$1"\\t"\$2}' \
        > gene_id_to_name.tsv

    gen_get_tpm.R \
        --input $somatic_expression_file \
        --gene_map gene_id_to_name.tsv \
        --sample_id $sample_id \
        --output ${sample_id}.tpm.tsv
    """
}
