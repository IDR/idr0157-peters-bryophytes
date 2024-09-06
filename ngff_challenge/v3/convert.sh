#!/bin/bash

set -euo pipefail

if [ "$#" -ne 5 ]; then
    echo "Usage:"
    echo "./convert.sh <DATASET_NAME> <IMAGE_FILE_BASENAME> <INPUT_BUCKET> <OUTPUT_BUCKET> <AWS_PROFILE>"
    echo "Example:"
    echo "./convert.sh 'Asterella gracilis SWE' 'IMG_0005 Asterella gracilis (Mannia gracilis) voucher specimen.ome' 'idr/zarr/v0.4/idr0157' 'idr/share/ome2024-ngff-challenge/idr0157' 'embassy'"
    exit 1
fi

dataset=$1
image=$2
inbucket=$3
outbucket=$4
awsprofile=$5

ncbi=`grep "$dataset,$image" /tmp/idr0157-experimentA-annotation.csv | cut -d , -f5`

mkdir in out

aws --profile ${awsprofile} s3 cp --recursive --no-sign-request \
"s3://${inbucket}/${dataset}/${image}.zarr" \
"in/${dataset}/${image}.zarr"

ome2024-ngff-challenge resave \
"in/${dataset}/${image}.zarr/0" \
"out/${dataset}/${image}.zarr" \
--log info \
--rocrate-organism=NCBI:txid${ncbi} \
--rocrate-name="idr0157 Peters Bryophytes: ${image}.zarr" \
--rocrate-description="Estimating essential phenotypic and molecular traits from integrative biodiversity data" \
--cc-by \
--output-shards=1,3,1,1024,1024 \
--output-chunks=1,1,1,1024,1024 \
--silent

cd out
aws --profile ${awsprofile} s3 sync \
"${dataset}" \
"s3://${outbucket}/${dataset}"

cd ..
rm -rf in out
