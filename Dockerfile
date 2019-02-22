# This Dockerfile was generated by tools/build.sh
FROM nfcore/base

LABEL authors="rickard.hammaren@scilifelab.se, phil.ewels@scilifelab.se, martin.proks@scilifelab.se" \
    description="Docker image containing all requirements for nfcore/rnafusion pipeline"

COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH /opt/conda/envs/nf-core-rnafusion-1.0.1/bin:$PATH

WORKDIR /script-db
# Download FusionGDB
RUN apt-get update && apt-get install -y wget \
    && wget --no-check-certificate https://ccsm.uth.edu/FusionGDB/tables/TCGA_ChiTaRS_combined_fusion_information_on_hg19.txt -O TCGA_ChiTaRS_combined_fusion_information_on_hg19.txt \
    && wget --no-check-certificate https://ccsm.uth.edu/FusionGDB/tables/TCGA_ChiTaRS_combined_fusion_ORF_analyzed_gencode_h19v19.txt -O TCGA_ChiTaRS_combined_fusion_ORF_analyzed_gencode_h19v19.txt \
    && wget --no-check-certificate https://ccsm.uth.edu/FusionGDB/tables/uniprot_gsymbol.txt -O uniprot_gsymbol.txt \
    && wget --no-check-certificate https://ccsm.uth.edu/FusionGDB/tables/fusion_uniprot_related_drugs.txt -O fusion_uniprot_related_drugs.txt \
    && wget --no-check-certificate https://ccsm.uth.edu/FusionGDB/tables/fusion_ppi.txt -O fusion_ppi.txt \
    && wget --no-check-certificate https://ccsm.uth.edu/FusionGDB/tables/fgene_disease_associations.txt -O fgene_disease_associations.txt \
    && ln -s /opt/conda/envs/nf-core-rnafusion-1.0.1/bin/python3 /bin/python3

COPY ./FusionGDB.sql .
RUN sqlite3 fusions.db < FusionGDB.sql

WORKDIR /