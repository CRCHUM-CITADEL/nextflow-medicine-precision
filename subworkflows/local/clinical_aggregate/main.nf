include { FORMAT_CLINICAL } from '../../../modules/local/format_clinical'
include { ASSIGN_DATE } from '../../../modules/local/assign_date'

workflow CLINICAL_AGGREGATE {
    take:
        filelist

    main: 

        csvs_with_date = ASSIGN_DATE(
                filelist
            ).map { meta, csv ->
                def group = meta.group
                def pipeline = meta.pipeline
                tuple(group, [(pipeline): csv])
            }.groupTuple()
            .map { group, data_list ->
                tuple(group, data_list.collectEntries())
            }

        csvs_with_date.view()

        mode_ch = channel.of("sample", "patient")

        clinical_data = FORMAT_CLINICAL(
            mode_ch,
            csvs_with_date
        )

        emit: 
            csvs_with_date
}