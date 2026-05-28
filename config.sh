#!/bin/bash

######################### 1_GET_ACCESSIONS.SH ###########################

# BIOPROJECT:
# NCBI BioProject accession ID to query.
# This identifier is used to retrieve all associated BioSample and SRA
# run accessions (SRR IDs) for downstream download and processing.
# NOTE: This variable MUST be set before running the pipeline.
BIOPROJECT=""