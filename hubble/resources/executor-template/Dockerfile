ARG GPTC_VERSION=latest

FROM gptcomputer/gptc:${GPTC_VERSION}

# install requirements before copying the workspace
COPY requirements.txt /requirements.txt
RUN pip install --default-timeout=1000 --compile -r requirements.txt

# setup the workspace
COPY . /workdir/
WORKDIR /workdir

ENTRYPOINT ["gptc", "executor", "--uses", "config.yml"]