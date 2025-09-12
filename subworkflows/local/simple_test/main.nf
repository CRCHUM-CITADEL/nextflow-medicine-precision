include { PYTHON_TEST } from '../../../modules/local/python_test'
include { R_TEST } from '../../../modules/local/r_test'

workflow SIMPLE_TEST {
    take:
    samplesheet

    main:
    python_out = PYTHON_TEST(samplesheet)
    r_out      = R_TEST(samplesheet)

    emit:
    python_out
    r_out

}
