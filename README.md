# ☁️ Automação do Desafio GSP329 - Usar APIs de ML no Google Cloud

Bem-vindos ao repositório de suporte para o laboratório **GSP329**! 
Este script foi construído para automatizar a criação da Conta de Serviço (Service Account), atribuir os perfis corretos do IAM, baixar a chave JSON de autenticação e executar o script Python que interage com as APIs Vision e Translation.

## 📋 Pré-requisitos
Antes de executar o script, leia as instruções no painel lateral esquerdo e no texto do seu laboratório e anote **exatamente** o que for pedido:
1. **LANGUAGE** (Geralmente é *en*, *fr*, *es*, etc.)
2. **LOCALE** (Geralmente é *en_US*, *fr_FR*, *ja*, etc.)
3. **Papel (Role) do BigQuery** (Copie o texto exato do laboratório, ex: *roles/bigquery.dataOwner* ou *roles/bigquery.admin*)
4. **Papel (Role) do Cloud Storage** (Copie o texto exato do laboratório, ex: *roles/storage.admin*)

## ☁️ Como executar no Cloud Shell:

```bash
curl -LO https://raw.githubusercontent.com/Philippe-C-S-Brito/Resolucao_Desafio_GSP329_Google_Cloud/main/ml_desafio.sh
sudo chmod +x ml_desafio.sh
./ml_desafio.sh
```
🎯 Passos para o Sucesso
Copie o bloco de código acima.

Abra o Cloud Shell no console do Google Cloud e cole o comando.

Aperte ENTER. O script vai pausar e pedir as 4 informações que você anotou. Cole-as com cuidado.

Aviso: O script fará uma pausa obrigatória de 60 segundos para o IAM. Não cancele!

Quando o script finalizar, a tabela do BigQuery será exibida na sua tela.

Volte ao painel do laboratório e clique nos botões Verificar meu progresso!

Boa sorte
