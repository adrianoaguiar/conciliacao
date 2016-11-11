---
title: Bem vindo à STONE ONLINE!

language_tabs:
- xml: XML Comentado
- shell: cURL

search: true
---

# Bem vindo à STONE ONLINE

Apresentaremos aqui, tudo o que você precisa para se conectar com a nossa estrutura de pagamento virtual (E-commerce).

**INTRODUÇÃO**

Todas as compras de e-commerce têm inicio com o cliente ( portador do cartão ) escolhendo um ou mais produtos, adicionando-os ao carrinho, revisando os itens escolhidos, até chegar à etapa de pagamento. 

Uma vez que o portador do cartão efetua o pagamento através de cartão de crédito, voucher, etc, dois novos participantes passam a ser comunicar através de trocas de mensagens, para autorizar a transação e fazer a sua captura:

1. Adquirente STONE

2. Banco emissor do cartão 

Adquirente é a empresa responsável por fazer a comunicação com o emissor ( banco ). Cada emissor possui seu próprio fluxo, meio de comunicação, tecnologia de segurança, protocolo, etc. Quando um e-commerce faz a integração através de um adquirente, está se beneficiando de todo um investimento
em tecnologias e segurança, além de um mecanismo único para se comunicar com o banco emissor, independentemente da tecnologia utilizada pelo banco.

Por exemplo, se um e-commerce precisa aceitar pagamentos através de três bandeiras de cartão de crédito diferentes, seriam necessários três processos de integração diferentes. Como o adquirente já fez esse investimento no processo de integração, o custo de integração através da adquirente é muito menor para a loja, do que se a integração fosse feita diretamente com as bandeiras.

# Fluxo de comunicação

Toda a comunicação começa com o portador optando por fazer o pagamento com um cartão aceito pelo e-commerce. O e-commerce, por sua vez, envia uma mensagem para o adquirente, solicitando o processamento do pagamento. Assim como ocorre com pagamentos nas maquininhas, o cliente precisará informar seus dados de autenticação e o pagamento poderá ser autorizado ou negado, seja por informações incorretas, ou algum eventual problema.

A integração com a Stone ocorrerá através do uso (consumo) de um webservice REST através de requisições HTTP.

![fluxo](/images/fluxo.png)

# Crendenciais de Acesso

##**HOMOLOGAÇÃO**

Para iniciar a integração com o nosso webservice solicite sua credencial de acesso ao nosso time de integrações pelo e-mail **integracoes@stone.com.br**.

Você deve encaminhar um e-mail com as seguintes informações:

* O nome da empresa parceira que realizará transações na Stone
* O CNPJ da empresa
* Uma descrição sucinta do negócio parceiro (em uma frase)
* E-mail para onde a credencial deve ser enviada

Você receberá um e-mail com uma `SAK` (SaleAffiliationKey) com um formato como este: **BFDB58AB9A8A48828C2647E18B7F1114**

##**EM PRODUÇÃO**

Uma vez que a etapa de homologação for concluída você precisará de uma credencial de PRODUÇÃO que será encaminhada após o seu cadastro com a Stone.

Para solicitar seu cadastro encaminhe um e-mail para o nosso time comercial [**ecommerce@stone.com.br**](mailto:ecommerce@stone.com.br) lhe auxiliar no processo de credenciamento.

# Protocolo

Durante o fluxo de comunicação, algumas mensagens serão enviadas a partir da loja online, para o Adquirente. Essas mensagens são enviadas no formato XML através do protocolo HTTP, utilizando a arquitetura REST. Essa arquitetura permite que representações da transação possam ser enviadas ou recebidas pela loja online, segundo seu estado atual.

