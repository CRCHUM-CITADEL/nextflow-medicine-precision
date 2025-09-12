/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { softwareVersionsToYAML } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { SIMPLE_TEST } from '../subworkflows/local/simple_test'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow TEST {

    take:
    samplesheet // channel: samplesheet read in from --input

    main:
    // Run test subworkflow and capture outputs
    test_results = SIMPLE_TEST(samplesheet)

    //
    // Save PYTHON_TEST results
    //
    test_results.python_out
        .collectFile(
            storeDir: "${params.outdir}",
            name: "python_test_results.txt",
            newLine: true
        )
        .set { ch_python_results }

    //
    // Save R_TEST results
    //
    test_results.r_out
        .collectFile(
            storeDir: "${params.outdir}",
            name: "r_test_results.txt",
            newLine: true
        )
        .set { ch_r_results }

    //
    // Collate and save software versions
    //
    ch_versions = Channel.empty()
    softwareVersionsToYAML(ch_versions)
        .collectFile(
            storeDir: "${params.outdir}/pipeline_info",
            name:  'test_software_versions.yml',
            sort: true,
            newLine: true
        )
        .set { ch_collated_versions }

    emit:
    versions      = ch_versions
    python_out    = ch_python_results
    r_out         = ch_r_results
}


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
