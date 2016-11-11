---
title: Documentação API de Credenciamento Stone

language_tabs:
  - JSON

search: true
---

# Introdução

Bem-vindo à documentação da API de Credenciamento da Stone Pagamentos S.A.

Aqui estão documentadas a operação responsável por realizar o credenciamento de um estabelecimento comercial e a operação que possibilita a consulta de estabelecimentos credenciados para fins de acompanhamento.

Alguns campos possuem uma variedade de valores possíveis e que podem sofrer atualizações com certa frequência. Por isso, disponibilizamos também algumas operações de consulta para esses valores que podem ser utilizados como apoio para o preenchimento da solicitação de credenciamento.

Todos as requisições devem ser feitas usando o verbo **HTTP POST**.
No corpo, deve ser enviado um objeto **JSON**.
As informações de credencial devem ser enviadas no corpo da requisição. Veja a seção [Autenticação](doc:autenticacao) para saber como solicitar e como informar sua credencial.
Todas as requisições processadas pela API de credenciamento devem retornar uma resposta em JSON que descreve o sucesso ou falha da operação. Independente do resultado, a resposta sempre possui HTTP status code **200 OK**.

# Autenticação

## Solicite sua credencial

Para começar sua integração com a API de Credenciamento da Stone, algumas informações básicas deverão ser fornecidas para o time de Integrações (**integracoes@stone.com.br**). São elas:

  * O nome da empresa parceira que realizará credenciamentos na Stone
  * Uma descrição sucinta do negócio parceiro (em uma frase)
  * O colaborador da Stone pelo qual a integração está sendo realizada
  * Email para onde a credencial deve ser enviada

Uma credencial será enviada para o email informado e possui o seguinte formato:

| | |
|------------|-------------------------------------------------------------------|
| **UserId** | GUID que identifica a aplicação cliente da API de Credenciamento. | 
| **Secret key** | Chave a ser mantida em segurança para geração da assinatura. |

## Como informar sua credencial

Ao realizar chamadas à API de Credenciamento, a integração deverá informar o id da aplicação cliente (UserId) e a assinatura (Signature) em um objeto de credencial.
A assinatura é um HMAC gerado com algoritmo SHA-512 e com a secret key da credencial. O conteúdo a ser codificado é definido por cada operação.
Abaixo, um exemplo:

>O que eu informo

```json

{
  "UserId": "B1A00B80-2514-4991-9EC9-07B8B230CBEB",
  "Signature": "bd9eb4521b7a5b9c65f549b1ae524684247963e33dd673ec120faf79353fe0d1669689baf9a0594af659c253ab2dfd21a3b90efb25240fdd8142f242bf304d64"
}

```

**O que eu tenho**

* UserId:                "B1A00B80-2514-4991-9EC9-07B8B230CBEB"

* Secret key:            "8A085D315DBB1F17DA64DE235D6F8BC493FE4B78"

* Conteúdo a codificar:  "Encode this"

<aside class="notice">
A geração do HMAC é case-sensitive. Portanto, utilize a secret key e o conteúdo a ser codificado exatamente como especificado.
</aside>

<aside class="warning">
Nunca informe sua secret key nas chamadas à API de Credenciamento.
</aside>


# POST/ Affiliate

>Exemplo de request

```json

{
  "Credential": {
    "UserId": "xxxx",
    "Signature": "xxxx"
  },
  "BypassCreditAnalysis": "false",
  "Merchant": {
    "BankAccountList": [{
      "AccountNumber": "000000",
      "AccountVerificationCode": "0",
      "BankBranchCode": "0000",
      "BankIdentifier": "000",
      "BranchVerificationCode": "0",
      "CardBrand": 0
    }],
    "CompanyName": "xxxx",
    "TradeName": "xxxx",
    "DocumentNumber": "00000000000000",
    "DocumentType": 0,
    "Mcc": 0000,
    "MdrNegotiationList": [{
      "CardBrand": 00,
      "Rate": 00.00,
      "TransactionProfile": 00
    },
    {
      "CardBrand": 00,
      "Rate": 00.00,
      "TransactionProfile": 00
    }],
    "MerchantAddress": {
      "City": "xxxx",
      "Complement": "xxxx",
      "Country": 000,
      "Neighborhood": "xxxx",
      "PostalCode": "00000000",
      "StateCode": "xx",
      "StreetName": "xxxx",
      "StreetNumber": "000"
    },
    "MerchantCaptureMethodList": [{
      "TerminalTypeId": 0,
      "TerminalModelId": 0,
      "SerialNumber": “xxx”,
      "MobileCarrierId": 0,
      "Url": "xxxx"
    }],
    "MerchantContactList": [{
      "ContactName": "xxxx",
      "Email": "xxxx@xxxx.com",
      "MobilePhoneNumber": "xxxxxxxxxx",
      "PhoneNumber": "xxxxxxxxxxx"
    }],
    "MerchantExtraDataList": [{
      "Key": "xxxx",
      "Value": "xxxx "
    }],
    "SalesChannelId": 0,
    "SalesPartnerId": 0,
    "SalesTeamMemberId": 0,
    "MerchantWorkScheduleList":[{
      "Id": 0,
      "Open24h": false,
      "OpenWeekday": "23:59",
      "CloseWeekday": "23:59",
      "OpenSaturday": "23:59",
      "CloseSaturday": "23:59",
      "OpenSunday": "23:59",
      "CloseSunday": "23:59",
      "OpenHoliday": "23:59",
      "CloseHoliday": "23:59"
    }],
    "ChainTypeIdList":[0],
    "ParentChainList":[{
      "TypeId":0,
      "ChainIdentifier":"xxxxxxxx"
    }]
  }
}

```
>Exemplo de Resposta

>200 OK

```json

{
  "Status": {
    "Code": "OK",
    "Message": "OK",
    "MessageRefCode": "TXT_OK"
  },
  "MessageList": [],
  "MerchantReturn": {
    "StoneCode": "000000000",
    "AffiliationKey": "xxxx",
    "Mcc": 0000,
    "MdrInfoList": [{
      "CardBrand": 0,
      "CardBrandName": "xxxx",
      "TransactionProfile": 0,
      "TransactionProfileName": "xxxx",
      "Rate": 0.00
    }],
    "MerchantStatus": 0,
    "CaptureMethodList": [{
      "SaleAffiliationKey": "xxxx",
      "TerminalTypeId": 0
    }]
  }
}

```

>200 Internal Error

```json

{
  "Status": {
    "Code": "INTERNAL_ERROR",
    "Message": "xxxx",
    "MessageRefCode": "MSG_INTERNAL_ERROR"
  },
  "MessageList": [],
  "MerchantReturn": {}
}

```

### Operação responsável pelo credenciamento do estabelecimento comercial.

**Endpoint**
https://affiliation-staging.stone.com.br/Merchant/MerchantService.svc/Merchant/Affiliate/

**Parâmetros**

| Campo | Tipo | Obrigatório |
|-------|------|-------------|
| Credential | object UserCredential | sim |
| CompanyName | string CompanyName | sim |
| TradeName | string TradeName | sim |
| DocumentNumber | string DocumentNumber| sim |
| DocumentType | integer DocumentType| sim |
| AccountEmail | string AccountEmail | não |
| BankAccountList | array of objects BankAccount | sim |
| MerchantAdressList | array of objects MerchantAddress | sim |
| MerchantCaptureMethodList | array of objects MerchantCaptureMethod | sim |
| MerchantContactList | array of objects MerchantContact | sim |
| Mcc | integer | sim |
| MdrNegotiationList | array of objects MdrNegotiation | não |
| MerchantPatternList | array of objects MerchantPattern | não |
| SalesChannelId | integer | não |
| SalesPartnerId | integer | não |
| SalesTeamMemberId | integer | não |
| MerchantWorkScheduleList | array of objects MerchantWorkSchedule | não |
| ChainTypedIdList | array of integers ChainType | não |
| ParentChainList | array of objects ParentChain | não |
| MerchantFraudToolList | array of objects MerchantFraudTool | não |
| BypassCreditAnalysis | boolean | não |




### Documentation

Essa operação recebe como parâmetro o ArgumentAffiliateMerchant que contém todas as informações necessárias no processo de credenciamento, caso seja encontrado algum erro de preenchimento dos parâmetros, será retornado um array de OperationInfo com o código e a mensagem do erro.

### **Argumento**

Essa operação recebe como parâmetro o ArgumentAffiliateMerchant com os campos detalhados abaixo:

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Credential | UserCredential | sim | Identifica quem está consumindo o serviço. Usar o conteúdo"<DocumentNumber>-<CompanyName>"sem as aspas, para gerar a assinatura. |
| Merchant | Merchant  | sim  | Parâmetro que contém todas as informações relacionadas ao lojista. |
| BypassCreditAnalysis | Booleano | não | Indica se a análise de risco deve ser executada ou não. Informar true para não executar análise de risco porque uma análise prévia pode já ter sido realizada. O valor true será ignorado em caso de falta de permissão. |

### **Retorno**

Essa operação devolverá como resposta o objeto AffiliateMerchantReturn com os campos detalhados abaixo:

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Status | OperationInfo | sim | Indica se a operação foi executada com sucesso ou se contém erros. |
| MessageList | Array de OperationInfo | não | Contém uma ou mais mensagens com código e descrição de possíveis erros. |
| MerchantReturn | MerchantReturn | não | Contém as informações referentes ao cadastro do lojista. |


# POST/ ListMerchants

>Exemplo de request

