process all_in_one {
  conda 'bf2raw_env.yml'

  maxForks params.maxConvJobs

  input:
  tuple val(dataset), path(imgfile)

  script:
  def outfile = "${dataset}/${imgfile.baseName}.zarr"
  """
  mkdir \"${dataset}\"
  
  bioformats2raw --memo-directory /tmp ${imgfile}  \"${outfile}\"

  aws --profile ${params.awsProfile} s3 sync  \"${dataset}\" \"s3://${params.bucket}/${dataset}\"

  rm -rf \"${dataset}\"
  """
}

workflow {
    image_paths = Channel
    .fromPath(params.input)
    .splitCsv(header:false, sep:"\t")
    .map { tuple( it[0].replaceAll('Dataset:name:',''), file(it[params.column]) ) }

    all_in_one(image_paths)
}
