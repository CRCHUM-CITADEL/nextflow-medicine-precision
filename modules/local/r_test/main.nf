process R_TEST {
    container "${projectDir}/containers/r-citadel_v4.5.1.sif"

    input:
    file samplesheet

    output:
    file "${samplesheet}_reversed_r.txt"

    script:
    """
    test.R $samplesheet
    """

}