```json

{
  "UserCredential":{
    "EffectiveUserId":"String content",
    "Signature":"String content",
    "SourceIp":"String content",
    "UserId":"String content"
  },
  "Language":"String content",
  "QueryExpression":{
    "ConditionList":[{
      "__type":"Condition or GroupedCondition",
      "LogicalOperator":"String content",
      "ComparisonOperator":"String content",
      "Field":"String content",
      "Value":"String content"
    }],
    "OrderBy":[{
      "Key":"String content",
      "Value":"String content"
    }],
    "PageNumber":10,
    "RowsPerPage":100
  }
}

```


>Exemplo de Resposta
>200 OK

```json

{
  "MessageList":[],
  "Status":{
    "Code":"OK",
    "Message":"OK",
    "MessageRefCode":"TXT_OK"
  },
  "ListedMerchants":[{
    "AffiliationAgent":{
      "Name":"String content"
    },
    "AffiliationKey":"String content",
    "CaptureMethodList":[{
      "SaleAffiliationKey":"String content",
      "TerminalType":{
        "Id":2147483647,
        "Name":"String content"
      }
    }],
    "CompanyName":"String content",
    "ContactList":[{
      "ContactKey":"String content",
      "ContactName":"String content",
      "ContactType":{
        "Id":2147483647,
        "Name":"String content"
      },
      "Email":"String content",
      "MobilePhoneNumber":"String content",
      "PhoneNumber":"String content"
    }],
    "CreationDate":"\/Date(928160400000-0300)\/",
    "DocumentNumber":"String content",
    "DocumentType":0,
    "Mcc":{
      "Id":2147483647,
      "Name":"String content"
    },
    "MdrInfoList":[{
      "CardBrand":2147483647,
      "CardBrandName":"String content",
      "TransactionProfileId":2147483647,
      "TransactionProfileName":"String content",
      "Rate":12678967.543233,
    }],
    "MerchantStatus":{
      "Id":2147483647,
      "Name":"String content"
    },
    "SalesChannel":{
      "Id":2147483647,
      "Name":"String content"
    },
    "SalesPartner":{
      "Active":true,
      "Id":2147483647,
      "Name":"String content"
    },
    "SalesTeamMember":{
      "Active":true,
      "Id":2147483647,
      "Name":"String content",
      "SalesChannelId":2147483647,
      "SalesPartnerId":2147483647
    },
    "StoneCode":"String content",
    "TradeName":"String content"
  }],
  "PageNumber":2147483647,
  "RowsPerPage":2147483647,
  "TotalRows":9223372036854775807
}
```


> 200 Internal Error

```json

{
  "Status": {
    "Code": "INTERNAL_ERROR",
    "Message": "xxxx",
    "MessageRefCode": "MSG_INTERNAL_ERROR"
  },
  "MessageList": [],
  "MerchantReturn": {}
}

```


### Operação resonsável por listar lojas com seus respectivos dados

**Endpoint**
https://affiliation-staging.stone.com.br/Merchant/MerchantService.svc/Merchant/ListMerchants

**Parâmetros**

| Campo | Tipo | Obrigatório |
|-------|------|-------------|
| Credential | object UserCredential | sim |
| QueryExpression | object QueryExpression | sim |



### Documentation

Essa operação recebe como parâmetro o ArgumentListMerchants que contém todas as informações necessárias para encontrar o lojista. Caso seja encontrado algum erro de preenchimento dos parâmetros, será retornado um array de OperationInfo com o código e a mensagem do erro.

### **Argumento**

Essa operação recebe como parâmetro o ArgumentListMerchants com os campos detalhados abaixo:


| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Credential | UserCredential | sim | Identifica quem está consumindo o serviço. Usar o conteúdo "ListMerchants" sem as aspas, para gerar a assinatura. |
| QueryExpression | QueryExpression | sim | Parâmetro que contém todas as informações necessárias para encontrar o lojista. É preciso informar através desse campo como deseja paginar a lista de lojas retornadas como resultado da sua pesquisa.

Veja a lista dos campos disponíveis para filtrar a consulta.
 |

### **Retorno**

Essa operação devolverá como resposta o objeto AffiliateMerchantReturn com os campos detalhados abaixo:

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Status | OperationInfo | sim | Indica se a operação foi executada com sucesso ou se contém erros. |
| MessageList | Array de OperationInfo | não | Contém uma ou mais mensagens com código e descrição de possíveis erros. |
| ListedMerchants | Array de ListedMerchant | não | Contém a lista de lojas encontradas com seus respectivos dados de acordo com a pesquisa informada. |
| PageNumber | Numérico | sim | Número da página atual. |
| RowsPerPage | Numérico | sim | Número total de lojas por página. |
| TotalRows | Numérico | sim | Número total de lojas selecionadas de acordo com a condição / filtro informado na pesquisa. |


# POST/ ListTerminalDevices

### Operação responsável por listar terminais com seus respectivos dados.

> Exemplo de request

```json

{
  "Credential":{
    "EffectiveUserId":"String content",
    "Signature":"String content",
    "UserId":"String content"
  },
  "Language":"String content",
  "QueryExpression":{
    "ConditionList":[{
      "__type":"Condition",
      "LogicalOperator":"String content",
      "ComparisonOperator":"String content",
      "Field":"String content",
      "Value":"String content"
    }],
    "OrderBy":[{
      "Key":"String content",
      "Value":"String content"
    }],
    "PageNumber":1,
    "RowsPerPage":30
  }
}
```

> Exemplo de Resposta

> 200 OK

```json

{
  "MessageList":[],
  "Status":{
    "Code":"OK",
    "Message":"OK",
    "MessageRefCode":"TXT_OK"
  },
  "PageNumber":1,
  "RowsPerPage":30,
  "TerminalDeviceList":[{   
    "SerialNumber":"SERIALNUMBER",
    "Status":{
      "Id":1,
      "Name":"Ativo"
    },
    "StoneCode":"String content",
    "TerminalModel":{
      "Id":9,
      "Name":"D210"
    },
    "TerminalType":{
      "Id":1,
      "Name":"Pos"
    }
  }],
  "TotalPages":1,
  "TotalRows":1
}

```

**Endpoint**
https://affiliation-staging.stone.com.br/Merchant/MerchantService.svc/Merchant/ListTerminalDevices

**Parâmetros**

| Campo | Tipo | Obrigatório |
|-------|------|-------------|
| Credential | object UserCredential | sim |
| QueryExpression | object QueryExpression | sim |




### Documentation

> Exemplo 1

```json

{
  "Credential":{
    "Signature":"<signature>",
    "UserId":"<userid>"
  },
  "QueryExpression":{
    "ConditionList":[{
      "__type":"Condition",
      "LogicalOperator":"And",
      "ComparisonOperator":"Equals",
      "Field":"StatusId",
      "Value":"1"
    }],
    "PageNumber":1,
    "RowsPerPage":30
  }
}
```

> Exemplo 2

```json

{
  "Credential":{
    "Signature":"<signature>",
    "UserId":"<userid>"
  },
  "QueryExpression":{
    "ConditionList":[
      {
        "__type":"Condition",
        "LogicalOperator":"And",
        "ComparisonOperator":"Equals",
        "Field":"StatusId",
        "Value":"1"
      },
      {
        "__type":"Condition",
        "LogicalOperator":"And",
        "ComparisonOperator":"Equals",
        "Field":"StoneCode",
        "Value":"xxxxxxxxx"
      }
    ],
    "PageNumber":1,
    "RowsPerPage":30
  }
}
```

> Exemplo 3

```json

{
  "Credential":{
    "Signature":"<signature>",
    "UserId":"<userid>"
  },
  "QueryExpression":{
    "ConditionList":[
      {
        "__type":"Condition",
        "LogicalOperator":"And",
        "ComparisonOperator":"Equals",
        "Field":"StatusId",
        "Value":"1"
      },
      {
        "__type":"Condition",
        "LogicalOperator":"Or",
        "ComparisonOperator":"Equals",
        "Field":"StatusId",
        "Value":"4"
      }
    ],
    "PageNumber":1,
    "RowsPerPage":30
  }
}

```


* Exemplo 1 - Faz uma busca por terminais ativos (StatusId = 1)
* Exemplo 2 - Faz uma busca por terminais ativos (StatusId = 1) e por StoneCode
* Exemplo 3 - Faz uma busca por terminais ativos (StatusId = 1) ou com OS aberta (StatusId = 4)



### **Argumento**

Essa operação recebe como parâmetro o ArgumentListMerchants com os campos detalhados abaixo:


| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Credential | UserCredential | sim | Identifica quem está consumindo o serviço. Usar o conteúdo "ListMerchants" sem as aspas, para gerar a assinatura. |
| QueryExpression | QueryExpression | sim | Parâmetro que contém todas as informações necessárias para encontrar o lojista. É preciso informar através desse campo como deseja paginar a lista de lojas retornadas como resultado da sua pesquisa.

Veja a lista dos campos disponíveis para filtrar a consulta.
 |

### **Retorno**

Essa operação devolverá como resposta o objeto AffiliateMerchantReturn com os campos detalhados abaixo:

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Status | OperationInfo | sim | Indica se a operação foi executada com sucesso ou se contém erros. |
| MessageList | Array de OperationInfo | não | Contém uma ou mais mensagens com código e descrição de possíveis erros. |
| ListedMerchants | Array de ListedMerchant | não | Contém a lista de lojas encontradas com seus respectivos dados de acordo com a pesquisa informada. |
| PageNumber | Numérico | sim | Número da página atual. |
| RowsPerPage | Numérico | sim | Número total de lojas por página. |
| TotalRows | Numérico | sim | Número total de lojas selecionadas de acordo com a condição / filtro informado na pesquisa. |

