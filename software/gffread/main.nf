// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]
def options    = initOptions(params.options)

process GFFREAD {
    tag "$gff"
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), publish_id:'') }

    conda (params.enable_conda ? "bioconda::gffread=0.12.1=h8b12597_0" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/gffread:0.12.1--h8b12597_0"
    } else {
        container "quay.io/biocontainers/gffread:0.12.1--h8b12597_0"
    }

    input:
    path gff

    output:
    path "*.gtf"        , emit: gtf
    path "*.version.txt", emit: version

    script:
    def software = getSoftwareName(task.process)
    """
    gffread $gff $options.args -o ${gff.baseName}.gtf
    echo \$(gffread --version 2>&1) > ${software}.version.txt
    """
}