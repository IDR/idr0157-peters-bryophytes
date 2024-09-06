process all_in_one {
  conda 'v3_env.yml'

  maxForks params.maxConvJobs

  input:
  tuple val(dataset), path(imgfile)

  script:
  def ncbi="NCBI:txid"
  """
  ncbi=`grep "$dataset|${imgfile.baseName}.tiff" ${params.organismfile} | cut -d \"|\" -f3`

  mkdir in out
  aws --profile embassy s3 cp --recursive --no-sign-request \
  \"s3://${params.inbucket}/${dataset}/${imgfile.baseName}.zarr\" \
  \"in/${dataset}/${imgfile.baseName}.zarr\"

  ome2024-ngff-challenge resave \
  \"in/${dataset}/${imgfile.baseName}.zarr/0\" \
  \"out/${dataset}/${imgfile.baseName}.zarr\" \
  --log debug \
  --rocrate-organism=${ncbi} \
  --rocrate-name=\"idr0157 Peters Bryophytes: ${imgfile.baseName}.zarr\" \
  --rocrate-description=\"Estimating essential phenotypic and molecular traits from integrative biodiversity data\" \
  --cc-by \
  --output-shards=1,3,1,1024,1024 \
  --output-chunks=1,1,1,1024,1024

  cd out
  aws --profile ${params.awsProfile} s3 sync \
  \"${dataset}\" \
  \"s3://${params.outbucket}/${dataset}\"

  cd ..
  rm -rf in out
  """
}

workflow {
    image_paths = Channel
    .fromPath(params.input)
    .splitCsv(header:false, sep:"\t")
    .map { tuple( it[0].replaceAll('Dataset:name:',''), file(it[params.column]) ) }

    all_in_one(image_paths)
}
