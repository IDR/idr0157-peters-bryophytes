process all_in_one {
  conda 'v3_env.yml'

  maxForks params.maxConvJobs

  input:
  tuple val(dataset), path(imgfile)

  script:
  def outfile = "${dataset}/${imgfile.baseName}.zarr"
  """
  echo \"${outfile}\"
  """
}

workflow {
    image_paths = Channel
    .fromPath(params.input)
    .splitCsv(header:false, sep:"\t")
    .map { tuple( it[0].replaceAll('Dataset:name:',''), file(it[params.column]) ) }

    all_in_one(image_paths)
}