**Observação: este método retorna apenas os terminas dos tipos PinPad e Pos.**

# Especificações

## UserCredential

Contém as informações de identificação do chamador.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| UserId | Texto | sim | Identificador gerado pela Stone do qual o consumidor deve informar em todas as requisições. |
| Signature | Texto | sim | Assinatura para que a Stone confirme que quem está
consumindo o serviço esteja habilitado a usá-lo. |
| EffectiveUserId | Texto | não | Uso interno. |

## BankAccount

Contém todas as informações referentes à conta bancária do lojista.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| BankIdentifier | Texto | sim | Código do banco da conta bancária. Referência tabela de código dos bancos da FEBRABAN. |
| BankBranchCode | Texto | sim | Número da agência. |
| BranchVerificationCode | Texto | não | Dígito da agência. |
| AccountNumber | Texto | sim | Número da conta. |
| AccountVerificationCode | Texto | não | Dígito da conta. |
| CardBrand | Texto | sim | Indica o código da bandeira do cartão de crédito. Atualmente só existe suporte para trabalhar com uma única conta bancária para todas as bandeiras. Sempre informar:<br> 0 – All (Cadastra a mesma conta bancária para todas as bandeiras). |
| BankAccountTypeId | Texto | não | Tipo de conta bancária. Se não for informado, o valor 1 será utilizado.<br> 1 – Conta Corrente<br> 2 – Conta Poupança |
| HeadOfficePayment | Texto | não | Indica se o pagamento deve ser feito na matriz ou não. |

## Merchant

Contém todas as informações relacionadas ao lojista.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| CompanyName | Texto | Sim | Razão social do estabelecimento comercial. Caso seja Pessoa Física, informar o nome completo. |
| TradeName | Texto | Sim | Nome fantasia do estabelecimento comercial. Caso seja Pessoa Física, informar o nome que desejar para sua identificação. |
| DocumentNumber | Texto | Sim | CNPJ do lojista (CPF em caso de Pessoa Física). Formato: Somente números. |
| DocumentType | Numérico | Sim | Tipo do documento informado. Informar:<br> 1 - CNPJ<br>2 - CPF |
| AccountEmail | Texto | Não | Email da conta da loja para acesso ao portal Stone.Caso esse campo não seja informado, o primeiro contato da lista de contatos será utilizado para criação de acesso ao portal Stone, utilizando as informações ContactName e Email. |
| BanckAccountList | Array de BankAccount | Sim | Lista de conta bancária do lojista da qual onde será depositado o valor de suas vendas. |
| MerchantAddressList | Array de MerchantAddress | Sim | Lista de endereços da loja. |
| MerchantCaptureMethodList | Array de MerchantCaptureMethod | Sim | Indica quais os meios que o lojista irá transacionar. |
| MerchantContactList | Array de MerchantContact | Sim | Lista de contatos da loja. Contém informações dos contatos da loja. Caso o campo “AccountEmail” não seja informado, o primeiro contato da lista, será utilizado para criação de acesso ao portal Stone utilizando as informações ContactName e Email. |
| Mcc | Numérico | Sim | MCC (Merchant Category Code) que se enquadra as atividades do lojista. |
| MdrNegotiationList | Array de MdrNegotiation | Não | Lista de MDR (Merchant Discount Rate). Taxas que serão aplicadas pela Stone nas transações processadas. Esse parâmetro requer autorização prévia para ser utilizado, caso não tenha essa autorização, ignorar esse parâmetro informando nulo (Nesse caso, um valor padrão será atribuído pela Stone). |
| MerchantPartnerList | Array de MerchantPartner | Não | Lista de sócios do estabelecimento comercial. Contém informações necessárias para a identificação dos sócios. Essa informação só será considerada quando o credenciamento for referente a uma loja do tipo Pessoa Jurídica, quando for Pessoa Física essa informação não precisa ser preenchida. |
| MerchantExtraDataList | Array de MerchantExtraData | Não | Lista de dados extras do lojista. Contém informações personalizadas no formato chave-valor referentes ao lojista. Essa informação pode ser para uso interno ou externo, e tem flexibilidade para isso. Dois itens da lista não podem conter a mesma chave. |
| SalesChannelId | Numérico | Não | Identificador do canal de vendas utilizado para credenciamento do lojista.<br> 1 – Comercial<br> 2 – Inbound<br> 3 – ISO (parceiro comercial)<br> 4 – Caixa Econômica Federal<br> 5 – Key Account |
| SalesPartnerId | Numérico | Não | Identificador do parceiro comercial (ISO) responsável pelo credenciamento do lojista.
Esse campo é obrigatório quando o canal de vendas for ISO e não deve ser preenchido quando for diferente disso. |
| SalesTeamMemberId | Numérico | Não | Identificador do vendedor responsável pelo fechamento do contrato com o lojista. Ele deve estar consistente com o canal de vendas (e com o parceiro, se informado). |
| MerchantWorkScheduleList | Array de MerchantWorkSchedule | Não | Lista de dados relativos a horário de funcionamento da loja. |
| ChainTypeIdList | Array de Numérico | Não | Este campo informa o tipo de encadeamento desempenhado pelo lojista que está sendo credenciado quando ele é o componente principal de uma cadeia de relacionamentos. É possível ser mais de um tipo ao mesmo tempo.<br> Ver Exemplo<br> 1 - Marketplace<br> 2 - Matriz |
| ParentChainList | Array de ParentChain | Não | Lista contendo todos os Encadeamentos Pai aos quais o lojista será vinculado. |
| MerchantFraudToolList | Array de MerchantFraudTool | Não | Lista contendo as ferramentas antifraude que o lojista possui. Atualmente a API só permite informar uma ferramenta antifraude. |


## MerchantReturn

Contém as informações referentes ao cadastro do lojista.


| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| AffiliationKey | Texto | Sim | Código único que identifica o lojista na Stone, assim como o StoneCode. |
| SaleAffiliationKey | Texto | Não | Propriedade obsoleta. Ver propriedade CaptureMethodList. O SaleAffiliationKey (SAK) é a chave necessária para os estabelecimentos transacionarem com a Stone. Esse campo estará preenchido somente quando o meio de captura for Ecommerce (TerminalType = 4). |
| CaptureMethodList | Array de CaptureMethodReturn | Não | Lista de objetos que contem informações sobre os meios de captura cadastrados quando forem Ecommerce e/ou TEF, como a chave necessária para transacionar. |
| Mcc | Numérico | Não | Mcc (Merchant Category Code) – Código que informa o ramo ou área de atuação do lojista. |
| StoneCode | Texto | Não | Código único que identifica o lojista na Stone. |
| MerchantStatus | Numérico | Não | Status da loja após o credenciamento. Tabela com os valores de status da loja |
| MdrInfoList | Array de MdrInfo | Não | Informações de MDR (Merchant Discount Rate), ou seja, valor das taxas transacionais que a Stone irá reter do estabelecimento por transação. |

**Tabela com os valores de status da loja**

| Id | Descrição |
|----|-----------|
| 1 | Em Formalização |
| 2 | Em Análise de Risco |
| 3 | Documentação Pendente – Risco |
| 4 | Pré-Aprovado para Teste |
| 5 | Loja não aprovada |
| 6 | Loja aprovada |
| 7 | Loja aprovada com falha na configuração |
| 8 | Loja aprovada com domicílio bancário incorreto |
| 9 | Loja aprovada com CNPJ/CPF inválido ou divergente |
| 10 | Loja descredenciada |
| 11 | Credenciamento cancelado |
| 12 | Liquidação Bloqueada – Prevenção |


## MerchantAddress

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| AddressTypeId | Numérico | Não | Identificador do tipo de endereço. Os valores possíveis são:<br>1 – Principal - Operação<br>2 – Secundário<br>3 – Cobrança<br>4 – Correspondência<br>5 – Instalação<br>6 – Outros<br> Se não for informado, será atribuído o valor 1 (endereço principal). |
| StreetName | Texto | Sim | Nome da rua. |
| StreetNumber | Texto | Não | Número. |
| Complement | Texto | Não | Complemento do endereço. |
| Neighborhood | Texto | Sim | Bairro. |
| PostalCode | Texto | Sim | CEP.<br>Formato: Somente números. |
| Country | Numérico | Sim | Código do país.<br>Formato: ISO 3366-1 Numeric<br>Informar: 076 - Brasil|
| StateCode | Texto | Sim | Estado. Informar:<br>AC – Acre<br>AL – Alagoas<br>AP – Amapá<br>SP – São Paulo<br>BA – Bahia<br>CE – Ceará<br>DF – Distrito Federal<br>ES – Espírito Santo<br>GO – Goiás<br> MA – Maranhão<br>MT – Mato Grosso<br>MS – Mato Grosso do Sul<br>MG – Minas Gerais<br>PA – Pará<br>PB – Paraíba<br>PR – Paraná<br>PE – Pernambuco<br>PI – Piauí<br>RJ – Rio de Janeiro<br>  RN – Rio Grande do Norte<br>RS – Rio Grande do Sul<br>RO – Rondônia<br>RR – Roraima<br>          SC – Santa Catarina<br>AM – Amazonas<br>SE – Sergipe<br>TO – Tocantins |
| City | Texto | Sim | Cidade |


## MerchantCaptureMethod

