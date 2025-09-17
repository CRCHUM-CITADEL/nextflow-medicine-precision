process R_TEST {
    // TODO: take this container as input (don't assume location)
    container "$projectDir/containers/r-citadel_v4.5.1.sif"


    input:
    file samplesheet

    output:
    file "${samplesheet}_reversed_r.txt"

    script:
    """
    test.R $samplesheet
    """

}
