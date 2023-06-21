\# Use a base image with CentOS 7

FROM centos:7

 

\# Set the working directory

WORKDIR /app

 

\# Install required packages

RUN yum update -y && yum install -y \

  wget \

  unzip \

  gcc \

  make \

  zlib-devel \

  glibc-devel

 

\# Download and install HISAT2

RUN wget https://github.com/DaehwanKimLab/hisat2/archive/refs/tags/v2.2.1.tar.gz \

  && tar -zxvf v2.2.1.tar.gz \

  && cd hisat2-2.2.1 \

  && make && make install \

  && cd ..

 

\# Download and install SAMtools

RUN wget https://github.com/samtools/samtools/releases/download/1.13/samtools-1.13.tar.bz2 \

  && tar -xjvf samtools-1.13.tar.bz2 \

  && cd samtools-1.13 \

  && ./configure && make && make install \

  && cd ..

 

\# Download and install StringTie

RUN wget https://github.com/gpertea/stringtie/archive/refs/tags/v2.1.7.tar.gz \

  && tar -zxvf v2.1.7.tar.gz \

  && cd stringtie-2.1.7 \

  && make && make install \

  && cd ..

 

\# Install R

RUN yum install -y epel-release \

  && yum install -y R

 

\# Download reference genome and annotation files

RUN wget http://example.com/chrX_data/reference_genome.fa \

  && wget http://example.com/chrX_data/genes/chrX.gtf \

  && wget http://example.com/chrX_data/geuvadis_phenodata.csv \

  && wget http://example.com/chrX_data/mergelist.txt

 

\# Copy the sample data

COPY chrX_data /app/chrX_data

 

\# Map the reads to the genome and convert SAM to BAM

RUN hisat2 -p 8 --dta -x chrX_data/indexes/chrX_tran -1 chrX_data/samples/ERR188044_chrX_1.fastq.gz -2 chrX_data/samples/ERR188044_chrX_2.fastq.gz -S ERR188044_chrX.sam \

  && samtools sort -@ 8 -o ERR188044_chrX.bam ERR188044_chrX.sam

 

\# Repeat the above steps for other samples

RUN hisat2 -p 8 --dta -x chrX_data/indexes/chrX_tran -1 chrX_data/samples/ERR188104_chrX_1.fastq.gz -2 chrX_data/samples/ERR188104_chrX_2.fastq.gz -S ERR188104_chrX.sam \

  && samtools sort -@ 8 -o ERR188104_chrX.bam ERR188104_chrX.sam \

  && hisat2 -p 8 --dta -x chrX_data/indexes/chrX_tran -1 chrX_data/samples/ERR188234_chrX_1.fastq.gz -2 chrX_data/samples/ERR188234_chrX_2.fastq.gz -S ERR188234_chrX.sam \

  && samtools sort -@ 8 -o ERR188234_chrX.bam ERR188234_chrX.sam \

  && hisat2 -p 8 --dta -x chrX_data/indexes/chrX_tran -1 chrX_data/samples/ERR188337_chrX_1.fastq.gz -2 chrX_data/samples/ERR188337_chrX_2.fastq.gz -S ERR188337_chrX.sam \

  && samtools sort -@ 8 -o ERR188337_chrX.bam ERR188337_chrX.sam

 

\# Sort and convert the SAM files to BAM for all samples

RUN for file in chrX_data/*.sam; do \

​    base=$(basename "$file" .sam); \

​    samtools sort -@ 8 -o "$base.bam" "$file"; \

  done

 

\# Assemble transcripts for each sample

RUN for file in chrX_data/*.bam; do \

​    base=$(basename "$file" .bam); \

​    stringtie -p 8 -G chrX.gtf -o "$base.gtf" -l "$base" "$file"; \

  done

 

\# Merge transcripts from all samples

RUN stringtie --merge -p 8 -G chrX.gtf -o stringtie_merged.gtf mergelist.txt

 

\# Examine transcript comparison with reference annotation

RUN gffcompare -r chrX.gtf -G -o merged stringtie_merged.gtf

 

\# Copy the R script for differential expression analysis

COPY analysis.R /app/analysis.R

 

\# Run R script for differential expression analysis

RUN Rscript /app/analysis.R

 

\# Set the entry point (change it according to your needs)

ENTRYPOINT ["/bin/bash"]