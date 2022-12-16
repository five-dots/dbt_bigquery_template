ARG VARIANT=3.9
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

# Install python packages from requirements.txt
COPY requirements.txt /tmp/pip-tmp/
RUN pip3 install --upgrade pip wheel setuptools \
    && pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
    && rm -rf /tmp/pip-tmp