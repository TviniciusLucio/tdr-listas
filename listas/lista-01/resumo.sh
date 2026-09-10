#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <arquivo.csv> <numero_da_coluna>" >&2
    exit 1
fi

arquivo="$1"
coluna="$2"

if [ ! -f "$arquivo" ]; then
    echo "Erro: arquivo '$arquivo' nao encontrado." >&2
    exit 1
fi

# 1. Nome da coluna lido do cabecalho
nome_coluna=$(head -n 1 "$arquivo" | awk -F, -v c="$coluna" '{gsub(/"/, "", $c); print $c}')

# 2. Numero de observacoes (excluindo o cabecalho)
total_obs=$(( $(wc -l < "$arquivo") - 1 ))

# 3. Quantidade de NAs na coluna
total_na=$(tail -n +2 "$arquivo" | awk -F, -v c="$coluna" '$c == "NA" {count++} END {print count+0}')

echo "Coluna: $nome_coluna"
echo "Observações: $total_obs"
echo "Valores NA: $total_na"
echo ""
echo "Media por mes:"
echo "Mes | Dias Medidos | Media"

# 4. Media por mes ignorando NAs (Month eh a coluna 5)
tail -n +2 "$arquivo" | awk -F, -v c="$coluna" '
$c != "NA" {
    soma[$5] += $c
    dias[$5]++
}
END {
    for (m = 5; m <= 9; m++) {
        if (m in soma && dias[m] > 0) {
            printf "%3d | %12d | %.2f\n", m, dias[m], soma[m] / dias[m]
        }
    }
}'
