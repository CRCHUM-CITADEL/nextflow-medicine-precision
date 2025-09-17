process R_TEST {
    // TODO: give choice between local and not ghcr
    container 'oras://ghcr.io/citadel-test/r-citadel:4.5.1'


    input:
    file samplesheet

    output:
    file "${samplesheet}_reversed_r.txt"

    script:
    """
    test.R $samplesheet
    """

}
