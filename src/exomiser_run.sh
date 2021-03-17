#!/bin/bash
# samtools_count_binary_sh 0.0.1

#
# SECTION: Download bam files
# ------------------
# Use dx download to download the bam file. $mappings_bam is a dx_link
# containing the file_id of that file. By default, when we download a file,
# we will keep the filename of the object on the platform.
#
dx download "${input_vcf}"
dx download "${dict_file}"
#
# SECTION: Run samtools view
# -----------------
# Here, we use the bash helper variable mappings_bam_name. For file inputs,
# we will set a bash variable [VARIABLE]_name which holds a string representing
# the filename of the object on the platform. Because we have downloaded the
# file by default above, this will be the filename of the object on this
# worker as well. We further use [VARIABLE]_prefix, which will be the filename
# of the object, removing any suffices specified in patterns. In this case,
# the pattern if '["*.bam"]', so it will remove the trailing ".bam".
#
# In the case that the filename of the file mappings_bam is "my_mappings.bam",
# mappings_bam_prefix will be "my_mappings"
#
echo "${dict_file_name}"
echo "${input_vcf_name}"

apt-get update -y
apt-get install -y default-jdk
java -jar /usr/bin/picard.jar SortVcf SEQUENCE_DICTIONARY="${dict_file_name}" I="${input_vcf_name}" O="${input_vcf_prefix}_sorted.vcf"
echo "${input_vcf_prefix}_sorted.vcf"

bgzip -c "${input_vcf_prefix}_sorted.vcf" > "${input_vcf_prefix}_sorted.vcf.gz"
echo "${input_vcf_prefix}_sorted.vcf.gz"

tabix -p vcf "${input_vcf_prefix}_sorted.vcf.gz"
echo "${input_vcf_prefix}_sorted.vcf.gz.tbi"


#dx upload "${input_vcf_prefix}.vcf.gz"
#
# SECTION: Upload result
# -------------
# We now upload the data to the platform. This will upload it into the
# job container, a temporary project which holds onto files associated
# with the job. when running upload with --brief, it will return just the
# file-id.
#
#counts_txt_id=$(dx upload "${mappings_bam_prefix}.txt" --brief)

gzip_file_id=$(dx upload "${input_vcf_prefix}_sorted.vcf.gz" --brief)
echo "${gzip_file_id}"

tbi_file_id=$(dx upload "${input_vcf_prefix}_sorted.vcf.gz.tbi" --brief)
echo "${tbi_file_id}"


#sorted_file_id=$(dx upload "${input_vcf_name}_sorted" --brief)
#echo "${sorted_file_id}"

#
# SECTION: Associate with output
# ---------------------
# Finally, we tell the system what file should be associated with the output
# named counts_txt (which was specified in the dxapp.json). The system will then
# move this output into whatever folder was specified at runtime in the project
# running the job.
#
# dx-jobutil-add-output counts_txt "${counts_txt_id}" --class=file
#
dx-jobutil-add-output gzip_file "${gzip_file_id}" --class=file
dx-jobutil-add-output tbi_file "${tbi_file_id}" --class=file
#dx-jobutil-add-output sorted_file "${sorted_file_id}" --class=file
