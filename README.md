# dbt_bigquery_template

Template repository for [dbt](https://www.getdbt.com/) + [BigQuery](https://cloud.google.com/bigquery) using [Dev Container](https://code.visualstudio.com/docs/devcontainers/containers) !

### Tools

- dbt
  - [dbt-bigquery](https://github.com/dbt-labs/dbt-bigquery)
  - [dbt-rpc](https://github.com/dbt-labs/dbt-rpc) for [dbt language server](https://marketplace.visualstudio.com/items?itemName=Fivetran.dbt-language-server)
- Python
- gcloud CLI
- Linter/Formatter
  - `sql`: [sqlfluff](https://github.com/sqlfluff/sqlfluff)
  - `python`: [black](https://github.com/psf/black)
  - `shell`: [shellcheck](https://github.com/koalaman/shellcheck)
  - `yaml`: TBD
  - `json`: TBD
  - `dockerfile`: TBD
- Utilities
  - [pre-commit](https://github.com/pre-commit/pre-commit)

### VSCode extensions

- [Wizard for dbt Core (TM)](https://marketplace.visualstudio.com/items?itemName=Fivetran.dbt-language-server)
- [BigQuery Runner](https://marketplace.visualstudio.com/items?itemName=minodisk.bigquery-runner)
- [sqlfluff](https://marketplace.visualstudio.com/items?itemName=dorzey.vscode-sqlfluff)
- [Bash IDE](https://marketplace.visualstudio.com/items?itemName=mads-hartmann.bash-ide-vscode)
- [Pylance](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance)

### Getting started

#### Authentication using gcloud CLI

dbt uses the Python client library to query BigQuery, so use the following command to generate [Application Default Credentials](https://cloud.google.com/docs/authentication/application-default-credentials). This command generates `$HOME/.config/gcloud/application_default_credentials.json`, which is mounted on devcontainer.

``` sh
gcloud auth application-default login
```

If you also want to run the gcloud CLI in your development workflow, also run:

``` sh
gcloud auth login
```

#### Create repository from template and open it from vscode

Create a new repository by clicking the ***"Use this template"*** button on github, then clone it to your local development environment. When you open the folder in vscode, a dialog will appear saying ***"Folder contains a Dev Container configuration file. Reopen folder to develop in a container."***. Ignore it for the moment until the following setup is complete.

#### Run initialization script

A script is provided to replace the project settings with your own settings. This is simply a `sed` substitution of a placeholder surrounded by `%%`.

Set the values of the arguments in the list below to suit your needs.

| Arguments  | Description  | Default |
|---|---|---|
| `-p`, `--dbt-project` | dbt project name | `dbt_bigquery_template` |
| `-P`, `--bq-project` | BigQuery project name for dev target | None |
| `-d`, `--bq-dataset` | BigQuery dataset name for dev target | `dbt_bigquery_template` |
| `-l`, `--bq-location` | BigQuery dataset location for dev target | `US` |


An example run is shown in:

``` sh
init.sh \
    --dbt-project="my_dbt_project" \
    --bq-project="my_bq_project" \
    --bq-dataset="my_bq_dataset" \
    --bq-location="US"
```

You can use this command to see which variables in which files will be replaced before the script is executed.

```sh
git grep -onE "%[A-Z_]+%" .
```

If you wish to rerun `init.sh`, git revert to the initial state.

#### Optional: Edit `.dbt/profiles.yml`

If you want to change BigQuery settings that are not replaced by `init.sh`, edit `.dbt/profiles.yml` manually.

#### Optional: Add python packages in `requirements.txt`

If you need additional python packages, or if you want to change the version of dbt, modify `requirements.txt`.

#### Optional: Enable pre-commit

To adapt linter/formatter at commit time, run the following command to enable `pre-commit`. Check .pre-commit-config.yml for the default pre-commit settings.

``` sh
pre-commit install
```

#### Re-open the folder in vscode using devcontainer

Run ctrl-p ***"Dev Container: Reopen in container"*** in vscode to reopen the project in devcontainer.

Now dbt development can be done in a container. Let's see if we can run `dbt compile`.

### Reference repository

- [davidgasquez/dbt-devcontainer](https://github.com/davidgasquez/dbt-devcontainer)
