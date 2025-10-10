include { VCF2MAF } from '../../../modules/nf-core/vcf2maf'
include { INTEGRATE_RNA_VARIANTS } from '../../../modules/local/integrate_rna_variants'
include { PCGR } from '../../../modules/pcgr'
include { CONVERT_CPSR_TO_MAF } '../../../convert_cpsr_to_maf'


workflow GENOMIC_VARIANTS {
    take:
        ger_dna_vcf // tuple (sample_id, filepath)
        som_dna_vcf // tuple (sample_id, filepath)
        som_rna_vcf // tuple (sample_id, filepath)
        fasta
        vep_cache

    main:

        // output tuple(meta, maf)
        som_dna_maf = VCF2MAF(
            som_dna_vcf, // tuple ([info1, info2], uncompressed vcf path)
            fasta,
            vep_cache
        )

        som_dna_rna_maf = INTEGRATE_RNA_VARIANTS(
            som_rna_vcf,
            som_dna_maf
        )

        ger_dna_tsv = CPSR{
            ger_dna_vcf,
            vep_cache
        }

        cbioportal_genomic_variants = CONVERT_CPSR_TO_MAF (
            ger_dna_tsv,
            rna_somatic_maf,
            ger_som_rna_maf
        )

    emit:
        cbioportal_genomic_variants

}
