process PYTHON_TEST {
    container 'python-citadel_v3.12.sif'

    input:
    file samplesheet

    script:
    """
    test.py --input $samplesheet
    """

}
