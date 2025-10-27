import { FORMAT_CLINICAL } from '../../../modules/local/format_clinical'

workflow CLINICAL_AGGREGATE {
    take:
        sample_list 

    main: 

        mode_ch = channel.of("sample", "patient")

        clinical_data = FORMAT_CLINICAL(
            mode_ch,
            sample_list
        )

        emit: 
            clinical_data
}