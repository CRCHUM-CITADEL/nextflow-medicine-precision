process R_TEST {
    // TODO: give choice between local and not ghcr
    container "oras://ghcr.io/crchum-citadel/sdp-r:4.5.1"

    input:
    file samplesheet

    output:
    file "${samplesheet}_reversed_r.txt"

    script:
    """
    test.R $samplesheet
    """

}