Por exemplo, para criar uma autorização, a loja deverá enviar uma mensagem [AcceptorAuthorisationRequest](#) para o adquirente, que irá checar com o banco emissor se o cliente consumidor possui recursos para financiar o pagamento. Nessa mensagem, além dos dados de credenciamento da loja, a loja enviará os dados do dono do cartão e os dados da transação, como valor total, número de parcelas, etc.

# Requisições e funcionalidades

Todas as mensagens serão enviadas através do protocolo HTTP. Todas as mensagens são enviadas utilizando o método **POST** para os seguintes endpoints:

* Para o ambiente de produção [https://e-commerce.stone.com.br](https://e-commerce.stone.com.br).
* Para o ambiente de homologação  [https://sandbox-auth-integration.stone.com.br](https://sandbox-auth-integration.stone.com.br).

As funcionalidades disponíveis para as requisições são:

1. Autorização (**AUTHORIZE**)

2. Captura posterior (**COMPLETIONADVICE**)

3. Cancelamento (**CANCELLATION**)

4. Ajuda (**HELP**)

## Mensagens de Autorização

### Autorização com Captura

A autorização com captura é, provavelmente, um dos casos mais comuns de integração. O cliente chega à loja, escolhe seus produtos, adiciona-os ao carrinho, finaliza o pedido e faz o pagamento. A loja, ao receber a solicitação de finalização do pedido, faz a integração com a Stone, solicita a autorização e faz a captura do valor autorizado automaticamente. É o processo normal da maioria dos ecommerces.

![autorização com captura](/images/autorizacao-e-captura.png)

1. O estabelecimento envia uma mensagem `AcceptorAuthorisationRequest` para o adquirente solicitando autorização, informando que deseja realizar a captura financeira atribuindo o valor da tag `<TxCaptr>` como `true`
2. `AcceptorAuthorisationResponse` é devolvido pelo adquirente, informando ao estabelecimento sobre o êxito do pedido, uma vez que o adquirente tenha autorizado a transação sem a necessidade de envio de captura.

<aside class="notice">A tag TxCaptr deve ser enviada com valor TRUE</aside>

* [Exemplo de XML de requisição para autorização com captura](/attachment/caso-1_autorizacao-e-captura.xml)


### POST /Authorize

A autorização é o processo de troca de mensagens entre o estabelecimento e o adquirente onde é verificado se portador do cartão possui ou não saldo suficiente para a realização de um pagamento. A diferença entre a mensagem de autorização com captura automática e com captura posterior, está no elemento `TxCaptr` que deve ser informado `true` para Autorização com Captura, ou `false` para Autorização com Captura posterior.

### Requisição de autorização
A mensagem de `AcceptorAuthorisationRequest` é enviada pelo estabelecimento para a url [https://e-commerce.stone.com.br/Authorize](https://e-commerce.stone.com.br/Authorize) (produção) ou [https://sandbox-auth-integration.stone.com.br/Authorize](https://sandbox-auth-integration.stone.com.br/Authorize) (homologação) para o adquirente, para checar junto ao banco que a conta associada ao cartão possui recursos para financiar o pagamento. Este controle inclui a validação dos dados do cartão e todos os dados adicionais previstos.

```xml
<Document xmlns="urn:AcceptorAuthorisationRequestV02.1">
    <AccptrAuthstnReq>
        <!-- Cabeçalho da requisição -->
        <Hdr>
            <!-- Identifica o tipo de processo em que a mensagem se propõe. -->
            <MsgFctn>AUTQ</MsgFctn>
            <!-- Versão do protocolo utilizado na mensagem. -->
            <PrtcolVrsn>2.0</PrtcolVrsn>
        </Hdr>
        <!-- Dados da requisição de autorização. -->
        <AuthstnReq>
            <!-- Ambiente da transação. -->
            <Envt>
                <!-- Dados do estabelecimento. -->
                <Mrchnt>
                    <!-- Identificação do estabelecimento. -->
                    <Id>
                        <!-- Identificação do estabelecimento comercial no adquirente.
                             Também conhecido internamente como “SaleAffiliationKey”. -->
                        <Id>BFDB58AB9A8A48828C2647E18B7F1114</Id>
						<!-- O nome que aparecerá na fatura.
						     - se a transação for mastercard, o limite é 22 caracteres;
							 - se a transação for visa, o limite é 25 caracteres;
							 - se for parcelado, a visa usa os 8 primeiros caracteres do
							   nome do lojista pra passar a informação de parcelamento,
							   sobrando 17 caracteres. -->
						<ShrtNm>Nome da fatura</ShrtNm>
                    </Id>
                </Mrchnt>
                <!-- Dados do ponto de interação -->
                <POI>
                    <!-- Identificação do ponto de interação -->
                    <Id>
                        <!-- Código de identificação do ponto de interação
							 atribuído pelo estabelecimento. -->
                        <Id>2FB4C89A</Id>
                    </Id>
                </POI>
                <!-- Dados do cartão utilizado na transação. -->
                <Card>
                    <!-- Dados não criptografados do cartão utilizado na transação. -->
                    <PlainCardData>
                        <!-- Número do cartão. (Primary Account Number) -->
                        <PAN>4066559930861909</PAN>
                        <!-- Data de validade do cartão no formato “yyyy-MM”. -->
                        <XpryDt>2017-10</XpryDt>
                        <!-- Código de segurança do cartão -->
                        <CardSctyCd>
                            <!-- CVV estampado no verso do cartão -->
                            <CSCVal>123</CSCVal>
                        </CardSctyCd>
                    </PlainCardData>
                </Card>
            </Envt>
            <!-- Informações da transação a ser realizada. -->
            <Cntxt>
                <!-- Informações sobre o pagamento. -->
                <PmtCntxt>
                    <!-- Modo da entrada dos dados do cartão.
						 PHYS = Ecommerce ou Digitada; -->
                    <CardDataNtryMd>PHYS</CardDataNtryMd>
                    <!-- Tipo do canal de comunicação utilizado na transação.
						 ECOM = Ecommerce ou Digitada -->
                    <TxChanl>ECOM</TxChanl>
                </PmtCntxt>
            </Cntxt>
            <!-- Informações da transação. -->
            <Tx>
                <!-- Identificação da transação definida pelo sistema que se
                     comunica com o Host Stone. -->
                <InitrTxId>123123123</InitrTxId>
                <!-- Indica se os dados da transação devem ser capturados (true)
                     ou não (false) imediatamente. -->
                <TxCaptr>false</TxCaptr>
                <!-- Dados de identificação da transação atribuída pelo POI. -->
                <TxId>
                    <!-- Data local e hora da transação atribuídas pelo POI. -->
                    <TxDtTm>2014-03-12T15:11:06</TxDtTm>
                    <!-- Identificação da transação definida pelo ponto de interação (POI,
                         estabelecimento, lojista, etc). O formato é livre contendo no
                         máximo 32 caracteres. -->
                    <TxRef>06064f516a50483da7f189243c95ccca</TxRef>
                </TxId>
                <!-- Detalhes da transação. -->
                <TxDtls>
                    <!-- Moeda utilizada na transação em conformidade com a ISO 4217.-->
                    <Ccy>986</Ccy>
                    <!-- Valor total da transação em centavos. -->
                    <TtlAmt>100</TtlAmt>
                    <!-- Modalidade do cartão utilizado na transação. -->
                    <AcctTp>CRDT</AcctTp>
                    <!-- Os dados relativos à(s) parcela(s) ou a uma transação recorrente. -->
                    <RcrngTx>
                        <!-- Tipo de parcelamento. -->
                        <InstlmtTp>NONE</InstlmtTp>
                        <!-- Número do total de parcelas. -->
                        <TtlNbOfPmts>0</TtlNbOfPmts>
                    </RcrngTx>
                </TxDtls>
            </Tx>
        </AuthstnReq>
    </AccptrAuthstnReq>
</Document>
```

|Campo|Ocorrência|Tipo|Descrição|Obrigatório|
|-----|----------|----|---------|-----------|
|Header`<Hdr>`|[1..1]|Container|Cabeçalho da mensagem.| Sim |
|MessageFunction`<MsgFctn>`|[1..1]|CodeSet|Identifica o tipo de processo em que a mensagem se propõe. Valor Fixo: `AUTQ` = `AuthorisationRequest`.| Sim |
|ProtocolVersion`<PrtcolVrsn>`|[1..1]|Text|Versão do protocolo utilizado na mensagem.| Sim |
|AuthorisationRequest`<AuthstnReq>`|[1..1]|Container|Dados da requisição de autorização.| Sim |
|Environment`<Envt>`|[1..1]|Container|Ambiente da transação.| Sim |
|Merchant `<Mrchnt>`|[1..1]|Container|Dados do estabelecimento.| Sim |
|Identification`<ID>`|[1..1]|Container|Identificação do estabelecimento comercial.| Sim |
|Identification`<ID>`|[1..1]|Text|Identificação do estabelecimento comercial no adquirente. Também conhecido internamente como “SaleAffiliationKey”.| Sim |
|ShrtNm|[0..1]|Text|O nome que aparecerá na fatura.  Se a transação for mastercard, o limite é 22 caracteres; Se a transação for visa, o limite é 25 caracteres; Se for parcelado, a visa usa os 8 primeiros caracteres do nome do lojista pra passar a informação de parcelamento, sobrando 17 caracteres. | Não |
|Poi`<POI>`|[1..1]|Container|Dados do ponto de interação| Sim |
|Identification`<ID>`|[1..1]|Container|Identificação do ponto de interação| Sim |
|Identification`<ID>`|[1..1]|Text|Código de identificação do ponto de interação atribuído pelo estabelecimento.| Sim |
|Card`<Card>`|[1..1]|Container|Dados do cartão utilizado na transação.| Sim |
|PlainCardData`<PlainCardData>`|[0..1]|Container|Dados não criptografados do cartão utilizado na transação.| Não |
|PAN`<PAN>`|[1..1]|Text|Número do cartão. (Primary Account Number)| Sim |
|ExpiryDate`<XpryDt>`|[1..1]|Text|Data de validade do cartão no formato “yyyy-MM”.| Sim |
|CardSctyCd`<CardSctyCd>`|[1..1]|Container|Código de segurança do cartão| Sim |
|CSCVal`<CSCVal>`|[1..1]|Text|CVV estampado no verso do cartão| Sim |
|Context`<Cntxt>`|[1..1]|Container|Informações da transação a ser realizada.| Sim |
|PaymentContext`<PmtCntxt>`|[1..1]|Container|Informações sobre o pagamento.| Sim |
|CardDataEntryMode`<CardDataNtryMd>`|[1..1]|CodeSet|Modo da entrada dos dados do cartão: `PHYS` = Ecommerce ou Digitada;| Sim |
|TransactionChannel`<TxChanl>`|[0..1]|CodeSet|Tipo do canal de comunicação utilizado na transação. Obs.: Preencher esta tag apenas se `CardDataNtryMd` = `PHYS` ou `ECOM` = `Ecommerce ou Digitada`| Sim |
|Transaction`<Tx>`|[1..1]|Container|Informações da transação.| Sim |
|InitiatorTransactionIdentification`<InitrTxId>`|[0..1]|Text|Identificação da transação definida pelo sistema que se comunica com o Host Stone.| Não |
|TransactionCapture`<TxCaptr>`|[1..1]|Boolean|Indica se os dados da transação devem ser capturados - `true` - ou não `false` - imediatamente.| Sim |
|TransactionIdentification`<TxId>`|[1..1]|Container|Dados de identificação da transação atribuída pelo POI (Ponto de interação).| Sim |
|TransactionDateTime`<TxDtTm>`|[1..1]|DateTime|Data local e hora da transação atribuídas pelo POI (ponto de interação).| Sim |
|TransactionReference`<TxRef>`|[1..1]|Text|Identificação da transação definida pelo ponto de interação (POI, estabelecimento, lojista, etc). O formato é livre contendo no máximo 32 caracteres.| Sim |
|TransactionDetails`<TxDtls>`|[1..1]|Container|Detalhes da transação.| Sim |
|Currency`<Ccy>`|[1..1]|CodeSet|Moeda utilizada na transação em conformidade com a [ISO 4217](http://pt.wikipedia.org/wiki/ISO_4217) - `986` = Real Brasileiro.| Sim |
|TotalAmount`<TtlAmt>`|[1..1]|Amount|Valor total da transação em centavos.| Sim |
|AccountType`<AcctTp>`|[0..1]|CodeSet|Modalidade do cartão utilizado na transação. `CRDT` = Crédito.| Não |
|RecurringTransaction`<RcrngTx>`|[0..1]|Container|Os dados relativos à(s) parcela(s) ou a uma transação recorrente.| Não |
|InstalmentType`<InstlmtTp>`|[1..1]|CodeSet|Tipo de parcelamento. `NONE` = Nenhum e `MCHT` = Lojista| Sim |
|TotalNumberOfPayments`<TtlNbOfPmts>`|[1..1]|Quantity|Número do total de parcelas.| Sim |

#
### Legendas

Ocorrência<br>
[0..0] -> Dado não obrigatório no envio da requisição e na resposta<br>
[0..1] -> Dado não obrigatório no envio da requisição, porém obrigatório na resposta<br>
[1..0] -> Dado obrigatório no envio da requisição, porém não obrigatório na resposta<br>
[1..1] -> Dado obrigatório no envio da requisição e na resposta<br>

#

### Resposta de autorização
A mensagem `AcceptorAuthorisationResponse` é enviada pelo adquirente, para retornar o resultado da validação realizada pelo emissor sobre a operação de pagamento.

```xml
<Document xmlns="urn:AcceptorAuthorisationResponseV02.1">
    <AccptrAuthstnRspn>
        <!-- Cabeçalho da mensagem -->
        <Hdr>
            <!-- Identifica o tipo de processo em que a mensagem se propõe.
                 AUTP = AuthorisationResponse. -->
            <MsgFctn>AUTP</MsgFctn>
            <!-- Versão do protocolo utilizado na mensagem. -->
            <PrtcolVrsn>2.0</PrtcolVrsn>
            <!-- Dados para rastreamento da mensagem. -->
            <Tracblt>
                <!-- Data e hora da saída da mensagem no Host Stone. -->
                <TracDtTmOut>2014-03-12T18:10:58</TracDtTmOut>
            </Tracblt>
        </Hdr>
        <!-- Informações relacionadas à resposta da autorização. -->
        <AuthstnRspn>
            <!-- Ambiente da transação. -->
            <Envt>
                <!-- Dados do estabelecimento. -->
                <MrchntId>
                    <!-- dentificação do estabelecimento comercial no adquirente. Também
                         conhecido internamente como “SaleAffiliationKey”. -->
                    <Id>BFDB58AB9A8A48828C2647E18B7F1114</Id>
                </MrchntId>
                <!-- Dados do ponto de interação. -->
                <PoiId>
                    <!-- Identificador do ponto de interação -->
                    <Id>2FB4C89A</Id>
                </PoiId>
            </Envt>
            <!-- Informações da transação. -->
            <Tx>
                <!--- Dados de identificação da transação atribuída pelo POI -->
                <TxId>
                    <!-- Data local e hora da transação atribuído pelo POI.
                         Este campo será ecoado pelo adquirente. -->
                    <TxDtTm>2014-03-12T15:11:06</TxDtTm>
                    <!-- Identificação da transação atribuída pelo POI.
                         Este campo será ecoado pelo adquirente. -->
                    <TxRef>06064f516a50483da7f189243c95ccca</TxRef>
                </TxId>
                <!-- Identificação da transação definida pela Stone. -->
                <RcptTxId>00000034071000000215353</RcptTxId>
                <!-- Detalhes da transação. -->
                <TxDtls>
                    <!-- Moeda utilizada na transação em conformidade com a ISO 4217.
                         986 = BRL = Real Brasileiro
                         http://pt.wikipedia.org/wiki/ISO_4217 -->
                    <Ccy>986</Ccy>
                    <!-- Valor total autorizado em centavos. -->
                    <TtlAmt>100</TtlAmt>
                    <!-- Modalidade do cartão utilizado na transação.
                         CRDT = Crédito. -->
                    <AcctTp>CHCK</AcctTp>
                </TxDtls>
            </Tx>
            <!-- Dados de resposta da transação. -->
            <TxRspn>
                <!-- Resultado da autorização. -->
                <AuthstnRslt>
                    <!-- Dados da resposta da autorização. -->
                    <RspnToAuthstn>
                        <!-- Resposta da transação. -->
                        <Rspn>APPR</Rspn>
                        <!-- Código de resposta da autorização
                             (equivalente ao campo 39 da ISO 8583 de 2003). -->
                        <RspnRsn>0000</RspnRsn>
                    </RspnToAuthstn>
                    <!-- Código de autorização retornado pelo emissor. -->
                    <AuthstnCd>007091</AuthstnCd>
                    <!-- Indica se a mensagem precisa ser capturada posteriormente. -->
                    <CmpltnReqrd>false</CmpltnReqrd>
                </AuthstnRslt>
            </TxRspn>
        </AuthstnRspn>
    </AccptrAuthstnRspn>
</Document>
```

|Campo|Ocorrência|Tipo|Descrição| Obrigatório |
|-----|----------|----|---------|-------------|
|Header`<Hdr>`|[1..1]|Container|Cabeçalho da mensagem| Sim |
|MessageFunction`<MsgFctn>`|[1..1]|CodeSet|Identifica o tipo de processo em que a mensagem se propõe. Fixo: `AUTP` = AuthorisationResponse.| Sim |
|ProtocolVersion`<PrtcolVrsn>`|[1..1]|Text|Versão do protocolo utilizado na mensagem.| Sim |
|CreationDateTime`<CreDtTm>`|[1..1]|Text|Data de criação da mensagem| Sim |
|TraceDateTimeOut`<TracDtTmOut>`|[1..1]|DateTime|Data e hora da saída da mensagem no Host Stone.| Sim |
|AuthorisationResponse`<AuthstnRspn>`|[1..1]|Container|Informações relacionadas à resposta da autorização.| Sim |
|Environment`<Envt>`|[1..1]|Container|Ambiente da transação.| Sim |
|Merchant Identification`<MrchntId>`|[1..1]|Container|Dados do estabelecimento.| Sim |
|Identification`<Id>`|[1..1]|Text|Identificação do estabelecimento comercial no adquirente. Também conhecido internamente como “SaleAffiliationKey”.| Sim |
|POIId`<POIId>`|[0..1]|Container|Dados do ponto de interação.| Não |
|Identification`<Id>`|[1..1]|Text|Identificação do POI.| Sim |
|Transaction`<Tx>`|[1..1]|Container|Informações da transação.| Sim |
|TransactionIdentification`<TxId>`|[1..1]|Container|Dados de identificação da transação atribuída pelo POI (Ponto de interação).| Sim |
|TransactionDateTime`<TxDtTm>`|[1..1]|DateTime|Data local e hora da transação atribuído pelo POI (ponto de interação). Este campo será ecoado pelo adquirente.| Sim |
|TransactionReference`<TxRef>`|[1..1]|Text|Identificação da transação atribuída pelo POI (Ponto de interação). Este campo será ecoado pelo adquirente.| Sim |
|RecipientTransactionIdentification`<RcptTxId>`|[1..1]|Text|Identificação da transação definida pela Stone.| Sim |
|TransactionDetails`<TxDtls>`|[1..1]|Container|Detalhes da transação.| Sim |
|Currency`<Ccy>`|[1..1]|CodeSet|Moeda utilizada na transação em conformidade com a [ISO 4217](http://pt.wikipedia.org/wiki/ISO_4217) - `986` = Real Brasileiro.| Sim |
|TotalAmount`<TtlAmt>`|[1..1]|Amount|Valor total autorizado em centavos.| Sim |
|AccountType`<AcctTp>`|[0..1]|CodeSet|Modalidade do cartão utilizado na transação. `CRDT` = Crédito.| Não |
|TransactionResponse`<TxRspn>`|[1..1]|Container|Dados de resposta da transação.| Sim |
|AuthorisationResult`<AuthstnRslt>`|[1..1]|Container|Resultado da autorização.| Sim |
|ResponseToAuthorisation`<RspnToAuthstn>`|[1..1]|Container|Dados da resposta da autorização.| Sim |
|Response`<Rspn>`|[1..1]|CodeSet|Resposta da transação: `DECL: Declined`, `APPR: Aproved`, `PART: PartialApproved` e `TECH: TechinicalError`.| Sim |
|ResponseReason`<RspnRsn>`|[1..1]|Text|Código de resposta da autorização (equivalente ao campo 39 da ISO 8583 de 2003).| Sim |
|AuthorisationCode`<AuthstnCd>`|[0..1]|Text|Código de autorização retornado pelo emissor.| Não |
|CompletionRequired`<CmpltnReqrd>`|[0..1]|Boolean|Indica se a mensagem precisa ser capturada posteriormente.| Não |

#
### Legendas

Ocorrência<br>
[0..0] -> Dado não obrigatório no envio da requisição e na resposta<br>
[0..1] -> Dado não obrigatório no envio da requisição, porém obrigatório na resposta<br>
[1..0] -> Dado obrigatório no envio da requisição, porém não obrigatório na resposta<br>
[1..1] -> Dado obrigatório no envio da requisição e na resposta<br>

#

## Captura posterior

### Autorização com captura posterior

<aside class="notice">Uma mensagem específica para a captura deve ser enviada no momento oportuno</aside>

O estabelecimento pode escolher enviar ou não a mensagem de captura para uma transação de crédito. Em alguns casos, como de reservas em hotéis, o cliente acessa o site, escolhe o hotel, quarto, total de diárias e faz a reserva. O site do hotel, ao receber a solicitação de reserva, solicita à Stone que autorize o valor da reserva, mas não faz a captura até que o cliente faça o checkin no hotel.

![autorização com captura posterior](/images/autorizacao-com-captura-posterior.png)

1. O estabelecimento envia uma `AcceptorAuthorisationRequest` ao adquirente solicitando a autorização da transação.
2. Uma `AcceptorAuthorisationResponse` é devolvida pelo adquirente, informando ao estabelecimento sobre o êxito da autorização.
3. Se a transação tiver sido concluída com êxito no lado do estabelecimento, o estabelecimento envia uma `AcceptorCompletionAdvice` para capturar a transação.
4. O adquirente retorna uma `AcceptorCompletionAdviceResponse`, reconhecendo o resultado e captura financeira da transação.

<aside class="notice">A tag TxCaptr deve ser enviada com valor FALSE</aside>

* [Exemplo de XML de requisição para autorização](/attachment/caso-2_autorizacao.xml)
* [Exemplo de XML de requisição para captura](/attachment/caso-2_captura.xml)



### POST /CompletionAdvice

### XML de requisição de Captura comentado
Caso você deseje criar uma transação com captura posterior o campo deve `TxCaptr` deve ser preenchido como ``false`` na requisição de Autorização. Então, mensagem `AcceptorCompletionAdvice` deve ser enviada pelo estabelecimento para confirmar uma transação previamente autorizada. Esta mensagem também é utilizada como um pedido de desfazimento de transações. A url da requisição é [https://e-commerce.stone.com.br/CompletionAdvice](https://e-commerce.stone.com.br/CompletionAdvice) (produção) ou [https://sandox-auth-integration.stone.com.br/CompletionAdvice](https://sandox-auth-integration.stone.com.br/CompletionAdvice) (homologação).

```xml
<Document xmlns="urn:AcceptorCompletionAdviceV02.1">
    <AccptrCmpltnAdvc>
        <!-- Cabeçalho da mensagem. -->
        <Hdr>
            <!-- Identifica o tipo de processo em que a mensagem se propõe. -->
            <MsgFctn>CMPV</MsgFctn>
            <!-- Versão do protocolo utilizado na mensagem. -->
            <PrtcolVrsn>2.0</PrtcolVrsn>
        </Hdr>
        <!-- Informações relacionadas ao processo de captura ou desfazimento de uma autorização. -->
        <CmpltnAdvc>
            <!-- Ambiente da transação. -->
            <Envt>
                <!-- Dados do estabelecimento. -->
                <Mrchnt>
                    <!-- Identificação do estabelecimento comercial no adquirente. -->
                    <Id>
                        <Id>00000000000000000000000000000321</Id>
                    </Id>
                </Mrchnt>
            </Envt>
            <!-- Dados da transação. -->
            <Tx>
                <!-- Identificação da transação definida pelo sistema que se comunica com
                     o Host Stone. -->
                <InitrTxId>123123123</InitrTxId>
                <!-- Dados de identificação da transação atribuída pelo POI. -->
                <TxId>
                    <!-- Data local e hora da transação atribuído pelo POI. -->
                    <TxDtTm>2014-06-11T17:15:44</TxDtTm>
                    <!-- Identificação da transação atribuída pelo POI. -->
                    <TxRef>1111</TxRef>
                </TxId>
                <!-- Identificação da transação original -->
                <OrgnlTx>
                    <!-- Identificação da transação definida pelo adquirente. -->
                    <RcptTxId>9CDF257AQKR</RcptTxId>
                </OrgnlTx>
                <!-- Detalhes da transação. -->
                <TxDtls>
                    <!-- Moeda utilizada na transação em conformidade com a ISO 4217. -->
                    <Ccy>986</Ccy>
                    <!-- Valor total da transação em centavos. -->
                    <TtlAmt>100</TtlAmt>
                </TxDtls>
            </Tx>
        </CmpltnAdvc>
    </AccptrCmpltnAdvc>
</Document>
```

|Campo|Ocorrência|Tipo|Descrição| Obrigatório |
|-----|----------|----|---------|-------------|
|Header<Hdr>|[1..1]|Container|Cabeçalho da mensagem.| Sim |
|MessageFunction<MsgFctn>|[1..1]|CodeSet|Identifica o tipo de processo em que a mensagem se propõe. `CMPV = Completion Advice` ou `RVRA = ReversalAdvice`.| Sim |
|ProtocolVersion <PrtcolVrsn>|[1..1]|Text|Versão atual: “2.0”.| Sim |
|CompletionAdvice <CmpltnAdvc>|[1..1]|Container|Informações relacionadas ao processo de captura ou desfazimento de uma autorização.| Sim |
|Environment<Envt>|[1..1]|Container|Ambiente da transação.| Sim |
|Merchant <Mrchnt>|[1..1]|Container|Dados do estabelecimento.| Sim |
|Identification<Id>|[1..1]|Text|Identificação do estabelecimento comercial no adquirente. Também conhecido internamente como “SaleAffiliationKey”.| Sim |
|Transaction`<Tx>`|[1..1]|Container|Dados da transação.| Sim |
|TransactionIdentification`<TxId>`|[1..1]|Container|Dados de identificação da transação atribuída pelo POI.| Sim |
|TransactionDateTime`<TxDtTm>`|[1..1]|DateTime|Data local e hora da transação atribuído pelo POI. Este campo será ecoado pelo adquirente.| Sim |
|TransactionReference`<TxRef>`|[1..1]|Text|Identificação da transação atribuída pelo POI. Este campo será ecoado pelo adquirente.| Sim |
|OriginalTransaction`<OrgnlTx>`|[0..1]|Container|Identificação da transação original| Não |
|RecipientTransactionIdentification`<RcptTxId>`|[0..1]|Text|Identificação da transação definida pelo adquirente.| Não |
|TransactionDetails`<TxDtls>`|[1..1]|Container|Detalhes da transação.| Sim |
|Currency`<Ccy>`|[1..1]|CodeSet|Moeda utilizada na transação em conformidade com a ISO 4217.| Sim |
|TotalAmount`<TtlAmt>`|[1..1]|Amount|Valor total da transação em centavos.| Sim |

#
### Legendas

Ocorrência<br>
[0..0] -> Dado não obrigatório no envio da requisição e na resposta<br>
[0..1] -> Dado não obrigatório no envio da requisição, porém obrigatório na resposta<br>
[1..0] -> Dado obrigatório no envio da requisição, porém não obrigatório na resposta<br>
[1..1] -> Dado obrigatório no envio da requisição e na resposta<br>

#

### XML de resposta de Captura comentado
A mensagem `AcceptorCompletionAdviceResponse` é enviada pelo adquirente para avisar o estabelecimento sobre o reconhecimento do resultado da operação de pagamento, bem como a transferência dos dados financeiros da transação contidas no `AcceptorCompletionAdvice`. Esta mensagem também é utilizada como resposta para o processo de “desfazimento de transações”.

```xml
<Document xmlns="urn:AcceptorCompletionAdviceResponseV02.1">
    <AccptrCmpltnAdvcRspn>
        <!-- Cabeçalho da mensagem. -->
        <Hdr>
            <!-- Identifica o tipo de processo em que a mensagem se propõe.
                 CMPK = CompletionAdviceResponse ou
                 RVRR = ReversalAdviceResponse. -->
            <MsgFctn>CMPK</MsgFctn>
            <!-- Versão do protocolo utilizado na mensagem. -->
            <PrtcolVrsn>2.0</PrtcolVrsn>
        </Hdr>
        <!-- Informações sobre a resposta da captura ou desfazimento de uma autorização. -->
        <CmpltnAdvcRspn>
            <!-- Ambiente da transação. -->
            <Envt>
                <!-- Dados do estabelecimento. -->
                <Mrchnt>
                    <!-- Identificação do estabelecimento comercial no adquirente.
                         Também conhecido internamente como “SaleAffiliationKey”. -->
                    <Id>BFDB58AB9A8A48828C2647E18B7F1114</Id>
                </Mrchnt>
            </Envt>
            <!-- Dados da transação. -->
            <Tx>
                <!-- Dados da identificação da transação definida pelo POI. -->
                <TxId>
                    <!-- Data e hora da transação -->
                    <TxDtTm>2014-03-12T15:17:59</TxDtTm>
                    <!-- Identificação da transação definida pelo ponto de interação (POI,
                         estabelecimento, lojista, etc). Este campo será ecoado pelo adquirente. -->
                    <TxRef>7ca686eb242b4c0482c58961f5d3aac7</TxRef>
                </TxId>
                <!-- Resultado da transação.
                     DECL = Declined,
                     APPR = Approved,
                     PART = Partial Approved,
                     TECH = Technical Error. -->
                <Rspn>APPR</Rspn>
            </Tx>
        </CmpltnAdvcRspn>
    </AccptrCmpltnAdvcRspn>
</Document>
```

|Campo|Ocorrência|Tipo|Descrição| Obrigatório |
|-----|----------|----|---------|-------------|
|Header`<Hdr>`|[1..1]|Container|Cabeçalho da mensagem.| Sim |
|MessageFunction`<MsgFctn>`|[1..1]|CodeSet|Identifica o tipo de processo em que a mensagem se propõe. “CMPK” = CompletionAdviceResponse ou “RVRR” = ReversalAdviceResponse.| Sim |
|CreationDateTime`<CreDtTm>`|[0..1]|Text|Data de criação da mensagem| Não |
|ProtocolVersion`<PrtcolVrsn>`|[1..1]|Text|Versão do protocolo utilizado na mensagem.| Sim |
|CompletionAdviceResponse`<CmpltnAdvcRspn>`|[1..1]|Container|Informações sobre a resposta da captura ou desfazimento de uma autorização.| Sim |
|Environment`<Envt>`|[1..1]|Container|Ambiente da transação.| Sim |
|Merchant Identification`<MrchntId>`|[1..1]|Container|Dados do estabelecimento.| Sim |
|Identification`<Id>`|[1..1]|Text|Identificação do estabelecimento comercial no adquirente. Também conhecido como “SaleAffiliationKey”.| Sim |
|POIId`<POIId>`|[0..1]|Container|Dados do ponto de interação.| Não |
|Transaction`<Tx>`|[1..1]|Container|Dados da transação.| Sim |
|TransactionIdentification`<TxId>`|[1..1]|Container|Dados da identificação da transação definida pelo POI.| Sim |
|TransactionDateTime`<TxDtTm>`|[1..1]|DateTime|Data e hora da transação| Sim |
|TransactionReference`<TxRef>`|[1..1]|Text|Identificação da transação definida pelo ponto de interação. Este campo será ecoado pelo adquirente.| Sim |
|Response`<Rspn>`|[1..1]|CodeSet|Resultado da transação. DECL = Declined, APPR = Approved, PART = Partial Approved, TECH = Technical Error.| Sim |

#
### Legendas

Ocorrência<br>
[0..0] -> Dado não obrigatório no envio da requisição e na resposta<br>
[0..1] -> Dado não obrigatório no envio da requisição, porém obrigatório na resposta<br>
[1..0] -> Dado obrigatório no envio da requisição, porém não obrigatório na resposta<br>
[1..1] -> Dado obrigatório no envio da requisição e na resposta<br>

#

## Cancelamento

O cancelamento de uma autorização é outro caso comum, tanto para ecommerce, quanto para casos de reserva. Algumas vezes, por algum motivo, o cliente pode simplesmente desistir de uma compra.

![cancelamento](/images/cancelamento-com-captura.png)

1. O estabelecimento envia uma `AcceptorAuthorisationRequest` para o adquirente para realizar um pedido de autorização
2. Uma `AcceptorAuthorisationResponse` é enviada pelo adquirente confirmando e aprovando o pedido de autorização
3. Uma `AcceptorCompletionAdvice` é utilizada para informar ao adquirente sobre a captura da transação
4. O adquirente envia uma `AcceptorCompletionAdviceResponse` reconhecendo o pedido de cancelamento por parte do estabelecimento;

Nesta transação o estabelecimento não necessita de nenhum pedido de cancelamento prévio pois supomos que ele já possui as informações de que o cancelamento pode realmente ser realizado.

* [Exemplo de XML de requisição para cancelamento](/attachment/caso-4_cancelamento.xml)

### POST /Cancellation

O cancelamento é o serviço que permite que um estabelecimento cancele uma transação concluída com êxito. Também é conhecido como “desfazimento manual”. O prazo para que o cancelamento seja realizado é 180 dias.

### XML de requisição de Cancelamento comentado
A mensagem `AcceptorCancellationRequest` é utilizada para realizar um pedido de cancelamento de uma transação autorizada e deve ser enviada para a url [https://e-commerce.stone.com.br/Cancellation](https://e-commerce.stone.com.br/Cancellation) ( produção ) ou [https://sandbox-auth-integration.stone.com.br/Cancellation](https://sandbox-auth-integration.stone.com.br/Cancellation) (homologação). 

```xml
<Document xmlns="urn:AcceptorCancellationRequestV02.1">
    <AccptrCxlReq>
        <!-- Cabeçalho da mensagem -->
        <Hdr>
            <!-- Identifica o tipo de processo em que a mensagem se propõe. -->
            <MsgFctn>CCAQ</MsgFctn>
            <!-- Versão do protocolo utilizado na mensagem. -->
            <PrtcolVrsn>2.0</PrtcolVrsn>
        </Hdr>
        <!-- Informações relacionadas à requisição de cancelamento. -->
        <CxlReq>
            <!-- Ambiente da transação. -->
            <Envt>
                <!-- Dados do estabelecimento. -->
                <Mrchnt>
                    <!-- Identificação do estabelecimento comercial. -->
                    <Id>
                        <!-- Identificação do estabelecimento comercial no adquirente. -->
                        <Id>BFDB58AB9A8A48828C2647E18B7F1114</Id>
                    </Id>
                </Mrchnt>
                <!-- Dados do Ponto de Interação. -->
                <POI>
                    <!-- Identificação do ponto de interação -->
                    <Id>
                        <!-- Código de identificação do POI atribuído pelo estabelecimento. -->
                        <Id>2FB4C89A</Id>
                    </Id>
                </POI>
            </Envt>
            <!-- Dados da transação. -->
            <Tx>
                <!-- Indica se os dados da transação devem ser capturados `true` ou não
                     `false` imediatamente. -->
                <TxCaptr>true</TxCaptr>
                <!-- Identificação da transação atribuída pelo POI. -->
                <TxId>
                    <!-- Data e hora local da transação definidas pelo ponto de interação. -->
                    <TxDtTm>2014-03-12T15:09:00</TxDtTm>
                    <!-- Identificação da transação definida pelo ponto de interação.
                         O formato é livre contendo no máximo 32 caracteres. -->
                    <TxRef>12345ABC</TxRef>
                </TxId>
                <!-- Detalhes da transação -->
                <TxDtls>
                    <!-- Moeda utilizada na transação em conformidade com a ISO 4217.-->
                    <Ccy>986</Ccy>
                    <!-- Valor total da transação em centavos. -->
                    <TtlAmt>100</TtlAmt>
                </TxDtls>
                <!-- Dados da transação original -->
                <OrgnlTx>
                    <!-- Identificação da transação definida pelo sistema que se comunica
                         com o Host Stone. -->
                    <InitrTxId>123123123</InitrTxId>
                    <!-- Identificação da transação definida pelo adquirente. -->
                    <RcptTxId>00000034071000000215346</RcptTxId>
                </OrgnlTx>
            </Tx>
        </CxlReq>
    </AccptrCxlReq>
</Document>
```

|Campo|Ocorrência|Tipo|Descrição| Obrigatório |
|-----|----------|----|---------|-------------|
|Header`<Hdr>`|[1..1]|Container|Cabeçalho da mensagem| Sim |
|MessageFunction`<MsgFctn>`|[1..1]|CodeSet|Identifica o tipo de processo em que a mensagem se propõe. Fixo: “CCAQ” = Cancellation Request.| Sim |
|ProtocolVersion`<PrtcolVrsn>`|[1..1]|Text|Versão do protocolo utilizado na mensagem.| Sim |
|CancellationRequest`<CxlReq>`|[1..1]|Container|Informações relacionadas à requisição de cancelamento.| Sim |
|Environment`<Envt>`|[1..1]|Container|Ambiente da transação.| Sim |
|Merchant`<Mrchnt>`|[1..1]|Container|Dados do estabelecimento.| Sim |
|Identification`<Id>`|[1..1]|Container|Identificação do estabelecimento comercial.| Sim |
|Identification`<Id>`|[1..1]|Text|Identificação do estabelecimento comercial no adquirente. Também conhecido como “SaleAffiliationKey”.| Sim |
|Poi`<POI>`|[1..1]|Container|Dados do Ponto de Interação.| Sim |
|Identification`<Id>`|[1..1]|Container|Identificação do ponto de interação| Sim |
|Identification`<Id>`|[1..1]|Text|Código de identificação do ponto de interação atribuído pelo estabelecimento.| Sim |
|Capabilities|[0..1]|Container|Capacidades do Ponto de interação.| Não |
|PrintLineWidth`<PrtLineWidth>`|[0..1]|Text|Número máximo de colunas de cada linha a ser impressa no cupom. A quantidade mínima de colunas é de 38. Se o POI enviar menos do que 38, o Host Stone não irá retornar os dados do recibo.| Não |
|Transaction`<Tx>`|[1..1]|Container|Dados da transação.| Sim |
|TransactionCapture`<TxCaptr>`|[1..1]|Bool|Indica se os dados da transação devem ser capturados `true` ou não `false` imediatamente.| Sim |
|TransactionIdentification`<TxId>`|[1..1]|Container|Identificação da transação atribuída pelo POI (Ponto de interação).| Sim |
|TransactionDateTime`<TxDtTm>`|[1..1]|DateTime|Data e hora local da transação definidas pelo ponto de interação.| Sim |
|TransactionReference`<TxRef>`|[1..1]|Text|Identificação da transação definida pelo ponto de interação. O formato é livre contendo no máximo 32 caracteres.| Sim |
|TransactionDetails`<TxDtls>`|[1..1]|Container|Detalhes da transação| Sim |
|Currency`<Ccy>`|[1..1]|CodeSet|Moeda utilizada na transação em conformidade com a ISO 4217.| Sim |
|TotalAmount`<TtlAmt>`|[1..1]|Amount|Valor total da transação em centavos| Sim |
|OriginalTransaction`<OrgnlTx>`|[1..1]|Container|Dados da transação original | Sim |
|InitiatorTransactionIdentification`<InitrTxId>`|[0..1]|Text|Identificação da transação definida pelo sistema que se comunica com o Host Stone.| Sim |
|RecipientTransactionIdentification`<RcptTxId>`|[1..1]|Text|Identificação da transação definida pelo adquirente.| Sim |

#
### Legendas

Ocorrência<br>
[0..0] -> Dado não obrigatório no envio da requisição e na resposta<br>
[0..1] -> Dado não obrigatório no envio da requisição, porém obrigatório na resposta<br>
[1..0] -> Dado obrigatório no envio da requisição, porém não obrigatório na resposta<br>
[1..1] -> Dado obrigatório no envio da requisição e na resposta<br>

#

### XML de resposta de Cancelamento comentado
A mensagem AcceptorCancellationResponse é respondida pelo adquirente com as informações sobre a requisição de cancelamento `AcceptorCancellationRequest`. Importante informar que os dados do recibo de cancelamento são enviados somente nesta mensagem.

```xml
<Document xmlns="urn:AcceptorCancellationResponseV02.1">
    <AccptrCxlRspn>
        <!-- Cabeçalho da mensagem -->
        <Hdr>
            <!-- Identifica o tipo de processo em que a mensagem se propõe.
                 CCAP = Cancellation Response. -->
            <MsgFctn>CCAP</MsgFctn>
            <!-- Versão do protocolo utilizado na mensagem. -->
            <PrtcolVrsn>2.0</PrtcolVrsn>
        </Hdr>
        <!-- Informações relacionadas à resposta de cancelamento. -->
        <CxlRspn>
            <!-- Ambiente da transação. -->
            <Envt>
                <!-- Dados do estabelecimento. -->
                <MrchntId>
                    <!-- Identificação do estabelecimento comercial no adquirente.
                         Também conhecido internamente como “SaleAffiliationKey”. -->
                    <Id>BFDB58AB9A8A48828C2647E18B7F1114</Id>
                </MrchntId>
            </Envt>
            <!-- Dados da transação. -->
            <Tx>
                <!-- Indica se os dados da transação devem ser capturados `true`
                     ou não `false` imediatamente. -->
                <TxCaptr>true</TxCaptr>
                <!-- Identificação da transação atribuída pelo POI. -->
                <TxId>
                    <!-- Data e hora local da transação definidas pelo ponto de interação. -->
                    <TxDtTm>2014-03-12T15:09:00</TxDtTm>
                    <!-- Identificação da transação definida pelo ponto de interação.
                         Este campo será ecoado pelo adquirente. -->
                    <TxRef>123456798</TxRef>
                </TxId>
                <!-- Detalhes da transação -->
                <TxDtls>
                    <!-- Moeda utilizada na transação em conformidade com a ISO 4217. -->
                    <Ccy>986</Ccy>
                    <!-- Valor total da transação em centavos. -->
                    <TtlAmt>100</TtlAmt>
                </TxDtls>
            </Tx>
            <!-- Dados de resposta da transação. -->
            <TxRspn>
                <!-- Informações sobre o resultado da autorização a ser cancelada. -->
                <AuthstnRslt>
                    <!-- Dados de resposta da autorização a ser cancelada. -->
                    <RspnToAuthstn>
                        <!-- Resposta da transação.
                             DECL: Declined
                             APPR: Aproved
                             PART: PartialApproved
                             TECH: TechinicalError -->
                        <Rspn>APPR</Rspn>
                        <!-- Código de resposta da autorização
                             equivalente ao campo 39 da ISO 8583 de 2003. -->
                        <RspnRsn>0000</RspnRsn>
                    </RspnToAuthstn>
                </AuthstnRslt>
            </TxRspn>
        </CxlRspn>
    </AccptrCxlRspn>
</Document>
```

|Campo|Ocorrência|Tipo|Descrição|Obrigatório|
|-----|----------|----|---------|-----------|
|Header`<Hdr>`|[1..1]|Container|Cabeçalho da mensagem| Sim |
|MessageFunction`<MsgFctn>`|[1..1]|CodeSet|Identifica o tipo de processo em que a mensagem se propõe. Fixo: “CCAP” = Cancellation Response.| Sim |
|ProtocolVersion`<PrtcolVrsn>`|[1..1]|Text|Versão do protocolo utilizado na mensagem.| Sim |
|CreationDateTime`<CreDtTm>`|[0..1]|Text|Data de criação da mensagem| Não |
|CancellationResponse`<CxlRspn>`|[1..1]|Container|Informações relacionadas à resposta de cancelamento.| Sim |
|Environment`<Envt>`|[1..1]|Container|Ambiente da transação.| Sim |
|Merchant Identification`<MrchntId>`|[0..1]|Container|Dados do estabelecimento.| Não |
|Identification`<Id>`|[1..1]|Text|Identificação do estabelecimento comercial no adquirente. Também conhecido internamente como “SaleAffiliationKey”.| Sim |
|POIId`<POIId>`|[0..1]|Container|Dados do ponto de interação| Não |
|Identification`<Id>`|[1..1]|Text|Código de identificação do ponto de interação atribuído pelo estabelecimento (Campo ecoado).| Sim |
|Transaction`<Tx>`|[1..1]|Container|Dados da transação.| Sim |
|TransactionCapture`<TxCaptr>`|[1..1]|Bool|Indica se os dados da transação devem ser capturados `true` ou não `false` imediatamente.| Sim |
|TransactionIdentification`<TxId>`|[1..1]|Container|Identificação da transação atribuída pelo POI.| Sim |
|TransactionDateTime`<TxDtTm>`|[1..1]|DateTime|Data e hora local da transação definidas pelo ponto de interação.| Sim |
|TransactionReference`<TxRef>`|[1..1]|Text|Identificação da transação definida pelo ponto de interação. Este campo será ecoado pelo adquirente.| Sim |
|TransactionDetails`<TxDtls>`|[1..1]|Container|Detalhes da transação| Sim |
|Currency`<Ccy>`|[1..1]|CodeSet|Moeda utilizada na transação em conformidade com a ISO 4217.| Sim |
|TotalAmount`<TtlAmt>`|[1..1]|Amount|Valor total da transação em centavos.| Sim |
|TransactionResponse`<TxRspn>`|[1..1]|Container| Dados de resposta da transação.| Sim |
|AuthorisationResult`<AuthstnRslt>`|[1..1] |Container| Informações sobre o resultado da autorização a ser cancelada.| Sim |
|ResponseToAuthorisation`<RspnToAuthstn>`|[1..1]|Container|Dados de resposta da autorização a ser cancelada.| Sim |
|Response`<Rspn>`|[1..1]|CodeSet|Resposta da transação. DECL: Declined; APPR: Aproved; PART: PartialApproved; TECH: TechinicalError;| Sim |
|ResponseReason`<RspnRsn>`|[0..1]|Text|Código de resposta da autorização.| Não |
|CompletionRequired`<CmpltnReqrd>`|[0..1]|Bool|Indica se a mensagem precisa ser capturada posteriormente.| Não |

#
### Legendas

Ocorrência<br>
[0..0] -> Dado não obrigatório no envio da requisição e na resposta<br>
[0..1] -> Dado não obrigatório no envio da requisição, porém obrigatório na resposta<br>
[1..0] -> Dado obrigatório no envio da requisição, porém não obrigatório na resposta<br>
[1..1] -> Dado obrigatório no envio da requisição e na resposta<br>

#

# Códigos de retorno

Os códigos de retorno listados abaixo fazem referência aos possíveis retornos do campo **ResponseReason** `<RspnRsn>`

## Transações APROVADAS
| Código | Mensagem | Orientação | Pode retentar? |
| ------ | -------- | ---------- | -------------- |
| 0000 | Transação autorizada | # | # |
| 0001 | Transação autoriada | Verifique a identidade antes de autorizar | # |

## Transações NEGADAS
| Código | Mensagem | Orientação | Pode retentar? |
| ------ | -------- | ---------- | -------------- |
| 1000 | Transação não autorizada | # | # |
| 1001 | Cartão vencido | # | # |
| 1002 | Transação não permitida | # | # |
| 1003 | Rejeitado emissor | Oriente o portador a entrar em contato com o banco emissor do cartão. | # |
| 1004 | Cartão com restrição | Oriente o portador a entrar em contato com o banco emissor do cartão. | # |
| 1005 | Transação não autorizada | # | # |
| 1006 | Tentativas de senha excedidas  | # | # |
| 1007 | Rejeitado emissor | Oriente o portador a entrar em contato com o banco emissor do cartão. | # |
| 1008 | Rejeitado emissor | Oriente o portador a entrar em contato com o banco emissor do cartão. | # |
| 1009 | Transação não autorizada | # | # |
| 1010 | Valor inválido | # | # |
| 1011 | Cartão inválido | # | # |
| 1013 | Transação não autorizada  | # | # |
| 1014 | Tipo de conta inválido | O tipo de conta selecionado não existe. Ex: uma transação de crédito com um cartão de débito. | # |
| 1016 | Saldo insuficiente | # | Sim |
| 1017 | Senha inválida | # | Sim |
| 1019 | Transação não permitida | # | # |
| 1020 | Transação não permitida  | # | # |
| 1021 | Rejeitado emissor | Oriente o portador a entrar em contato com o banco emissor do cartão. | # |
| 1022 | Cartão com restrição | # | # |
| 1023 | Rejeitado emissor | Oriente o portador a entrar em contato com o banco emissor do cartão. | # |
| 1024 | Transação não permitida  | # | # |
| 1025 | Cartão bloqueado | Oriente o portador a entrar em contato com o banco emissor do cartão. | # |
| 1042 | Tipo de conta inválido | O tipo de conta selecionado não existe. Ex: uma transação de crédito com um cartão de débito. | # |
| 1045 | Código de segurança inválido | # | Sim |
| 2000 | Cartão com restrição | # | # |
| 2001 | Cartão vencido | # | # |
| 2002 | Transação não permitida | # | # |
| 2003 | Rejeitado emissor | Oriente o portador a entrar em contato com o banco emissor do cartão. | # |
| 2004 | Cartão com restrição | Oriente o portador a entrar em contato com o banco emissor do cartão. | # |
| 2005 | Transação não autorizada  | # | # |
| 2006 | Tentativas de senha excedidas | # | # |
| 2007 | Cartão com restrição | # | # |
| 2008 | Cartão com restrição | # | # |
| 2009 | Cartão com restrição | # | # |
| 9102 | Transação inválida | # | # |
| 9108 | Erro no processamento | # | Sim |
| 9109 | Erro no processamento | # | Sim |
| 9111 | Time-out na transação | # | Sim |
| 9112 | Emissor indisponível | # | Sim |
| 9999 | Erro não especificado | # | # |

