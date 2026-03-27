#!/bin/bash

# Definição de Cores
CYAN_TEXT=$'\033[0;96m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
MAGENTA_TEXT=$'\033[0;95m'
BLUE_TEXT=$'\033[0;94m'
WHITE_TEXT=$'\033[0;97m'
RESET_FORMAT=$'\033[0m'
BOLD_TEXT=$'\033[1m'

clear

echo "${CYAN_TEXT}${BOLD_TEXT}==================================================================${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}          INICIANDO A EXECUÇÃO DO LABORATÓRIO GSP329...           ${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}==================================================================${RESET_FORMAT}"
echo

echo "${MAGENTA_TEXT}${BOLD_TEXT}Preencha as informações conforme solicitado nas instruções do laboratório:${RESET_FORMAT}"
read -p "$(echo -e "${YELLOW_TEXT}${BOLD_TEXT}1. Digite a LANGUAGE (Idioma de tradução, ex: en, fr, es): ${RESET_FORMAT}")" LANGUAGE
read -p "$(echo -e "${YELLOW_TEXT}${BOLD_TEXT}2. Digite o LOCALE (Localidade, ex: en_US, fr_FR, ja): ${RESET_FORMAT}")" LOCALE
read -p "$(echo -e "${YELLOW_TEXT}${BOLD_TEXT}3. Papel do BigQuery exigido (ex: roles/bigquery.dataOwner): ${RESET_FORMAT}")" BQ_ROLE
read -p "$(echo -e "${YELLOW_TEXT}${BOLD_TEXT}4. Papel do Cloud Storage exigido (ex: roles/storage.admin): ${RESET_FORMAT}")" CS_ROLE
echo

# Variáveis Padronizadas
SA_NAME="ml-lab-sa"
SA_EMAIL="${SA_NAME}@${DEVSHELL_PROJECT_ID}.iam.gserviceaccount.com"
KEY_FILE="ml-sa-key.json"

echo -e "${GREEN_TEXT}${BOLD_TEXT}⚙️  Configurando Ambiente e Permissões...${RESET_FORMAT}"
echo "-> Habilitando as APIs (Vision, Translate, BigQuery)..."
gcloud services enable vision.googleapis.com translate.googleapis.com bigquery.googleapis.com --quiet

echo "-> Criando Conta de Serviço (Service Account)..."
gcloud iam service-accounts create ${SA_NAME} --display-name="ML APIs Challenge Lab SA" 2>/dev/null || true

echo "-> Atribuindo permissões exatas do IAM exigidas pelo laboratório..."
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:$SA_EMAIL --role=$BQ_ROLE --quiet >/dev/null
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:$SA_EMAIL --role=$CS_ROLE --quiet >/dev/null
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:$SA_EMAIL --role=roles/serviceusage.serviceUsageConsumer --quiet >/dev/null

echo -e "\n${YELLOW_TEXT}${BOLD_TEXT}⏳ Aguardando a propagação do IAM (Pausa de 60 segundos obrigatória)...${RESET_FORMAT}"
for i in {1..60}; do
    echo -ne "${YELLOW_TEXT}Aguardando: ${i}/60 segundos...\r${RESET_FORMAT}"
    sleep 1
done
echo -e "\n"

echo "-> Gerando e exportando as credenciais (JSON)..."
rm -f ${KEY_FILE}
gcloud iam service-accounts keys create ${KEY_FILE} --iam-account=$SA_EMAIL --quiet
export GOOGLE_APPLICATION_CREDENTIALS="${PWD}/${KEY_FILE}"

echo -e "\n${YELLOW_TEXT}${BOLD_TEXT}🔐 Sincronizando Chave de Autenticação com o Google Cloud...${RESET_FORMAT}"
for i in {1..30}; do
    if python3 -c "from google.cloud import storage; storage.Client().bucket('${DEVSHELL_PROJECT_ID}').exists()" 2>/dev/null; then
        echo -e "${GREEN_TEXT}${BOLD_TEXT}✓ Chave reconhecida e sincronizada com sucesso!${RESET_FORMAT}"
        break
    fi
    echo -ne "${YELLOW_TEXT}Aguardando servidores de autenticação... (Tentativa ${i}/30)\r${RESET_FORMAT}"
    sleep 5
done

echo -e "\n${BLUE_TEXT}${BOLD_TEXT}🧠 Configurando e Executando o Código de Inteligência Artificial...${RESET_FORMAT}"
echo "-> Baixando o script de análise de imagens homologado..."
wget -q -O analyze-images-v2.py https://raw.githubusercontent.com/guys-in-the-cloud/cloud-skill-boosts/main/Challenge-labs/Integrate%20with%20Machine%20Learning%20APIs%3A%20Challenge%20Lab/analyze-images-v2.py

echo "-> Ajustando o idioma local do script para ${LOCALE}..."
sed -i "s/'en'/'${LOCALE}'/g" analyze-images-v2.py

echo -e "${MAGENTA_TEXT}${BOLD_TEXT}-> Processando imagens (Isso pode levar de 1 a 3 minutos)...${RESET_FORMAT}"
python3 analyze-images-v2.py $DEVSHELL_PROJECT_ID $DEVSHELL_PROJECT_ID

echo -e "\n${CYAN_TEXT}${BOLD_TEXT}📊 Consultando a distribuição de idiomas no BigQuery...${RESET_FORMAT}"
bq query --use_legacy_sql=false "SELECT locale,COUNT(locale) as lcount FROM image_classification_dataset.image_text_detail GROUP BY locale ORDER BY lcount DESC"

echo ""
echo "${GREEN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}            LABORATÓRIO CONCLUÍDO COM SUCESSO!         ${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"
echo "${WHITE_TEXT}Volte ao painel do laboratório e clique em${RESET_FORMAT}"
echo "${WHITE_TEXT}'Verificar meu progresso' em todas as tarefas.${RESET_FORMAT}"
echo ""