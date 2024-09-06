# NGFF challenge conversion

There are two nextflow workflows for converting this dataset for the OME2024 NGFF challenge,
bf2raw for converting the original files to ome.zarr (zarr version 2) and v3 for updating them
to zarr version 3.

###  Prerequisite

#### Install Nextflow:
(For details see [Nextflow - Installation](https://www.nextflow.io/docs/latest/install.html))

Install java:
```
curl -s https://get.sdkman.io | bash
sdk install java 17.0.10-tem
```

Get nextflow binary:
```
curl -s https://get.nextflow.io | bash
chmod +x nextflow
```

Additionally:

#### Install conda:
(For details see [Installing Miniconda](https://docs.anaconda.com/miniconda/miniconda-install/))
```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

#### Install AWS cli
(For details see [conda-forge / packages / awscli](https://anaconda.org/conda-forge/awscli))
```
conda install awscli
```

#### Setup AWS access

For the EBI Embassy object storage
```
aws configure --profile embassy
echo "endpoint_url = https://uk1s3.embassy.ebi.ac.uk" >> ~/.aws/config 
```

## bf2raw

Adjust the workdir in `nextflow.config`.

Run it with:
```
nextflow run --input idr0157-experimentA-filePaths.tsv --column 1 bf2raw.nf
```

This will convert and upload the images to:
`https://uk1s3.embassy.ebi.ac.uk/idr/zarr/v0.4//idr0157/<DATASET NAME>/<IMAGE NAME>/`

## v3

Adjust the workdir in `nextflow.config`.

Copy `idr0157-experimentA-annotation.csv` to `/tmp/`.

Add the `convert.sh` to your `$PATH`.

Run it with:
```
nextflow run --input idr0157-experimentA-filePaths.tsv --column 1 v3.nf
```

This will convert the images to zarr version 3 and upload to:
`https://uk1s3.embassy.ebi.ac.uk/idr/share/ome2024-ngff-challenge/idr0157/<DATASET NAME>/<IMAGE NAME>/`
