process RUN {
    container 'python-citadel_v3.12.sif'

    input:
    file samplesheet

    script:
    """
    test.py --input $samplesheet
    """

}

workflow PYTHON_TEST {
    take:
    samplesheet

    main:

    RUN(samplesheet)

}