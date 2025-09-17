process PYTHON_TEST {
    // TODO: take this container as input (don't assume location)
    container "$projectDir/containers/python-citadel_v3.12.sif"

    input:
    file samplesheet

    output:
    file "${samplesheet}_reversed_python.txt"

    script:
    """
    test.py --input $samplesheet
    """

}
