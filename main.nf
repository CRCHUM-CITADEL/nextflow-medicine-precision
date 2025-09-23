#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CRCHUM-CITADEL/nextflow-sante-precision
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/CRCHUM-CITADEL/nextflow-sante-precision
----------------------------------------------------------------------------------------
*/

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT FUNCTIONS / MODULES / SUBWORKFLOWS / WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { TEST      } from './workflows/test.nf'
include { GENOMIC   } from './workflows/genomic.nf'
include { CLINICAL  } from './workflows/clinical.nf'
include { PIPELINE_INITIALISATION } from './subworkflows/local/utils_nfcore_test_pipeline'
include { PIPELINE_COMPLETION     } from './subworkflows/local/utils_nfcore_test_pipeline'
include { getGenomeAttribute      } from './subworkflows/local/utils_nfcore_test_pipeline'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    GENOME PARAMETER VALUES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// TODO nf-core: Remove this line if you don't need a FASTA file
//   This is an example of how to use getGenomeAttribute() to fetch parameters
//   from igenomes.config using `--genome`
params.fasta = getGenomeAttribute('fasta')

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOWS FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOWS : Run main pipeline.
//

workflow NFCORE_CITADEL_TEST {
    take:
    samplesheet

    main:

    TEST (
        samplesheet
    )

}

workflow CLINICAL_PIPELINE {
    take:
    samplesheet

    main:

    CLINICAL (
        samplesheet
    )

}

workflow GENOMIC_PIPELINE {
    take:
    samplesheet

    main:

    GENOMIC (
        samplesheet
    )

}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {

    main:

    // make sure mode is good
    if (!params.mode){
        error("ERROR: Pipeline mode not chosen in configuration file. Choices : 'genomic' or 'clinical'")
    }
    params.mode = params.mode.toLowerCase()
    if ( !params.mode in ['genomic','clinical'] ) {
        error("Error: Invalid pipeline mode chosen. Choices : 'Genomic' or 'Clinical'")
    }

    // make sure there's input
    if (!params.input){
        error("ERROR: Could not find samplesheet file. Not running any tests. Check input in nextflow.config")
    }



    //
    // SUBWORKFLOW: Run initialisation tasks
    //
    PIPELINE_INITIALISATION (
        params.version,
        params.monochrome_logs,
        args,
        params.outdir,
        params.input
    )

    //
    // WORKFLOW: Run main workflow
    //
    NFCORE_CITADEL_TEST (
        PIPELINE_INITIALISATION.out.samplesheet
    )
    if (params.mode == 'genomic'){
        GENOMIC_PIPELINE(PIPELINE_INITIALISATION.out.samplesheet)
    }
    else if (params.mode == 'clinical'){
        CLINICAL_PIPELINE(PIPELINE_INITIALISATION.out.samplesheet)
    }


    //
    // SUBWORKFLOW: Run completion tasks
    //
    PIPELINE_COMPLETION (
        params.email,
        params.email_on_fail,
        params.plaintext_email,
        params.outdir,
        params.monochrome_logs,
        params.hook_url,
    )
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
