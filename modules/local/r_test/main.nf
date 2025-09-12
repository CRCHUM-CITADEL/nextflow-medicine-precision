process R_TEST {
    container 'docker://ghcr.io/justinbellavance/r-citadel:v4.5.1'


    input:
    file samplesheet

    output:
    file "${samplesheet}_reversed_r.txt"

    script:
    """
    test.R $samplesheet
    """

}
