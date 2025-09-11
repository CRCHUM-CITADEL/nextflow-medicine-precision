include { PYTHON_TEST } from '../../../modules/local/python_test'
include { R_TEST } from '../../../modules/local/r_test'

workflow SIMPLE_TEST {
    take:
    samplesheet

    main:
    PYTHON_TEST(samplesheet)
    R_TEST(samplesheet)

    emit:
    "completed succesfully"

}
