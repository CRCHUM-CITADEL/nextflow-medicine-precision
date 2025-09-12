process PYTHON_TEST {
    container 'docker://ghcr.io/justinbellavance/python-citadel:v3.12'
    
    input:
    file samplesheet

    output:
    file "${samplesheet}_reversed_python.txt"

    script:
    """
    test.py --input $samplesheet
    """

}
