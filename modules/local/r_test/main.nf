process R_TEST {
    container 'r-citadel_v4.5.1.sif'

    input:
    file samplesheet

    script:
    """
    test.R $samplesheet
    """

}
