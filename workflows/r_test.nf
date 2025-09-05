process RUN {
    container 'r-citadel_v4.5.1.sif'

    input:
    file samplesheet

    script:
    """
    test.R $samplesheet
    """

}

workflow R_TEST {
    take:
    samplesheet

    main:

    RUN(samplesheet)

}