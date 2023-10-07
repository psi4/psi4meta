FROM ghcr.io/mamba-org/micromamba

ARG CondaFile

COPY --chown=$MAMBA_USER:$MAMBA_USER ./${CondaFile} /tmp/${CondaFile}

RUN micromamba install --yes -n base --file /tmp/${CondaFile} && micromamba clean --all --yes
ARG MAMBA_DOCKERFILE_ACTIVATE=1

ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]
