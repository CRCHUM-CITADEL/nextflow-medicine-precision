/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { softwareVersionsToYAML } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { GENOMIC_CNV } from '../subworkflows/local/genomic_cnv'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow GENOMIC {

    take:
        samplesheet_list
        ensembl_annotations
        gencode_annotations

    main:

        ch_versions = Channel.empty()

        // Create a channel where each record has: sample, filepath, pipeline label
        ch_vcf_all = samplesheet_list
            .map { rec ->
                def sample = rec[0].sample
                def file = "${params.input_dir}/${rec[0].file}"
                // assume rec[0].pipeline exists (or derive it somehow)
                def pipeline = rec[0].pipeline  // e.g. "cnv", "rna", etc.
                return tuple(sample, file, pipeline)
            }

        ch_vcf_all.view()

        // Filter out only the ones for the “cnv” pipeline
        ch_vcf_cnv = ch_vcf_all
            .filter { sample, file, pipeline ->
                pipeline == 'cnv'
            }
            // then drop the pipeline field (if GENOMIC_CNV expects only sample + file)
            .map { sample, file, pipeline ->
                tuple(sample, file)
            }

        GENOMIC_CNV(
            ch_vcf_cnv,
            ensembl_annotations
        )

        //
        // TASK: Aggregate software versions
        //
        softwareVersionsToYAML(ch_versions)
            .collectFile(
                storeDir: "${params.outdir}/pipeline_info",
                name: 'software_versions.yml',
                sort: true,
                newLine: true,
            )
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