Contém as informações do meio que o lojista irá transacionar.

```json

"MerchantCaptureMethodList": [
{
  "TerminalTypeId": 4,
  "Url": "www.teste.com"
},
{
  "TerminalTypeId": 3,
  "GroupId": 1
},
{
  "TerminalTypeId": 5,
  "TerminalModelId": 6,
  "SerialNumber": null,
  "IsAcquirerAsset": false,
  "GroupId": 1
},
{
  "TerminalTypeId": 5,
  "TerminalModelId": 6,
  "SerialNumber": null,
  "IsAcquirerAsset": false,
  "GroupId": 1
},
{
  "TerminalTypeId": 1,
  "TerminalModelId": 11,
  "MobileCarrierId": null,
  "SerialNumber": null,
  "IsAcquirerAsset": true,
  "RentalConfiguration": {
    "ChargeAmount": 79.00,
    "InitialExemptionDays": 0
  }
},
{
  "TerminalTypeId": 1,
  "TerminalModelId": 19,
  "MobileCarrierId": null,
  "SerialNumber": null,
  "IsAcquirerAsset": false
}]

```

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| SaleAffiliationKey | Texto | Não | O SaleAffiliationKey (SAK) é a chave necessária para os estabelecimentos transacionarem com a Stone. Quando o meio de captura for Ecommerce (TerminalType = 4), o SAK será retornado na resposta da operação “Affiliate”. Qualquer outro meio de captura diferente de Ecommerce não terá o SAK retornado. Esse campo é obrigatório na operação "UpdateCaptureMethod”. |
| Id | Numérico | Não | Identificador único do meio de captura. |
| MobileCarrierId | Numérico | Não | Informação referente a operadora do chip.<br>Informar:<br>1 – Oi<br>2 – Claro<br>3 – Vivo<br>4 – Tim |
| TerminalTypeId | Numérico | Sim | Indica o tipo de terminal que a loja irá transacionar.<br>Informar:<br>1 – POS<br>2 – MicroPOS<br>3 – TEF<br>4 – Ecommerce<br>5 – Pinpad |
| TerminalId | Numérico | Não | Identificador único do terminal. Obrigatório para atualização de dados de Pinpad. |
| TerminalModelId | Numérico | Não | Informação referente ao modelo do POS, MicroPOS ou Pinpad. Obrigatório quando o meio de captura for POS (TerminalType = 1), MicroPOS (TerminalType = 2) ou Pinpad (TerminalType = 5). Tabela de modelos |
| SerialNumber | Texto | Não | Número de série do POS ou Pinpad. Obrigatório quando o meio de captura for POS (TerminalType = 1), MicroPOS (TerminalType = 2). |
| PaymentGatewayId | Numérico | Não | Informação referente ao gateway de pagamento utilizado pelo lojista. Informação utilizada apenas para meio de captura Ecommerce (TerminalTypeId = 4). |
| Url | Texto | Não | Informar a URL do Ecommerce do lojista. Informação utilizada apenas para meio de captura Ecommerce (TerminalTypeId = 4). |
| IsAcquirerAsset | Booleano | Não | Indica se o terminal é ativo da Stone ou se é ativo de terceiro. Essa informação é obrigatória para terminais do tipo POS ou Pinpad. |
| StatusId | Numérico | Não | Indica status do terminal. Informação utilizada apenas quando tipo de terminal for POS ou Pinpad e quando o dispositivo for ativo da Stone.<br>Informar:<br>1 – Instalado<br>2 – Desinstalado<br>3 – Novo<br>4 – OS aberta<br>5 – Saiu para entrega<br>6 – Desinstalação solicitada<br>Após a operação “Affiliate” o status do terminal POS ou Pinpad que é ativo Stone será sempre 3 (Novo).|
| RentalConfiguration | TerminalRentalConfiguration | Não | Informações sobre cobrança de mensalidade do terminal. Informação utilizada apenas para terminais do tipo POS ou Pinpad. Informação obrigatória quando é ativo Stone. Se não for ativo Stone ou se o tipo de terminal não for POS ou Pinpad, nada deve ser informado. |
| GroupId | Numérico | Não | Informação utilizada para relacionar pinpads a um meio de captura quando este for MicroPOS ou TEF. Um MicroPOS ou TEF pode ter mais de um pinpad, e todos eles estarão ligados pelo mesmo GroupId, que pode ser qualquer valor de escolha do chamador, isto é, o indicador que eles pertencem a um mesmo meio de captura é esse identificador de grupo. Esse valor é ignorado para Ecommerce e POS. |

Quando um TerminalTypeId = 5 for inserido na lista, deve haver um meio de captura “pai” ao qual ele pertence, que será um MerchantCaptureMethod do com TerminalTypeId igual a 1, 2, 3 ou 4. Para um lojista que optou por um meio de captura TEF (TerminalTypeId = 3), por exemplo, e utiliza três pinpads, deve ser enviado quatro itens na lista de meios de captura no momento do credenciamento. Abaixo segue um exemplo do objeto usado na intenção de incluir a seguinte configuração de meios de captura:

1. Um Ecommerce
2. Um TEF com dois pinpads que não são ativos da Stone
3. Um POS VX685 que é ativo Stone
4. Um POS D200 que não é ativo Stone


### Modelos disponíveis

Tabela com modelos disponíveis e os tipos de terminal a quem podem ser associados. Um modelo não pode ser informado se o seu tipo for diferente do informado em TerminalTypeId.

| Id | Nome | Tipo de Terminal |
|----|------|------------------|
| 1 | Verifone VX680 | POS |
| 2 | Ingenico IWL280 | POS |
| 3 | S90 | POS |
| 6 | D200 Bluetooth | Pinpad |
| 7 | MicroPOS | MicroPOS |
| 8 | S80 | POS |
| 9 | D210 | POS |
| 10 | Mobile | MicroPOS |
| 11 | Verifone VX685 | POS |
| 12 | Ingenico iCT250 | POS |
| 13 | Ingenico iCT220 | POS |
| 14 | Gertec MOBI PIN 10 | Pinpad |
| 15 | D180 | Pinpad |
| 16 | D210 Bluetooth | Pinpad |
| 17 | Gertec PPC920 DUAL | Pinpad |
| 18 | Ingenico iPP320 | Pinpad |
| 19 | D200 | POS |
| 20 | Ingenico iWL250 | POS |
| 21 | Gertec PPC920 USB | Pinpad |
| 22 | Verifone VX520 | POS |
| 23 | Verifone VX690 | POS |
| 25 | S500 | POS |
| 26 | S920 | POS |
| 27 | D210N | POS |





## MerchantContact

Contém as informações dos contatos da loja.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| ContactName | Texto | Sim | Nome do contato. |
| PhoneNumber | Texto | Sim | Telefone de contato.<br>Formato: DDD + número do telefone (Somente números) |
| MobilePhoneNumber | Texto | Sim | Número do celular do contato. Formato: DDD + número do celular (Somente números) |
| Email | Texto | Sim | Email do contato. |
| ContactTypeId | Numérico | Sim | Identificador do tipo do contato.<br> Os valores possíveis são:<br>1 – Administrativo<br>2 – Financeiro<br>3 – Técnico |

## MerchantExtraData

Contém as informações de dados extras da loja.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Key | Texto | Sim | Chave para identificação do dado extra. |
| Value | Texto | Sim | Valor do dado extra a ser cadastrado para o lojista. |


## MerchantFraudTool

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Id | Numérico | Não | Identificador único da ferramenta antifraude do lojista |
| FraudToolId | Numérico | Sim | Identificador da ferramenta antifraude.<br>
<br>Informar:<br>1 – Clearsale<br>2 – Feedzai<br>3 – Verified by Visa<br>4 – Cybersource<br>5 – Autenticação de Endereço<br>7 – Antifraude Stone |


## MerchantPartner

Contém as informações dos sócios da loja. Essa informação só será levada em conta quando se tratar de um credenciamento de pessoa jurídica.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| PartnerName | Texto | Sim | Nome do sócio |
| PhoneNumber | Numérico | Não | Telefone do sócio.<br>Formato: DDD + número do telefone(Somente números) |
| Email | Texto | Não | Email do sócio |
| Cpf | Texto | Sim | CPF do sócio |
| Rg | Texto | Não | RG do sócio |
| Birthday | Datetime | Não | Data de nascimento do sócio. |


## MerchantStatus

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Id | Numérico | Sim | Identificador do status do lojista. Conforme indicado em Status da loja. |
| Name | Texto | Sim | Nome do status relacionado ao Id. |


## MerchantWorkSchedule

Contém as informações de horário de funcionamento da loja. No dia da semana que o estabelecimento estiver fechado, os horários de abertura e fechamento referentes a esse dia não devem ser informados.


| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Id | Numérico | Sim | Identificação do horário de funcionamento. |
| Open24h | Booleano | Não | Indica se a loja fica aberta 24h. Quando este valor for true, nenhum outro horário deve ser informado, isto é, deve-se informar nulo, a menos que haja exceção. |
| OpenWeekday | Texto | Não | Horário de abertura da loja em dias de semana. Texto no formato “hh:mm”.<br>Exemplo: se a loja abre às 8h, o valor deve ser “08:00”. |
| OpenSaturday | Texto | Não | Horário de abertura da loja no sábado. Texto no formato “hh:mm”.<br>Exemplo: se a loja abre às 8h, o valor deve ser “08:00”. |
| OpenSunday | Texto | Não | Horário de abertura da loja no domingo. Texto no formato “hh:mm”.<br>Exemplo: se a loja abre às 8h, o valor deve ser “08:00”. |
| OpenHoliday | Texto | Não | Horário de abertura da loja no feriado. Texto no formato “hh:mm”.<br>Exemplo: se a loja abre às 8h, o valor deve ser “08:00”. |
| CloseWeekday | Texto | Não | Horário de fechamento da loja em dias de semana. Texto no formato “hh:mm”.<br>Exemplo: se a loja fecha às 17h, o valor deve ser “17:00”. |
| CloseSaturday | Texto | Não | Horário de fechamento da loja no sábado. Texto no formato “hh:mm”.<br>Exemplo: se a loja fecha às 17h, o valor deve ser “17:00”. |
| CloseSunday | Texto | Não | Horário de fechamento da loja no domingo. Texto no formato “hh:mm”.<br>Exemplo: se a loja fecha às 17h, o valor deve ser “17:00”. |
| CloseHoliday | Texto | Não | Horário de fechamento da loja no feriado. Texto no formato “hh:mm”.<br>Exemplo: se a loja fecha às 17h, o valor deve ser “17:00”. |

## MdrInfo

Contém as taxas que foram criadas, das quais serão aplicadas nas transações da loja.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| CardBrand | Numérico | Sim | Identificador da bandeira do cartão de crédito conforme valores abaixo:<br>0 – Todos<br>1 – Visa<br>2 – Mastercard |
| CardBrandName | Texto | Sim | Nome da bandeira do cartão de crédito. Ex: Visa, Mastercard. |
| TransactionProfile | Numérico | Sim | Identificador do tipo de transação conforme valores abaixo:<br>1 – Crédito à vista<br>2 – Crédito de 2 a 6 parcelas s/ juros<br>3 – Crédito de 7 a 12 parcelas s/ juros<br>4 – Crédito com parcelas com juros<br>5 – Débito |
| TransactionProfileName | Texto | Sim | Descrição do tipo da transação. Ex: Crédito à vista, Crédito parcelado, Débito e etc. |
| Rate | Numérico | Sim | Valor da taxa que será aplicada nas transações.<br>Formato: 00.00 |
| FlatRate | Numérico | Não | Valor fixo que será cobrado por transação.<br>Formato: 00.00 |


## MdrNegotiation

Contém todas as informações referentes as taxas que a Stone irá aplicar nas transações da loja.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| CardBrand | Numérico | Sim | Identificador da bandeira do cartão de crédito conforme valores abaixo:<br>0 – Todos<br>1 – Visa<br>2 – Mastercard |
| TransactionProfile | Numérico | Sim | Identificador do tipo de transação conforme valores abaixo:<br>1 – Crédito à vista<br>2 – Crédito de 2 a 6 parcelas s/ juros<br>3 – Crédito de 7 a 12 parcelas s/ juros<br>4 – Crédito com parcelas com juros<br>5 – Débito |
| Rate | Numérico | Sim | Valor da taxa que será aplicada nas transações.<br>Formato: 00.00 |
| SettlementDays | Numérico | Não | Número de dias para liquidação (D + x).<br>Um valor padrão é atribuído se nada for informado. Para a modalidade Débito, o padrão é D + 2. Para as modalidades Crédito, o padrão é D + 30.<br>Atualmente, o envio do valor zero provoca a atribuição do valor padrão. |
| FlatRate | Numérico | Não | Valor fixo que será cobrado por transação.<br>Formato: 00.00 |
| MinimumDiscountAmount | Numérico | Não | Valor mínimo que será cobrado por transação.<br>Formato: 00.00 |


O preenchimento do MdrNegotiation deve seguir a seguinte regra: Para cada CardBrand, deverá constar todos os TransactionProfiles com seu respectivo campo Rate preenchido. Ou pode informar o CardBrand = 0, que significa todos os CardBrands com o mesmo TransactionProfile e Rate. Os exemplos abaixo ilustram esses casos:

### Exemplos

| CarBrand | TransctionProfile | Rate |
|----------|-------------------|------|
| 1 (Visa) | 1 | 5.00 |
| 1 (Visa) | 2 | 5.01 |
| 1 (Visa) | 3 | 5.02 |
| 1 (Visa) | 4 | 5.03 |
| 1 (Visa) | 5 | 5.04 |
| 2 (Mastercard) | 1 | 6.00 |
| 2 (Mastercard) | 2 | 6.01 |
| 2 (Mastercard) | 3 | 6.02 |
| 2 (Mastercard) | 4 | 6.03 |
| 2 (Mastercard) | 5 | 6.04 |

| CarBrand | TransctionProfile | Rate |
|----------|-------------------|------|
| 0 (Todos) | 1 | 5.00 |
| 0 (Todos) | 2 | 5.01 |
| 0 (Todos) | 3 | 5.02 |
| 0 (Todos) | 4 | 5.03 |
| 0 (Todos) | 5 | 5.04 |




## OperationInfo

Contém o código e mensagem do resultado da operação chamada.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Code | Texto | Sim | Indica o código de resposta da operação. Códigos de Respostas |
| Message | Texto | Sim | Mensagem de resposta da operação. |
| MessageRefCode | Texto | Sim | Código de referência da mensagem retornada.<br> Texto com identificador único para uma determinada mensagem.<br>Sua utilidade é facilitar uma possível tradução das mensagens retornadas para o idioma de preferência. |

## CaptureMethodReturn

Contém as informações referentes aos meios de captura cadastrados para o lojista quando estes são Ecommerce ou TEF.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| SaleAffiliationKey | Texto | Não | O SaleAffiliationKey (SAK) é a chave necessária para os estabelecimentos transacionarem com a Stone.<br>Esse campo estará preenchido somente quando o meio de captura for TEF (TerminalTypeId = 3) ou Ecommerce (TerminalTypeId = 4). |
| TerminalTypeId | Numérico | Não | O tipo de terminal ao qual o SaleAffiliationKey pertence.<br>Por exemplo: Credenciou-se um lojista com um meio de captura Ecommerce e um meio de captura TEF. Dois SAKs serão retornados e o TerminalTypeId é a forma de saber qual SAK pertence a qual meio de captura. |


## TerminalRentalConfiguration

Contém as informações de cobrança de mensalidade de um dispositivo.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| ChargeAmount | Texto | Sim | Valor da mensalidade. |
| InitialExemptionDays | Numérico | Sim | Número de dias de isenção a partir da data de ativação do terminal. |
| ExemptionPeriodStartDate | Datetime | Não | Data de início de isenção de mensalidade. |
| ExemptionPeriodEndDate | Datetime | Não | Data final de isenção de mensalidade. |

## QueryExpression

Contém os campos necessários para auxiliar na construção das condições / filtros de uma pesquisa e também suporte a paginação do resultado da pesquisa.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| ConditionList | Array de Condition e / ou de GroupedCondition |  |  |
| PageNumber | Numérico |  |  |
| RowsPerPage | Numérico |  |  |
| OrderBy |Array de<br>{<br>"Key" : "string"<br>"Value" : "string"<br>} | Não | Representa uma lista de "chave e valor" onde:<br>Key - Campo que deseja ordernar.<br> Esses campos são pré-definidos de acordo com a pesquisa que deseja realizar.<br>Value - Ordem da ordenação, que pode ser:<br>Asc - para ordem crescente<br>Desc - para ordem decrescente |

## ListedMerchant

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| AffiliationKey | Texto | Sim | Código único que identifica a loja na Stone, assim como o StoneCode. |
| CompanyName | Texto | Sim | Razão social da loja. |
| TradeName | Texto | Sim | Nome fantasia da loja. |
| DocumentType | Numérico | Sim | Indica se a loja é pessoa jurídica ou física. |
| DocumentNumber | Texto | Sim | CNPJ caso a loja seja uma pessoa jurídica ou CPF caso seja uma pessoa física. |
| StoneCode | Texto | Sim | Código único que identifica o lojista na Stone. |
| MerchantStatus | MerchantStatus | Sim | Indica o status da loja na Stone. |
| Mcc | Mcc | Sim | Mcc (Merchant Category Code) - Informa o ramo ou área de atuação do lojista. |
| SalesChannel | SalesChannel | Não | Canal de vendas por qual a loja foi credenciada na Stone. |
| SalesPartner | SalesPartner | Não | Parceiro comercial por qual a loja foi credenciada na Stone. |
| SalesTeamMember | SalesTeamMember | Não | Responsável comercial pela negociação e credenciamento da loja na Stone. |
| CreationDate | Texto | Sim | Data de credenciamento da loja na Stone.<br>Formato: dd/MM/yyyy |
| MdrInfoList | MdrInfo | Não | Informações de MDR (Merchant Discount Rate), ou seja, valor das taxas transacionais que a Stone irá reter do estabelecimento por transação. |
| AffiliationAgent | AffiliationAgent | Não | Indica o agente (aplicação) responsável pelo credenciamento. |
| CaptureMethodList | CaptureMethodInfo | Não | Lista de objetos que contém informações sobre os meios de captura cadastrados quando forem Ecommerce, TEF e/ou MicroPOS. |
| ContactList | ContactReturn | Não | Lista de contatos da loja. |

## Condition

