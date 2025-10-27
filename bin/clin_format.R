# Fetch relevant clinical information and generate the data_patient.txt and data_sample.txt files for cbioportal

# Date extraction; date at which the data was extracted to calculate overall survival months

DATE_EXTRACTION=as.Date("05/20/2025",format = "%m/%d/%Y")

# Read in files

args = commandArgs(trailingOnly=TRUE)
sampleList=read.csv(args[1], header=F, sep=",")
patient_data=read.csv("../0_patient.csv", header=T, sep=",")
diagnostic_data=read.csv("../1_diagnostic.csv", header=T, sep=",")
specimen_data=read.csv("../5_specimen.csv", header=T, sep=",")
#followup_data=read.csv("../6_suivit.csv", header=T, sep=",")

# Format

colnames(sampleList)=c("patient", "sample")

# Patient data

colnames(patient_data)[1]="patient"
patient_data=patient_data[,c("patient","sex_at_birth","date_of_birth","is_deceased")]
patient_data$sex_at_birth=gsub("Female","F",patient_data$sex_at_birth)
patient_data$is_deceased=gsub("YES","1:DECEASED",patient_data$is_deceased)
patient_data$is_deceased=gsub("NO","0:LIVING",patient_data$is_deceased)

# Diagnostic data

colnames(diagnostic_data)[1]="patient"
diagnostic_data=diagnostic_data[,c("patient","date_of_diagnosis","cancer_type_code","clinical_stage_group","submitter_primary_diagnosis_id")]

# Multiple diagnostic dates so order by the first one to compute age at primary diagnosis

diagnostic_data=diagnostic_data[order(diagnostic_data$patient, diagnostic_data$date_of_diagnosis),]
diagnostic_data=diagnostic_data[!duplicated(diagnostic_data$patient), ]

# Specimen data

colnames(specimen_data)[1]="patient"
specimen_data=specimen_data[,c("patient","tumour_histological_type","submitter_primary_diagnosis_id")]

# Merge dataframes

m=merge(sampleList, patient_data, by='patient',all.x=TRUE)
m=merge(m,diagnostic_data, by='patient',all.x=TRUE)
m=merge(m,specimen_data, by='patient',all.x=TRUE)
m=m[(m$submitter_primary_diagnosis_id.x==m$submitter_primary_diagnosis_id.y) | is.na(m$submitter_primary_diagnosis_id.x), ]
m=subset(m, select = -c(submitter_primary_diagnosis_id.x,submitter_primary_diagnosis_id.y))

# Age at diagnosis, overall survival in months since initial diagnosis

m$age_at_diagnosis_years=as.numeric((as.Date(m$date_of_diagnosis)-as.Date(m$date_of_birth))/365)
m$age_at_diagnosis_years=round(m$age_at_diagnosis_years,3)
m$overall_survival_months[m$is_deceased == "1:DECEASED" | is.na(m$is_deceased)]=NA
m$overall_survival_months[m$is_deceased == "0:LIVING" & !is.na(m$is_deceased)]=as.numeric((as.Date(DATE_EXTRACTION)-as.Date(m$date_of_diagnosis[m$is_deceased == "0:LIVING" & !is.na(m$is_deceased)]))/30)
m$overall_survival_months=round(m$overall_survival_months,3)

# Fill in missing information for now

m$disease_free_survival_status=NA
m$disease_free_months=NA
m$sample_type="Primary"
m$cancer_type_details="NA"
m$tumour_site="NA"

# Fill empty values with NA

m[m==""]=NA

# Keep final columns

if(args[2]=="patient") {
	write.table(m[,c("patient","sex_at_birth","age_at_diagnosis_years","tumour_site","clinical_stage_group","tumour_histological_type","overall_survival_months","is_deceased","disease_free_survival_status","disease_free_months")], file = "", sep = "\t", row.names = FALSE, col.names=F, quote = FALSE)
} else if(args[2]=="sample") {
	write.table(m[,c("patient","sample","sample_type","cancer_type_details","cancer_type_code")], file = "", sep = "\t", row.names = FALSE, col.names=F, quote = FALSE)
}


