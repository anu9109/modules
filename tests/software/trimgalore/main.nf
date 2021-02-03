#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { TRIMGALORE } from '../../../software/trimgalore/main.nf' addParams( options: [:] )

/*
 * Test with single-end data
 */
workflow test_trimgalore_single_end {

    def input = []
    input = [ [ id:'test', single_end:true ], // meta map
            [ file("${launchDir}/tests/data/fastq/rna/test_single_end.fastq.gz", checkIfExists: true) ] ]
    TRIMGALORE ( input )
}

/*
 * Test with paired-end data
 */
workflow test_trimgalore_paired_end {

    def input = []
    input = [ [ id:'test', single_end:false ], // meta map
            [ file("${launchDir}/tests/data/fastq/rna/test_R1.fastq.gz", checkIfExists: true),
                file("${launchDir}/tests/data/fastq/rna/test_R2.fastq.gz", checkIfExists: true) ] ]

    TRIMGALORE ( input )
}