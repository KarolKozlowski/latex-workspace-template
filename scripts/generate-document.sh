#!/usr/bin/env bash
set -euo pipefail

template_dir="templates"
output_dir="generated"
shopt -s nullglob

templates=()
# Check if a specific template was requested as an argument (vscode task)
if [[ $# -gt 0 ]]; then
  requested="$1"
  if [[ -f "${requested}" ]]; then
    templates=("${requested}")
  elif [[ -f "${template_dir}/${requested}" ]]; then
    templates=("${template_dir}/${requested}")
  elif [[ -f "${template_dir}/${requested}.tex" ]]; then
    templates=("${template_dir}/${requested}.tex")
  else
    echo "Template not found: ${requested}" >&2
    exit 1
  fi
else
  templates=()
  if [[ -d "${template_dir}" ]]; then
    templates+=("${template_dir}"/*.tex)
  fi
  templates+=(""*.tex)
fi

mkdir -p "${output_dir}"

for template in "${templates[@]}"; do
  base_name="$(basename "${template}" .tex)"
  output="${output_dir}/${base_name}.tex"


  data_file="${base_name}-data.yaml"
  if [[ -f "${data_file}" ]]; then
    pandoc \
      --from=markdown \
      --metadata-file="${data_file}" \
      --template="${template}" \
      --output="${output}" \
      /dev/null || { echo "Error generating ${output} from ${template}" >&2; exit 1; }
  else
    echo "Skipping ${template}: missing ${data_file}" >&2
    output="${template}"
  fi

  # double run to resolve image references
  pdflatex -output-directory "${output_dir}" "${output}"
  pdflatex -output-directory "${output_dir}" "${output}"
done
