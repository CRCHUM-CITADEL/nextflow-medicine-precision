process DRAGEN_FUSION_SV_TO_CBIOPORTAL {
    tag { sample_id }

    container "oras://ghcr.io/crchum-citadel/sdp-r:4.5.1"

    input:
        tuple val(sample_id), path(dragen_fusion)

    output:
        path "*.data_sv.txt"


    script:
    """
    format_dragen_fusion.R \
        -i $dragen_fusion \
        -o ${sample_id}.data_sv.txt \
        -s $sample_id
    """
}
