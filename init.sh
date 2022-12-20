#!/usr/bin/env bash

set -o errexit
set -o pipefail

# $ TRACE=1 ./init.sh
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

# Parse command line arguments
# https://chitoku.jp/programming/bash-getopts-long-options
while getopts p:P:d:l:v-: opt; do
    optarg="${OPTARG}"
    if [[ "$opt" = - ]]; then
        opt="-${OPTARG%%=*}"
        optarg="${OPTARG/${OPTARG%%=*}/}"
        optarg="${optarg#=}"

        if [[ -z "${optarg}" ]] && [[ ! "${!OPTIND}" = -* ]]; then
            optarg="${!OPTIND}"
            shift
        fi
    fi

    case "-${opt}" in
        -p|--dbt-project)
            p="${optarg}"
            ;;
        -P|--bq-project)
            P="${optarg}"
            ;;
        -d|--bq-dataset)
            d="${optarg}"
            ;;
        -l|--bq-location)
            l="${optarg}"
            ;;
        -v|--version)
            echo 'v0.1.0'
            exit
            ;;
        --)
            break
            ;;
        -\?)
            exit 1
            ;;
        --*)
            echo "${0}: illegal option -- ${opt##-}" >&2
            exit 1
            ;;
    esac
done

# Check if mandatory arguments are set
if [[ -z "${P}" ]]; then
    echo "BigQuery project not set. Use --bq-project arg."
    exit 1
fi

# Script's directory
dir="$(cd "$(dirname "${BASH_SOURCE[0]:-${0}}")" && pwd -P)"

# Default values
readonly default_dbt_project="dbt_bigquery_template"
readonly default_bq_dataset="${default_dbt_project}"
readonly default_bq_location="US"

dbt_project=${p:-${default_dbt_project}}
bq_project=${P:-${default_bq_project}}
bq_dataset=${d:-${default_bq_dataset}}
bq_location=${l:-${default_bq_location}}

echo "${dbt_project}"
echo "${bq_project}"
echo "${bq_dataset}"
echo "${bq_location}"

# dbt_project.yml
sed -e "s/%DBT_PROJECT%/${dbt_project}/g" \
    -i "${dir}/dbt_project.yml"

# .dbt/profiles.yml
sed -e "s/%BQ_PROJECT%/${bq_project}/g" \
    -e "s/%BQ_DATASET%/${bq_dataset}/g" \
    -e "s/%BQ_LOCATION%/${bq_location}/g" \
    -i "${dir}/.dbt/profiles.yml"


