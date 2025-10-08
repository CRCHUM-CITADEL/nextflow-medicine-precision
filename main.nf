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

include { GENOMIC   } from './workflows/genomic.nf'
include { CLINICAL  } from './workflows/clinical.nf'
include { PIPELINE_INITIALISATION } from './subworkflows/local/utils'
include { PIPELINE_COMPLETION     } from './subworkflows/local/utils'
// include { getGenomeAttribute      } from './subworkflows/local/utils'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    GENOME PARAMETER VALUES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// TODO nf-core: Remove this line if you don't need a FASTA file
//   This is an example of how to use getGenomeAttribute() to fetch parameters
//   from igenomes.config using `--genome`
// params.fasta = getGenomeAttribute('fasta')

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOWS FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOWS : Run main pipeline.
//

// workflow NFCORE_CITADEL_TEST {
//     take:
//     samplesheet

//     main:

//     TEST (
//         samplesheet
//     )

// }

workflow CLINICAL_PIPELINE {
    take:
    ch_samplesheet

    main:

    CLINICAL (
        ch_samplesheet
    )

}

// workflow GENOMIC_PIPELINE {
//     take:
//     samplesheet_list

//     main:

//     GENOMIC (
//         samplesheet_list,
//         params.ensembl_annotations,
//         params.gencode_annotations
//     )

// }

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {

    main:

    //
    // SUBWORKFLOW: Run initialisation tasks and checks
    //
    PIPELINE_INITIALISATION (
        params.version,
        params.monochrome_logs,
        args,
        params.mode,
        params.outdir,
        params.input
    )

    //
    // WORKFLOW: Run main workflow
    //
    // NFCORE_CITADEL_TEST (
    //     PIPELINE_INITIALISATION.out.samplesheet
    // )
    if (params.mode == 'genomic'){
        // GENOMIC_PIPELINE(PIPELINE_INITIALISATION.out.samplesheet)
        GENOMIC (
            PIPELINE_INITIALISATION.out.samplesheet,
            params.ensembl_annotations,
            params.gencode_annotations
        )
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
