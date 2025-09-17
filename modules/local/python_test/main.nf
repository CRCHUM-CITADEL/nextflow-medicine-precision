process PYTHON_TEST {
    // TODO: give choice between local and not ghc
    container "oras://ghcr.io/crchum-citadel/mdp-python:3.12"

    input:
    file samplesheet

    output:
    file "${samplesheet}_reversed_python.txt"

    script:
    """
    test.py --input $samplesheet
    """

}
