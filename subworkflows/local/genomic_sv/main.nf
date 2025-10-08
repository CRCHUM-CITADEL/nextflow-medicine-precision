// include modules
include { DRAGEN_FUSION_SV_TO_CBIOPORTAL } from '../../../modules/local/dragen_fusion_sv_to_cbioportal'


workflow GENOMIC_SV {
    take:
        sv_vcf

    main:
        cbioportal_genomic_sv = DRAGEN_FUSION_SV_TO_CBIOPORTAL(
            sv_vcf
        )

    emit: 
        cbioportal_genomic_sv
}