O objeto Condition contém os campos necessários para criar as condições/filtros de uma pesquisa.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| __type | Texto | Sim | Informar "Condition". |
| LogicalOperator | Texto | Sim | Operador lógico da condição/filtro. Informar:<br>And – Quando deseja que uma ou mais condições/filtros sejam verdadeiras.<br>Or – Quando deseja que uma ou outra condição/filtro seja verdadeira. |
| Field | Texto | Sim | Representa o campo que deseja realizar a condição/filtro. Esses campos são pré definidos de acordo com a pesquisa que deseja realizar. |
| ComparisonOperator | Texto | Sim | Operador de comparação entre o Field(campo) e o Value(valor do campo) Informar:<br>**Equals** – Para comparar um valor exato. Ex: ‘Nome é igual Abc’.<br>**NotEqualTo** – Para comparar um valor diferente. Ex: ‘Nome é diferente de Abc’.<br>**GreaterThan** – Para comparar se o valor de um campo é maior que outro. Ex: ‘Data1 é maior que Data2’.<br>**LessThan** – Para comparar se o valor de um campo é menor que outro. Ex: ‘Data1 é menor que Data2’.<br>**GreaterThanOrEqualTo** – Para comparar se o valor de um campo é maior ou igual a de outro. Ex: ‘Data1 é maior ou igual a Data2’.<br>**LessThanOrEqualTo** – Para comparar se o valor de um campo é menor ou igual a de outro. Ex: ‘Data1 é menor ou igual a Data2’.<br>**In** – Para verificar se um valor está dentro de uma lista de valores. Ex: ‘Nome está entre (Abc1, Abc2, Abc3)’.<br>**NotIn** – Para comparar se um valor está fora de uma lista de valores. Ex: ‘Nome não está entre (Abc1, Abc2, Abc3)’.<br>**Like** – Para comparar se um campo contém parcialmente um valor. Ex: ‘Nome contém A’ ou seja pega todos os nomes que contém a letra A.<br>**IsNull** – Para comparar se o valor de um campo é nulo. Ex: ‘Nome é nulo’.<br>**IsNotNull** – Para comparar se o valor de um campo não é nulo. Ex: ‘Nome não é nulo’. |
| Value | Texto | Não | Valor associado ao campo Field. |


## GroupedCondition

Contém uma lista de condições / filtros agrupadas. Seu objetivo é funcionar como se fosse sub condições / filtros ou um grupo de condições / filtros separados das demais. Ele suporta que um grupo de condições / filtros contenha outros grupos.

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| LogicalOperator | Texto | Sim | Operador lógico da condição/filtro. Informar:<br>**And** – Quando deseja que uma ou mais condições/filtros sejam verdadeiras.<br>**Or** – Quando deseja que uma ou outra condição/filtro seja verdadeira. |
| GroupedConditionList | Array de ConditionBase | Não | Representa as condições/filtros que deseja aplicar na sua pesquisa.<br>Existem 2 tipos de ConditionBase:<br>Condition – Para maiores informações, verificar a tabela Condition .<br>GroupedCondition – Para maiores informações, verificar a tabela GroupedCondition . |


## ParentChain

Contém as informações dos Encadeamentos Pai de um lojista (Matriz, Marketplace, etc).

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| TypeId | Numérico | Sim | Tipo do Encadeamento Pai. Informar:<br>1 - Marketplace<br>2 - Matriz |
| ChainIdentifier | Texto | Sim | Identificardor do Encadeamento Pai.<br>Para:<br> Marketplace:StoneCode<br>Matriz:StoneCode |

**Exemplo**

>O objeto que deve ser utilizado para encadear o lojista ao Marketplace e à Matriz é o seguinte:

>Exemplo de um ParentChainList

```json
"ParentChainList":[
{
  "TypeId": 1,
  "ChainIdentifier": "11111111"
},
{
  "TypeId": 2,
  "ChainIdentifier": "22222222"
}]
```

Vejamos um caso em que:

* O lojista é **Seller** de um Marketplace de StoneCode **11111111**

* O lojista é **Filial** de uma Matriz de StoneCode **22222222**

Uma vez que nosso Tipos de Encadeamento*(ChainType) são:

1. - Marketplace

2. - Matriz

## ListedTerminalDevice

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| SerialNumber | Texto | Sim | Número de série do terminal. |
| Status | CaptureMethodStatus | Sim | Identifica o status do terminal. |
| StoneCode | Texto | Sim | Identifica o Stone code do lojista o qual esse terminal pertence. |
| TerminalType | TerminalType  | Sim | Identifica o tipo do terminal. |
| TerminalModel | TerminalModel | Sim | Identifica o modelo do terminal |


## Mcc

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Id | Numérico | Sim | Código do mcc conforme documento MCC. |
| Name | Texto | Sim | Nome da categoria indicado pelo código. |



## SalesChannel

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Id | Numérico | Sim | Identificador do canal de vendas. |
| Name | Texto | Sim | Nome do canal de vendas. |



## SalesPartner

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Id | Numérico | Sim | Identificador do parceiro comercial. |
| Name | Texto | Sim | Nome do parceiro. |
| Active | Booleano | sim | Indica se o parceiro comercial está ativo na Stone. |


## SalesTeamMember

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Id | Numérico | Sim | Identificador do responsável comercial. |
| Name | Texto | Sim | Nome do responsável comercial. |
| Active | Booleano | Sim | Indica se o responsável comercial está ativo na Stone. |
| SalesChannelId | Numérico | Sim | Identificador do canal de vendas que o responsável comercial está associado. |
| SalesPartnerId | Numérico | Não | Identificador do parceiro comercial que o responsável comercial está associado. |


## AffiliationAgent

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Name | Texto | Sim | Nome do agente(aplicação). |


## CaptureMethodInfo

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| SaleAffiliationKey | Texto | Sim | O SaleAffiliationKey (SAK) é a chave necessária para os estabelecimentos transacionarem com a Stone.<br>Esse campo estará preenchido somente quando o meio de captura for TEF (TerminalTypeId = 3) ou<br> Ecommerce (TerminalTypeId = 4). |
| TerminalType | TerminalType | Sim | Tipo do terminal. |
| TerminalList | Array de Terminal | Sim | ista com os terminais associados a esse meio de captura. |


## Terminal


## TerminalType

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Id | Numérico | Sim | Identificador do tipo de terminal. |
| Name | Texto | Sim | Nome do tipo de terminal. |


## TerminalStatus


## TerminalModelInfo

## ContactReturn

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| ContactKey | Texto | Sim | Identificador alternativo do contato. |
| ContactName | Texto | Sim | Nome do contato. |
| ContactType | ContactType | Sim | Tipo do contato. |
| PhoneNumber | Texto | Sim | Telefone fixo do contato. |
| MobilePhoneNumber | Texto | Sim | Celular do contato. |
| Email | Texto | Sim | Email do contato. |


## ContactType

# Referências Adcicionais


## Código de respostas

Tabela de possíveis códigos de resposta das operações

| Campo | Descrição |
|-------|-----------|
| OK | Informa que a operação foi executada com sucesso. | 
| VALIDATION_ERRORS | Informa que foram encontrados erros de preenchimento dos campos. |
| VALIDATION_ERROR | Informa que o erro é um erro de validação. |
| MANDATORY_FIELD_ERROR | Informa que o erro é de um campo obrigatório que não foi preenchido. | 
| INTERNAL_ERROR | Informa que um erro insperado ocorreu. Entrar em contato com suporte. | 
| MAINTENANCE | Informa que o sistema está em manutenção. |

## MCC

