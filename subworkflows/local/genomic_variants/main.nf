include { VCF2MAF } from '../../../modules/nf-core/vcf2maf'
include { INTEGRATE_RNA_VARIANTS } from '../../../modules/local/integrate_rna_variants'
include { PCGR } from '../../../modules/local/pcgr'
include { CONVERT_CPSR_TO_MAF } from '../../../modules/local/convert_cpsr_to_maf'
include { DOWNLOAD_VEP_TEST } from '../../../modules/local/download_vep_test'

workflow GENOMIC_VARIANTS {
    take:
        ger_dna_vcf // tuple (sample_id, filepath)
        som_dna_vcf // tuple (sample_id, filepath)
        som_rna_vcf // tuple (sample_id, filepath)
        fasta
        vep_cache

    main:

        DOWNLOAD_VEP_TEST()
        
        // Combine both channels and take the first available
        
        ch_vep_data = vep_cache
            .mix(DOWNLOAD_VEP_TEST.out.cache_dir)
            .first()

        som_dna_vcf.view()

        som_dna_vcf_input = som_dna_vcf.map { id, vcf ->
            def meta = [ id: id ]
            return tuple(meta, vcf)
        }
        
        VCF2MAF(
            som_dna_vcf_input,
            fasta,
            ch_vep_data,
            params.vep_params
        )

        som_dna_maf = VCF2MAF.out.maf.map { meta, vcf ->
            return tuple(meta.id, vcf)
        }

        // join on ID to create tuple(id, dna, rna)
        som_rna_dna_tuple = som_rna_vcf
            .join(som_dna_maf)

        som_dna_rna_maf = INTEGRATE_RNA_VARIANTS(
            som_rna_dna_tuple
        )

        ger_dna_tsv = PCGR {
            ger_dna_vcf,
            ch_vep_data,
            fasta
        }

        // cbioportal_genomic_variants = CONVERT_CPSR_TO_MAF (
        //     ger_dna_tsv,
        //     rna_somatic_maf,
        //     ger_som_rna_maf
        // )

    emit:
        som_dna_rna_maf

}
