process PYTHON_TEST {
    // TODO: give choice between local and not ghc
    container "oras://ghcr.io/crchum-citadel/sdp-python:3.12"

    input:
    path samplesheet

    output:
    path "${samplesheet}_reversed_python.txt"

    script:
    """
    test.py --input $samplesheet
    """

}