| Mcc| Descrição |
|----|-----------|
| 742 | VETERINARIA |
| 763 | COOPERATIVA AGRÍCOLA |
| 780 | SERVIÇOS DE PAISAGISMO E HORTICULTURA |
| 1520 | EMPREITEIROS EM GERAL - COMERCIAL E RESIDENCIAL |
| 1711 | PREST. DE SERV. PARA AR COND., ENCANAMENTO E AQUEC. |
| 1731 | ELETRICISTAS E SERVIÇOS ELÉTRICOS |
| 1740 | PEDREIROS E SERVIÇOS DE INSTALAÇÃO |
| 1750 | MARCENEIROS E SERVIÇOS DE CARPINTARIA |
| 1761 | METALURGICOS |
| 1771 | EMPREITEIO PARA SERVIÇOS ESPECIALIZADO |
| 1799 | DEMAIS SVS DE REFORMA E CONSTRUÇÃO NÃO-CLASSIFICADOS |
| 2741 | EDITORAS - PUBLICAÇÕES E IMPRESSÕES |
| 3000 | UNITED AIRLINES |
| 3001 | AMERICAN AIRLINES |
| 3013 | ALITALIA |
| 3017 | SOUTH AFRICAN AIRWAYS |
| 3018 | VARIG |
| 3023 | MEXICANA |
| 3030 | AEROLINEAS ARGENTINAS |
| 3036 | VASP |
| 3039 | AVIANCA |
| 3052 | LAN CHILE |
| 3058 | DELTA |
| 3100 | MALAYSIAN AIRLINE |
| 3102 | IBERIA |
| 3351 | AFFILIATED AUTO RENTAL |
| 3357 | HERTZ RENT A CAR |
| 3366 | BUDGET RENT A CAR |
| 3389 | AVIS RENT A CAR |
| 3501 | HOLIDAY INNS |
| 3502 | BEST WESTERN HOTELS |
| 3503 | SHERATON HOTELS |
| 3510 | DAYS INN |
| 3533 | HOTEL IBIS |
| 3543 | FOUR SEASONS HOTELS |
| 3548 | HOTEIS MELIA |
| 3562 | COMFORT INNS |
| 3649 | RADISSON HOTELS |
| 3687 | CLARION HOTELS |
| 3721 | HILTON CONRAD HOTELS |
| 4011 | TRANSPORTE FERROVIÁRIO DE CARGA |
| 4111 | TRANSPORTE LOCAL DE PASSAGEIROS, INCLUINDO BALSAS |
| 4112 | TRANSPORTE DE PASSAGEIROS EM TREM (LONGA DISTÂNCIA) |
| 4119 | AMBULANCIAS |
| 4121 | LIMUSINES E TÁXIS (TAXICABS AND LIMOUSINES) |
| 4131 | COMPANHIAS DE ONIBUS |
| 4214 | TRANSPORTE DE CARGA RODOVIÁRIO E ARMAZENAMENTO |
| 4215 | CORREIOS - AÉREO, TERRESTRE E TRANSITÓRIOS |
| 4411 | LINHAS DE CRUZEROS (CRUISE LINES) |
| 4468 | MARINAS, SERVIÇOS E FORNECEDORES |
| 4511 | OUTRAS CIAS AÉREAS |
| 4722 | AGÊNCIAS DE VIAGENS (TRAVEL AGENCIES) |
| 4723 | AGÊNCIAS DE VIAGEM TUI (TUI TRAVEL AGENCY) |
| 4784 | PEDÁGIOS |
| 4789 | SERVIÇOS DE TRANSPORTE |
| 4812 | TELEFONES E EQUIPAMENTOS DE TELECOMUN. |
| 4813 | SERVIÇOS DE TELEC.- CHAM. LOCAIS E LONGA DISTÂNCIA |
| 4814 | SERVIÇOS DE TELECOMUNICAÇÃO |
| 4816 | REDES DE COMPUTADORES / SERVIÇOS DE INFORMAÇÃO |
| 4821 | TELEGRAFO |
| 4899 | SERVIÇOS DE TV A CABO/PAGA (CABLE/PAY TV SERVICES) |
| 4900 | UTILID./ELEC/GAS/AGUÁ/SANI (UT../ELEC/GAS/H2O/SANI) |
| 5021 | MÓVEIS PARA ESCRITÓRIOS (COMMERCIAL FURNITURE) |
| 5039 | MATERIAL PARA CONSTRUÇÃO E AFINS (CONST. MAT. - DEF) |
| 5045 | COMPUTADORES, EQUIPAMENTOS E SOFTWARES |
| 5051 | CENTROS DE SERVIÇOS DE METAIS (METAL SERVICE CENTERS) |
| 5065 | LOJA ARTIGOS ELETRÔNICOS |
| 5072 | EQUIP./DISTRIB. DE HARDWARE (HARDWARE EQUIP.SUPPLIES) |
| 5074 | EQUIP. DE AQUECIMENTO/ENCANAMENTO (PLUMB./HEAT. E.) |
| 5094 | JOALHERIA, PEDRAS PRECIOSAS, METAIS |
| 5099 | ATACADISTAS E DISTRIBUIDORES DE MERCADORIAS DURÁVEIS |
| 5122 | FARMACEUTICOS/DROGAS (DRUGS/DRUGGISTS SUNDRIES) |
| 5172 | PRODUTOS DE PETRÓLEO (PETROLEUM/PETROLEUM PRODUCTS) 
| 5192 | ATAC. E DISTRIB. DE LIVROS, PERIÓDICOS E JORNAIS |
| 5198 | PINTURA, POLIMENTO E SUPRIM. (PAN., VARN. & SUPPLIES) |
| 5251 | VENDA DE EQUIPAMENTOS, INCLUINDO DE FERRAGEM |
| 5261 | JARDINAGEM |
| 5300 | VENDA POR ATACADO (WHOLESALE CLUBS) |
| 5309 | DUTY FREE STORES |
| 5311 | LOJAS DE DEPARTAMENTOS (DEPARTMENT STORES) |
| 5399 | LOJA MERCADORIAS GERAIS |
| 5411 | MERCEARIAS/SUPERMERCADOS (GROCERY STORES/SUPERM.) |
| 5422 | AÇOGUEIRO (FREEZER/MEAT LOCKERS) |
| 5441 | LOJA DE DOCES |
| 5451 | LOJA DE PRODUTOS DE LACTICÍNIOS (DAIRY PROD. STORES) |
| 5462 | CONFEITERIAS (BAKERIES) |
| 5499 | LOJA DE ALIMENTOS VARIADOS (MISC FOOD S. - DEFAULT) |
| 5532 | LOJA DE PNEUS |
| 5533 | LOJA DE PEÇAS E ACESSÓRIOS DE CARROS |
| 5541 | ESTAÇÕES DE SERVIÇOS (SERVICE STATIONS) |
| 5542 | AUTO DIST. DE COMBUSTÍVEIS (AUTOM. FUEL DISPENSERS) |
| 5551 | VENDA DE BARCOS MOTORIZADOS |
| 5561 | ARTIGOS PARA ACAMPAMENTO |
| 5571 | LOJAS DE MOTOCICLETAS E ACESSÓRIOS |
| 5599 | SERVIÇOS GERIAS PARA CARROS |
| 5611 | ARTIGOS MASCULINOS |
| 5621 | LOJA DE ROUPAS FEMININAS "PRONTA PARA USAR" |
| 5631 | ACESSORIOS FEMININOS E LINGERIES |
| 5641 | ARTIGOS PARA CRIANÇAS E BEBÊS |
| 5651 | ROUPAS MASCULINAS, FEMININAS E INFANTIS |
| 5655 | ROUPA ESPORTIVA |
| 5661 | LOJAS DE SAPATOS |
| 5681 | LOJA DE PELES |
| 5691 | LOJA ROUPA UNISSEX |
| 5697 | COSTUREIRAS E ALFAIATES |
| 5699 | SERVIÇOS GERAIS PARA VESTIMENTA |
| 5712 | LOJA DE MÓVEIS |
| 5714 | LOJA DE ESTOFADOS (DRAPERY & UPHOLSTERY STORES) |
| 5718 | LAREIRAS E ACESSÓRIOS (FIREPLACES & ACCESSORIES) |
| 5719 | LOJA DE MÓVEIS ESPECIALIZADA (HOME FURNISHING SPEC.) |
| 5722 | LOJAS DE ELETRODOMÉSTICOS |
| 5732 | LOJA DE ELETRÔNICOS |
| 5733 | LOJA INSTRUMENTO MUSICAIS |
| 5734 | LOJA DE SOFTWARE |
| 5735 | LOJAS DE DISCOS |
| 5811 | DISTRIBUIÇÃO E PRODUÇÃO DE ALIMENTOS |
| 5812 | RESTAURANTES |
| 5813 | BARES, PUBS E CASA NOTURNAS |
| 5814 | LANCHONETES DE COMIDAS RÁPIDAS (FAST FOOD) |
| 5912 | FARMÁCIAS (DRUG STORES & PHARMACIES) |
| 5921 | CERVEJAS, VINHOS E LICORES (STORE/BEER/WINE/LIQUOR) |
| 5932 | LOJA DE ANTIGUIDADES (ANTIQUE SHOPS) |
| 5937 | L. DE REPRODUÇÃO DE ANTIQUIDADES (ANT.REPROD. STORES) |
| 5940 | LOJA DE BICICLETAS - VENDAS E SERVIÇOS |
| 5941 | SERVIÇOS GERIAS PARA ESPORTES |
| 5942 | LIVRARIAS |
| 5943 | PAPELARIAS |
| 5944 | JOALHERIA (JEWERLY STORE) |
| 5945 | LOJA DE BRINQUEDOS |
| 5946 | LOJA DE FOTOGRAFIA |
| 5947 | LOJA DE PRESENTES |
| 5948 | ARTIGOS DE COURO |
| 5950 | LOJA DE COPOS/CRISTAIS (GLASSWARE/CRYSTAL STORES) |
| 5960 | MARK.DIRETO DE SEGUROS (DIR. MARKET. INSURANCE SVC) |
| 5962 | SERV. DIRETOS DE VIAGENS (D. MKTG-TRAV. RELATED ARR) |
| 5963 | VENDA DIRETA (DIRECT SELL/DOOR-TO-DOOR) |
| 5964 | CATALOGO DE COMERCIOS (CATALOG MERCHANT) |
| 5965 | CATÁLOGO DE VAREJO (COMB.CATALOG & RETAIL) |
| 5966 | MARKETING DIRETO-SAÍDA (OUTB. TELEMARKETING M.) |
| 5967 | MARKETING DIRETO - ENTRADA (INB. TELEMARKETING M.) |
| 5968 | ASSINATURA COMERCIAL (CONTINUITY/SUBSCRIP. MERCHANT) |
| 5969 | OUTROS VENDEDORES DE MARKETING DIRETO |
| 5970 | PRODUTOS ARTESANAIS |
| 5971 | GALERIA DE ARTE (ART DEALERS & GALLERIES) |
| 5976 | BENS ORTOPÉDICOS - PRÓTESES |
| 5977 | LOJA DE COSMÉTICOS |
| 5983 | REVENDEDORES DE COMBUSTÍVEIS (FUEL DEALERS) |
| 5992 | FLORICULTURA |
| 5993 | TABACARIA |
| 5994 | BANCA DE JORNAL E PROVEDOR DE NOTÍCIAS |
| 5995 | PET SHOP |
| 5999 | LOJAS ESPECIALIZADAS NÃO LISTADAS ANTERIOMENTE |
| 6010 | BANCOS / LOJAS DE POUPANÇA E INST. FINANCEIRA |
| 6211 | CORRETORES DE IMÓVEIS (SECURITIES BROKERS/DEALERS) |
| 6300 | VENDA DE SEGUROS (INSURANCE SALES/UNDERWRITE) |
| 6513 | CORRETOR DE IMÓVEIS (ALUGUEL) |
| 6532 | PAGTOS DE TRANSAÇÕES DE INST.FINANCEIRAS |
| 6533 | PAGTOS DE TRANSAÇÕES COMERCIAIS |
| 7011 | HOTEIS (HOTELS/MOTELS/RESORTS) |
| 7012 | TEMPO COMPARTILHADO (TIMESHARE) |
| 7032 | ACAMPAMENTOS RECREATIVOS E DEPORTIVOS |
| 7033 | SERVIÇOS DE ACAMPAMENTOS |
| 7210 | LAVANDARIA, LIMPEZA E SERVIÇOS DE VESTUÁRIO |
| 7211 | LAVANDERIA - FAMILIAR E COMERCIAL |
| 7216 | LAVANDERIA TINTURARIA |
| 7217 | LIMPEZA DE TAPETES E ESTOFADOS |
| 7230 | SALAO DE BELEZA / BARBEARIA / DEPILAÇÃO / MANICURE |
| 7251 | LOJA/REPARO DE SAPATOS |
| 7261 | SERVIÇO FUNERÁRIO |
| 7273 | SERVIÇO DE ENCONTROS E ACOMPANHANTE |
| 7276 | SERVIÇOS DE PREP. IMPOST. DE RENDA (TAX PREP. SVCS) |
| 7277 | S. DE ACONSELHAMENTO DE DÍVIDAS, CASAMENTO E PESSOAL |
| 7297 | CENTRO DE SAUNAS E MASSAGENS |
| 7298 | CLÍNICAS DE ESTÉTICA FACIAL / CORPORAL |
| 7299 | OUTROS SERVIÇOS PESSOAIS |
| 7311 | PUBLICIDADES |
| 7333 | SERVIÇOS DE IMPRESSÃO E ARTE GRÁFICA |
| 7343 | SERVIÇO DE EXTERMINIO E DESINFETAÇÃO |
| 7349 | SERVIÇO LIMPEZA E MANUTENÇÃO |
| 7361 | AGÊNCIAS DE EMPREGO |
| 7379 | COMPUTADORES: CONCERTOS E REPAROS |
| 7393 | AGÊNCIAS DE DETETIVES, PROTECÇÃO E DE SEGURANÇA |
| 7399 | SERVIÇOS DE NEGÓCIOS |
| 7511 | PARADA DE CAMINHÕES (TRUCK STOP) |
| 7512 | ALUGUEL DE AUTOMÓVEIS (AUTOMOBILE RENTAL AGENCY) |
| 7513 | ALUGUEL DE CAMINHÕES (TRUCK/UTILITY TRAILER RENTALS) |
| 7519 | ALUGUEL DE MOTOR HOME (MOTOR HOME/RV RENTALS) |
| 7523 | ESTACIONAMNTOS E GARAGENS DE CARRO |
| 7538 | SERVIÇOS PARA CARROS (NÃO CONCESIONARIA) |
| 7542 | LAVA JATO |
| 7622 | CONSERTO DE EQUIP. AUDIO E TV |
| 7623 | CONSERTO DE AR CONDICIONADO |
| 7629 | CONSERTO DE ELETRONICOS |
| 7631 | CONSERTO DE RELÓGIOS E JÓIAS |
| 7641 | RESTAURAÇÃO DE MÓVEIS (FURNITURE REPAIR) |
| 7699 | LOJA DE CONSERTOS GERAIS E SERVIÇOS RELACIONADOS |
| 7832 | CINEMAS, PRODUÇÕES CINEMATOGRÁFICAS |
| 7841 | LOJAS DE VIDEOS |
| 7922 | TEATROS, PRODUC. TEATR. E ESPECTAC. |
| 7995 | CASSINOS, LOTERIAS E JOGOS DE AZAR |
| 7996 | PARQUE DE DIVERSAO, CIRCO E AFINS |
| 7997 | ACADEMIAS / CLUBES |
| 7998 | AQUÁRIOS E ZOOLÓGICOS |
| 7999 | SERVIÇOS DE RECREAÇÃO E FESTAS |
| 8011 | MÉDICOS (CLÍNICAS E CONSULTÓRIOS) |
| 8021 | DENTISTAS E ORTODONTISTAS (CLÍNICAS E CONSULTÓRIOS) |
| 8031 | OSTEOPATAS |
| 8041 | QUIROPRAXIA |
| 8042 | OFTAMOLOGISTA E OPTOMETRISTAS |
| 8043 | OPTICIANS, OPTICAL GOODS, AND EYEGLASSES |
| 8049 | TRATAMENTOS PODIÁTRICOS |
| 8050 | CASAS DE REPOUSO, CLÍN. DE RECUPERAÇÃO E ENFERMAGEM |
| 8062 | HOSPITAIS |
| 8071 | ANALISES CLÍNICAS MÉDICAS E DENTAIS |
| 8099 | MEDICINA EM GERAL E PRATICANTES DE SERVIÇOS DE SAÚDE |
| 8111 | SERVIÇOS JURÍDICOS - ADVOGADOS |
| 8211 | EDUCAÇÃO PRIMÁRIA E SECUNDÁRIA (ELEM./SEC.S.) |
| 8220 | UNIVERSIDADES E FACULDADES (COLLEGES/UNIV/JC/PROF.) |
| 8241 | EDUACAÇÃO A DISTÂNCIA (CORRESPONDENCE SCHOOLS) |
| 8244 | ESCOLA DE COMÉRCIOS E SECRETARIADO (BUS./SEC. SCHOOL) |
| 8249 | ESCOLA DE NEGÓCIOS/VOCAÇÕES (TRADE/VOCATIONS S.) |
| 8299 | COLEGIOS (SCHOOLS) |
| 8351 | SERVIÇOS DE CUIDADOS DE CRIANÇAS (CHILD CARE SVCS) |
| 8398 | ORGANIZAÇÕES DE SERVIÇOS BENEFICIENTES E SOCIAIS |
| 8641 | ASSOCIAÇÕES CÍVICAS E SOCIAIS |
| 8661 | ORGANIZAÇÕES RELIGIOSAS |
| 8675 | ASSOCIAÇÃO DE CARROS |
| 8699 | ORG. SIND., ASSOC. CULT. E OTRS ASSOC. NÃO CLASSIF. |
| 8911 | ARQUIRETURA, ENGENHARIA E AGRIMENSURA |
| 8999 | OUTROS SERVIÇOS PROFISSIONAIS DE ESPECIALIZADOS |
| 9211 | PENSÃO ALIMENTÍCIA (COURT COSTS/ALIMONY/SUPPORT) |
| 9222 | MULTAS (FINES) |
| 9223 | PAGAMENTOS DE TÍTULOS E FINANÇAS (BAIL AND BOND P.) |
| 9311 | PAGAMENTOS DE IMPOSTOS (TAX PAYMENTS) |
| 9399 | SERVIÇOS GOVERNAMENTAIS (GOVT SERV - DEFAULT) |
| 9402 | POSTAGENS (POSTAGE STAMPS) |
| 9405 | COMPRAS GOVERNAMENTAIS (INTRA-GOVERNMENT PURCHASES) |
| 9950 | DEPART. DE COMPRAS (INTRA- COMPANY PURCHASES) |


## Status da loja

| Id | Descrição |
|----|-----------|
| 1 | Em Formalização |
| 2 | Análise de Risco |
| 3 | Documentação Pendente - Risco |
| 4 | Pré-Aprovado para Teste |
| 5 | Não Aprovado |
| 6 | Aprovado - Pronto para transacionar |
| 7 | Aprovado - Falha na configuração |
| 8 | Aprovado - Domicílio Bancário Incorreto |
| 9 | Aprovado - CPF/CNPJ Invalido ou Divergente |
| 10 | Descredenciado |
| 11 | Cancelado |
| 12 | Liquidação Bloqueada - Prevenção |

## Campos para busca de estabelecimentos comerciais

| Nome | Descrição |
|------|-----------|
| StoneCode | Filtra pelo StoneCode do lojista. |
| AffiliationKey | Filtra pelo AffiliationKey do lojista. Este é um identificador, alternativo ao StoneCode, no formato GUID.<br><br>Não confundir esse parâmetro com o SaleAffiliationKey, descrito mais abaixo.|
| CompanyName | Filtra pelo pela razão social. |
| TradeName | Filtra pelo nome fantasia. |
| DocumentNumber | Filtra pelo documento: CPF ou CNPJ. |
| MerchantStatus | Filtra pelo status da loja. Informar o ID. |
| SalesChannelId | Filtra pelo ID do canal de vendas. |
| SalesPartnerId | Filtra pelo ID do parceiro comercial. |
| SalesTeamMemberId | Filtra pelo ID do vendedor. |
| Mcc | Filtra pelo MCC. |
| SaleAffiliationKey | Filtra pela chave usada para transacionar. Formato GUID sem traços e sem chaves. |
| CreationDate | Filtra pela data de credenciamento. Formato "dd/MM/yyyy". |



## Campos para busca de terminais

| Nome | Descrição |
|------|-----------|
| StoneCode | Filtra pelo StoneCode do lojista ao qual o terminal pertence. |
| TerminalModelId | Filtra pelo identificador do modelo do terminal. |
| StatusId | Filtra pelo identificador do status do terminal. |
| SerialNumber | Filtra pelo número de série do terminal. |


