---
title: Conciliação Stone

language_tabs:

- xml: XML
- xml: XML Captura
- xml: XML Liquidação
- xml: XML Cancelamento
- xml: XML Chargeback
- xml: XML Evento

search: true
---

# O que é?

## Conciliação Stone

A **Conciliação Stone** é uma ferramenta que disponibiliza diariamente aos estabelecimentos, a demonstração das transações realizadas e suas respectivas informações financeiras, aluguel de POS, ocorridos no dia referenciado. Esta ferramenta permite o acompanhamento desde a captura até o pagamento/desconto de cada uma das transações e lançamentos realizados.

Com a **Conciliação Stone**, o lojista consegue visualizar de forma bastante clara, o valor líquido e bruto de cada parcela, o valor líquido e bruto de cancelamento parcial e total, quais parcelas da transação foram antecipadas e qual foi o custo da antecipação de cada parcela, chargebacks a serem descontados, etc.

Tudo isto em um mesmo lugar, sem a necessidade de tratar vários arquivos com layouts diferentes. Com a **Conciliação Stone**, o cliente obtém o arquivo de conciliação diretamente conosco, de maneira segura, através de um Webservice que retorna o arquivo de conciliação.

# Como obter seu arquivo

## O serviço de conciliação

O webservice de conciliação consiste em uma requisição HTTP autenticada, utilizando uma camada segura - SSL/TLS, para a obtenção de um arquivo com todos os eventos ocorridos no dia requisitado.

Esse arquivo contém todas as transações que foram capturadas no dia requisitado, ou seja, todas as transações capturadas no dia para o qual a conciliação está sendo gerada. **É importante ressaltar que o arquivo contém apenas as transações que foram capturadas e não as que somente foram autorizadas, uma vez que esse tipo de transação não gera movimento financeiro**.

O arquivo adota o modelo Previsão-Liquidação, diferente do que é praticado no mercado. Isso quer dizer que no Arquivo de Conciliação da Stone, estão presentes informações sobre a previsão de pagamento das transações e dos ajustes (agenda); e informações sobre a liquidação das transações e dos ajustes (extrato). **É importante ressaltar que em prol da maior transparência, as transações canceladas não são tratadas como ajustes**.

## Obtendo o arquivo

As requisições devem ser enviadas para o serviço de conciliação utilizando o método **GET** para o endpoint `https://conciliation.stone.com.br/conciliation-file/{dataReferencia}` ou `https://conciliation.stone.com.br/conciliation-file/v{numeroversao}/{dataReferencia}`, onde `{dataReferencia}` é a data em que as transações foram capturadas, no formato yyyyMMdd e {numeroversao} o número da versão do layout desejado.

**EndPoint**: "https://conciliation.stone.com.br/conciliation-file/v2/yyyyMMdd"

Por se tratar de informações sigilosas para a empresa, tanto a requisição quanto a resposta trafegam em uma camada segura criptografada e as requisições precisam, necessariamente, estar autenticadas. Essa autenticação consiste no envio de um campo de cabeçalho HTTP `Authorization` contendo a chave de afiliação da loja `AffiliationKey`.

É possível, ainda, que o volume de operações e eventos seja relativamente grande. Para agilizar a transferência do arquivo, é possível solicitá-lo de forma compactada. Caso seja necessário que o arquivo esteja compactado, o sistema conciliador deve incluir o campo de cabeçalho HTTP `Accept-Encoding: gzip` na requisição ao serviço.

<aside class="success"> <b>Pré-requisitos:</b>

<ol>
<li>Conexão com a internet</li>

<li>Protocolo de comunicação TLS 1.2</li>

<li>AffiliationKey (AK)</li>
</ol>

</aside>

# O Arquivo

### Conciliation

Nó principal do arquivo de conciliação

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| Header   | Container | ###### | Contém as informações do lojista e do arquivo |
| FinancialTransactions | Container | ###### | Contém as transações que aconteceram com o lojista no dia requisitado |
| FinancialEvents | Container | ###### | Contém os eventos financeiros lançados para o lojista no dia requisitado |
| FinancialTransactionsAccounts | Container | ###### | Contém as transações que foram pagas/cobradas ao lojista no dia requisitado |
|FinancialEventAccounts | Container | ###### | Contém os eventos que foram pagos/cobrados ao lojista no dia requisistado |
| Payments | Container | ###### |  Contém informações dos pagamentos efetuados relativos as transações e eventos financeiros do arquivo. |
| Trailer | Container | ###### | Contém os totalizadores e contadores do arquivo |

### Header

Descrição dos atributos dentro de **Header**

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| GenerationDateTime | Datetime | 14 | Datetime de geração do arquivo (Formato: aaaammddHHmmss)|
| StoneCode | Num | 9 | Código identificador da loja |
| LayoutVersion | Num | 3 | Versão do Layout do arquivo |
| FileId | Num | 26 | Código identificador do arquivo |
| ReferenceDate |Date|8| Data a que se refere o arquivo|

### FinancialTransactions

Descrição dos Containers e atributos dentro de *FinancialTransactions**.

* Contém uma lista de **Transaction**

### Transaction

Nó filho de **FinancialTransactions** que contém as informações referentes à transação, como valor total da transação, número de parcelas da transação, etc.

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| [Events](#Events)| Container | ###### | Contém contadores dos eventos da transação no dia de referência do arquivo.|
| AcquirerTransactionKey | Num | 14 | Identificador único da transação (NSU) gerado pela adquirente|
| InitiatorTransactionKey | Alfa | 128 | Código recebido pelo sistema cliente |
| AuthorizationDateTime| Datetime | 14 | Datetime da autorização (Formato: aaaammddHHmmss) |
| CaptureLocalDateTime | Datetime | 14 | Datetime da captura (Formato: aaaammddHHmmss) no horario local da adquirente|
| International* | Bool | # | Indica se é um cartão internacional (True/False)|
| [AccountType*](#ProductType) | Alfa | 4 | Tipo de conta utilizada na transação crédito, débito, etc...* |
| [InstallmentType*](#SalePlanType) | Alfa | 60 | Tipo de parcelamento utilizado na transação lojista/emissor* |
| NumberOfInstallments* | Num | 4 | Número de parcelas* |
| AuthorizedAmount* | Float | 20 | Valor autorizado* |
| CapturedAmount* | Float | 20 | Valor capturado* |
| CanceledAmount* | Float | 20 | Total cancelado* |
| AuthorizationCurrencyCode* | Num | 4 | Código da moeda* |
| IssuerAuthorizationCode* | Num | 6 | Código da autorização fornecido pelo emissor.* |
| [BrandId*](#Brand) | Num | 2 | Identificador da bandeira do cartão* |
| CardNumber* | Alfa | 19 | Número do cartão (truncado)* |
| Poi | Container | ###### | Contém dados do Ponto de Interação (terminal) que realizou a transação|
| **Cancellations**** | Container | ###### | Contém informações referentes aos cancelamentos, como data de desconto do cancelamento e valor total do cancelamento.** |
| **Installments**| Container | ###### | Contém as parcelas da transação. |


<aside class="notice"> <b>Informativo (Transaction)</b>

	<ul>

	<li>* Elementos que aparecem apenas quando a transação é de captura<em> &lt;Captures&gt; 1 &lt;/Captures&gt; </em></li>

	<li>** Elemento que aparece apenas quando a transação é de cancelamento<em> &lt;Cancellations&gt;1&lt;/Cancellations&gt; </em></li>

	</ul>

</aside>

### Events

Nó filho de Transaction, contém contadores dos eventos de uma transação no dia de referência do arquivo.

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| CancellationCharges | Num | 9 | Número de descontos de cancelamento|
| Cancellations | Num | 9 | Número de cancelamentos|
| Captures | Num | 9 | Número de capturas|
| ChargebackRefunds | Num | 9 | Número de estornos de chargeback |
| Chargebacks | Num | 9 | Número de chargebacks |
| Payments | Num | 9 | Número de pagamentos |


### Poi

Contém dados do Ponto de Interação (terminal) que realizou a transação.

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| [PoiType](#CaptureMethod) | Num | 4 | Tipo do ponto de interação (e-commerce, pos, mobile, etc).|
| SerialNumber | Num | 32 | Número de série do terminal, se existir |

### Cancellations

Contém uma lista de **Cancellation**

### Cancellation

Nó filho de **Cancellations** que contém as informações sobre o cancelamento de uma transação

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| OperationKey | Alfa | 32 | identificador único da operação de cancelamento|
| CancellationDateTime | Datetime | 14 |Data hora do cancelamento (Formato: aaaammddHHmmss)|
| ReturnedAmount | Float | 20 | Valor revertido e devolvido ao portador do cartão |
| **Billing*** | Collection | ###### | Lista de cobranças relativa ao cancelamento* |


<aside class="notice"> <b>Informativo (Cancellation)</b>

	<ul>
		<li>* Aparece apenas se a transação não tiver sido cancelada no mesmo dia da captura.</li>
	</ul>

</aside>


### Billing

Cobrança relativa ao cancelamento.

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| ChargedAmount | Float | 20 | Valor de desconto do cancelamento (descontado do lojista)|
| PrevisionChargeDate | Datetime | 8 | Data prevista para cobrança  (Formato: aaaammdd) |


### Installments

Contém uma lista de **Installment** (parcelas)

### Installment

Nó filho de **Installments** que contém as informações sobre as parcelas de uma transação.

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| InstallmentNumber | Num | 2 | Número da parcela |
| GrossAmount | Float | 20 | Valor bruto da parcela |
| NetAmount | Float | 20 | Valor liquido da parcela |
| PrevisionPaymentDate* | Datetime | 8 | Previsão da data de pagamento (Formato: aaaammdd)|
| SuspendedByChargeback** | Bool | # | Este elemento aparecerá nas parcelas ainda não liquidadas quando uma transação sofrer Chargeback (Nunca aparecerá junto com PrevisionPaymentDate)|
| **Chargeback**^ | Container | ###### | Contém chargebacks relativos a parcela** |
| **ChargebackRefund**^^ | Container | ###### | Contém estornos de chargeback relativos a parcela*** |

<aside class="notice"> <b>Informativo (Installment)</b>

<ul>

 <li>* Elemento que aparecerá apenas quando a parcela não estiver suspensa por Chargeback</li>

 <li>** Elemento que aparecerá apenas nas parcelas posteriores à parcela que sofreu Chargeback</li>

 <li>^ Elemento só aparece quando houver <em>Chargeback</em></li>
 
 <li>^^ Elemento só aparece quando houver <em>Chargeback</em> ou <em>Liquidação do Chargeback</em> ou <em>Reapresentação de Chargeback</em></li>

</ul>

</aside>


### Chargeback

Nó filho de **Installment** que contém informações sobre o chargeback, como data de desconto, Id do chargeback, data em que ocorreu o chargeback, etc.

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| Id | Num | 10 | Identificador do chargeback |
| Amount | Float | 20 | Valor do chargeback |
| Date | Date | 8 | Data em que ocorreu o chargeback. (Formato: aaaammdd) |
| ChargeDate | Date | 8 | Data em que o chargeback será descontado. (Formato: aaaammdd) |
| ReasonCode | Num | 8 | Código de motivo do chargeback informado pelo banco emissor |

### ChargebackRefund

Nó filho de **Installment** que contém informações sobre a reapresentação do chargeback, como a data em que ocorreu a reapresentação, data de pagamento, etc.

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| Id | Num | 10 | Identificador da reapresentação do chargeback |
| Amount | Float | 20 | Valor da reapresentação do chargeback |
| Date | Date | 8 | Data em que ocorreu a reapresentação do chargeback. (Formato: aaaammdd) |
| PaymentDate | Date | 8 | Data em que a reapresentação o chargeback será creditada. (Formato: aaaammdd) |
| ReasonCode | Num | 8 | Código de motivo do chargeback informado pelo banco emissor |

## FinancialEvents

Descrição dos Containers e atributos dentro de **FinancialEvents**.

* Contém uma lista de **Event**

### Event

Nó filho de **FinancialEvents** , descreve os detalhes do evento ocorrido.

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| EventId | Num | 10 | Código identificador do evento |
| Description | Alfa | 60 | Descrição do evento |
| [Type](#Type) | Num | 2 | Tipo do evento |
| PrevisionPaymentDate | Date | 8 | Previsão da data de cobrança |
| Amount | Float | 20 | Valor do evento |

## FinancialTransactionsAccounts

Descrição dos Containers e atributos dentro de **FinancialTransactionsAccounts**.

* Contém uma lista de **Transaction**

Segue exatamente a mesma estrutura do nó **FinancialTransactions** descrito acima, com apenas algumas peculiariedades que serão demonstradas abaixo:

### Transaction

Nó filho de **FinancialTransactionsAccounts** que contém as informações referentes à transação, como valor total da transação, número de parcelas da transação, etc.

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| Events| Container | # | Igual ao descrito em [FinancialTransactions](#FinancialTransactions)|
| AcquirerTransactionKey | Num | 14 | Identificador único da transação (NSU) gerado pela adquirente|
| InitiatorTransactionKey | Alfa | 128 | Código recebido pelo sistema cliente |
| AuthorizationDateTime| Datetime | 14 | Datetime da autorização (Formato: aaaammddHHmmss) |
| CaptureLocalDateTime | Datetime | 14 | Datetime da captura (Formato: aaaammddHHmmss) no horario local da adquirente|
| **Poi***| Container | # | Igual ao descrito em [FinancialTransactions](#FinancialTransactions)|
| **Cancellations*** | Container | # | Igual ao descrito em [FinancialTransactions](#FinancialTransactions), com algumas mudanças |
| **Installments***| Container | # | Igual ao descrito em [FinancialTransactions](#FinancialTransactions), com algumas mudanças |

<aside class="notice"> <b>Informativo (Transaction)</b>
<ul>
<li>* Elemento que aparecerá quando houver o desconto de um cancelamento <em>&lt;CancellationCharges&gt;1&lt;CancellationCharges&gt;</em></li>
</ul>
</aside>

 <aside class="warning"> <b>Alerta!!!</b>
<ul>

<li><b>É importante armazenar as informações como IssuerAuthorizationCode, CardNumber, BrandId e etc, durante o evento de captura. Pois quando a transação aparecer em FinancialTransactionsAccounts (liquidação), virá apenas com os NSU para que possa identificar qual transação está sendo paga/descontada.</b></li>

</ul>
</aside>

### Cancellations

Contém uma lista de **Cancellation**

### Cancellation

Nó filho de **Cancellations** que contém as informações sobre o desconto de um cancelamento

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| InstallmentNumber| Num | 2 | Identificador único da operação de cancelamento |
| OperationKey | Alfa | 32 | Identificador da parcela que foi descontada|
| CancellationDateTime | Datetime | 14 | Data hora do cancelamento (Formato: aaaammddHHmmss) |
| ReturnedAmount | Float | 20 | Valor revertido e devolvido ao portador do cartão |
| **Billing** | Container | # | Lista de cobranças relativa ao cancelamento |


### Billing

Cobrança relativa ao cancelamento.

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| ChargedAmount | Float | 20 | Valor de desconto do cancelamento (descontado do lojista)|
| ChargeDate | Datetime | 8 | Data de cobrança (Formato: aaaammdd)|

### Installments

Contém uma lista de **Installment** (parcelas)

### Installment

Nó filho de **Installments** que contém as informações sobre as parcelas de uma transação.

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| InstallmentNumber | Num | 2 | Número da parcela |
| GrossAmount | Float | 20 | Valor bruto da parcela |
| NetAmount | Float | 20 | Valor liquido da parcela |
| PaymentDate | Datetime | 8 | Data de pagamento da parcela. (Formato: aaaammdd)|
| AdvanceRateAmount | Float | 20 | Valor cobrado pela antecipação de recebível* |
| AdvancedReceivableOriginalPaymentDate* | Datetime | 8 | Data original de pagamento do recebível adiantado* |
| SuspendedByChargeback** | Alfa | 4 | Marcador se o pagamento da parcela está suspensa por Chargeback\*\*\*\* |
| Chargeback | Container | ###### | Contém chargebacks relativos a parcela** |
| ChargebackRefund | Container | ###### | Contém estornos de chargeback relativos a parcela\*** |
| PaymentId | Num | 9 | Referência do elemento de pagamento (Payments) no qual a liquidação dessa parcela foi incluida |
| **Chargeback**^ | Container | # | Referência do elemento de pagamento (Payments) no qual a liquidação dessa parcela foi incluida |
| **ChargebackRefund**^^ | Container | # | Referência do elemento de pagamento (Payments) no qual a liquidação dessa parcela foi incluida |

<aside class="notice">  <b>Informativo (Installment | FinancialTransactionsAccounts)</b>

<ul>

<li>* Elementos que só aparecem quando houver antecipação</li>

<li>** Elemento que só aparece quando houve Chargeback</li>

<li>^ Elemento que só aparece quando houve Chargeback e Reapresentação de Chargeback</li>

<li>^^ Aparece apenas nas parcelas posteriores à parcela que sofreu chargeback</li>

</ul>

</aside>


## FinancialEventAccounts

Descrição dos Containers e atributos dentro de **FinancialEventsAccounts**.

* Contém uma lista de **Event**

### Event

Nó filho de FinancialEventsAccounts, contém as informações dos eventos financeiros pagos ou descontados no dia de referência do arquivo (ajustes financeiros, aluguel de pos, etc…)

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| EventId | Num | 10 | Código identificador do evento |
| Description | Alfa | 60 | Descrição do evento |
| [Type](#type) | Num | 2 | Tipo do evento (Poderá identificar se é uum crédito ou um débito através do sinal. Ex: -22 (Debito), 5 (Credito) |
| PaymentDate | Date | 8 | Data em que o evento foi pago. (Formato: aaaammdd) |
| Amount | Float | 20 | Valor do evento |

## Payments

Descrição dos Containers e atributos dentro de **Payments**.

* Contém uma lista de **Payment**

### Payment

Nó filho de **Payments**, representa um pagamento efetuado para o lojista.

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| Id | Num | 9 | Identificador do pagamento |
| TotalAmount | Float | 20 | Valor total depositado na conta do lojista |
| TotalFinancialAccountsAmount* | Float | 24 | Valor total que o lojista tem disponível para receber no dia |
| LastNegativeAmount** | Float | 24 | Valor negativo que o cliente tem pendente com a Stone |
| FavoredBankAccount | Container | # | Informações bancarias da conta favorecida pelo pagamento |

<aside class="notice"> <b>Informativo (Payments)</b>

O nó <b>Payment</b> aparecerá apenas quando for feito um depósito na conta. Não aparecerá em situações em que os descontos forem maior que os recebíveis do dia.
<ul>
<li>* Quando o valor desse elemento for negativo, o valor total pago no dia ao lojista <em>TotalAmount</em> será zero.</li>

<li>** O valor negativo pendente será descontado do valor total que o lojista tem para receber, caso esse total seja positivo <em>TotalFinancialAccountsAmount</em>.</li>

</ul>
</aside>

### FavoredBankAccount

Nó filho de **Payment**. Contém as informações bancárias da conta em que foi feito o depósito.

| Elemento | Tipo | Tamanho | Descrição |
| -------- | ---- | ------- | --------- |
| BankCode | Num | 4 | Código do banco favorecido de acordo com o [Banco Central](http://www.bcb.gov.br/?RELAGPAB) |
| BankBranch | Alfa | 10 | 	Código da agência do banco de acordo com o [Banco Central](http://www.bcb.gov.br/?RELAGPAB) |
| BankAccountNumber | Num | 12 | Número da conta favorecida |

## Trailer

Descrição dos atributos dentro de **Trailer**

| Elemento | Tipo | Tamanho | Descrição |
| :-------- | ---- | ------- | --------- |
| CapturedTransactionsQuantity | Num | 9 | Número de transações capturadas |
| CanceledTransactionsQuantity | Num | 9 | Número de transações canceladas |
| PaidInstallmentsQuantity | Num | 9 | Número de transações pagas |
| ChargedCancellationsQuantity | Num | 9 | Número de cancelamentos descontados |
| ChargebacksQuantity | Num | 9 | Número de chargebacks |
| ChargebacksRefundQuantity | Num | 9 | Número de estornos de chargeback |
| ChargedChargebacksQuantity | Num | 9 | Número de chargebacks descontados |
| PaidChargebacksRefundQuantity | Num | 9 | Número de estornos de chargebacks pagos |
| PaidEventsQuantity  | Num | 9 | Número de eventos financaeiros pagos |
| ChargedEventsQuantity  | Num | 9 | Número de eventos financaeiros descontados |

# Layout V2

## O Fluxo

Toda transação nova ou acontecimento de uma transação já existente será demonstrada no arquivo de diferentes maneiras. Abaixo demonstrarei os principais fluxos:

<aside class="success"> <b>Captura</b>

<ul>
<li>Quando uma transação é realizada, um nó <em>Transaction</em> referente à ela aparecerá sob <em>FinancialTransactions</em> no arquivo de conciliação desse dia com o evento <em>Captures</em> com o valor 1 em <em>Event</em>, dentro do nó transaction se encontrará todas as parcelas dessa transação representadas pelos nós <em>Installment</em>.</li>
</ul>

</aside>

### Exemplos de ciclo de vida da captura:

`Captura (10/05) > Liquidação da Parcela (09/06)`



```xml

<!-- Captura -->

<FinancialTransactions>
  ...
   <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>1</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <International>True</International>
            <AccountType>2</AccountType>
            <InstallmentType>1</InstallmentType>
            <NumberOfInstallments>1</NumberOfInstallments>
            <AuthorizedAmount>694.000000</AuthorizedAmount>
            <CapturedAmount>694.000000</CapturedAmount>
            <AuthorizationCurrencyCode>986</AuthorizationCurrencyCode>
            <IssuerAuthorizationCode>054973</IssuerAuthorizationCode>
            <BrandId>1</BrandId>
            <CardNumber>411111******1111</CardNumber>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PrevisionPaymentDate>20160609</PrevisionPaymentDate>
                </Installment>
            </Installments>
        </Transaction>
  ...
</FinancialTransactions>

``` 

```xml

<!-- Liquidação Parcela 1-->

<FinancialTransactionsAccounts>
  ...
    <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>1</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PaymentDate>20160609</PaymentDate>
                    <PaymentId>1234567</PaymentId>
                </Installment>
            </Installments>
       </Transaction>
    ...
<FinancialTransactionsAccounts>
 ...
<Payments>
        <Payment>
            <Id>1234567</Id>
            <TotalAmount>14185.81</TotalAmount>
            <TotalFinancialAccountsAmount>14185.81</TotalFinancialAccountsAmount>
            <LastNegativeAmount>0.00</LastNegativeAmount>
            <FavoredBankAccount>
                <BankCode>XX</BankCode>
                <BankBranch>XXXX</BankBranch>
                <BankAccountNumber>XXXXXXXXX</BankAccountNumber>
            </FavoredBankAccount>
        </Payment>
</Payments>

``` 

<aside class="success"> Cancelamento

<ul>

<li>Quando uma transação é cancelada no dia de referência, um nó <em>Transaction</em> referente a ela aparecerá sob <em>FinancialTransactions</em> no arquivo de conciliação desse dia com o evento <em>Cancellations</em> com o valor 1 em <em>Event</em>, dentro do nó <em>Transaction</em> aparecerá um nó chamado <em>Cancellations</em> que descreve cada cancelamento (vários se houver cancelamentos parciais, ou apenas um se for cancelamento total)</li>

</ul>

</aside>

### Exemplos de ciclos de vida da cancelamento:

`Captura (10/05) > Liquidação da Parcela (09/06) > Cancelamento (10/06) > Desconto do Cancelamento (12/06)`


```xml

<!-- Captura-->

<FinancialTransactions>
  ...
   <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>1</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <International>True</International>
            <AccountType>2</AccountType>
            <InstallmentType>1</InstallmentType>
            <NumberOfInstallments>1</NumberOfInstallments>
            <AuthorizedAmount>694.000000</AuthorizedAmount>
            <CapturedAmount>694.000000</CapturedAmount>
            <AuthorizationCurrencyCode>986</AuthorizationCurrencyCode>
            <IssuerAuthorizationCode>054973</IssuerAuthorizationCode>
            <BrandId>1</BrandId>
            <CardNumber>411111******1111</CardNumber>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PrevisionPaymentDate>20160609</PrevisionPaymentDate>
                </Installment>
            </Installments>
        </Transaction>
  ...
</FinancialTransactions>

```

```xml

<!-- Liquidação Parcela 1-->

<FinancialTransactionsAccounts>
  ...
    <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>1</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PaymentDate>20160609</PaymentDate>
                    <PaymentId>1234567</PaymentId>
                </Installment>
            </Installments>
       </Transaction>
    ...
<FinancialTransactionsAccounts>
 ...
<Payments>
        <Payment>
            <Id>1234567</Id>
            <TotalAmount>14185.81</TotalAmount>
            <TotalFinancialAccountsAmount>14185.81</TotalFinancialAccountsAmount>
            <LastNegativeAmount>0.00</LastNegativeAmount>
            <FavoredBankAccount>
                <BankCode>XX</BankCode>
                <BankBranch>XXXX</BankBranch>
                <BankAccountNumber>XXXXXXXXX</BankAccountNumber>
            </FavoredBankAccount>
        </Payment>
</Payments>

```


```xml

<!-- Cancelamento-->

<FinancialTransactions>
  ...
    <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>1</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Cancellations>
                <Cancellation>
                    <InstallmentNumber>1</InstallmentNumber>
                    <OperationKey>2276000071307928</OperationKey>
                    <CancellationDateTime>20160610040236</CancellationDateTime>
                    <ReturnedAmount>694.000000</ReturnedAmount>
                    <Billing>
                        <ChargedAmount>678.454400</ChargedAmount>
                        <PrevisionChargeDate>20160612</PrevisionChargeDate>
                    </Billing>
                </Cancellation>
           </Cancellations>
       </Transaction>
    ...
<FinancialTransactions>
```

```xml

<!-- Liquidação Cancelamento-->

<FinancialTransactionsAccounts>
  ...
    <Transaction>
            <Events>
                <CancellationCharges>1</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Cancellations>
                <Cancellation>
                    <InstallmentNumber>1</InstallmentNumber>
                    <OperationKey>2276000071307928</OperationKey>
                    <CancellationDateTime>20160610040236</CancellationDateTime>
                    <ReturnedAmount>694.000000</ReturnedAmount>
                    <Billing>
                        <ChargedAmount>678.454400</ChargedAmount>
                        <ChargeDate>20160612</ChargeDate>
                    </Billing>
                </Cancellation>
            </Cancellations>
       </Transaction>
    ...
<FinancialTransactionsAccounts>
```

`Captura (10/05) > Liquidação da Parcela (09/06) > Cancelamento (10/06) > Desconto do Cancelamento (12/06)`


```xml

<!-- Captura-->

<FinancialTransactions>
  ...
   <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>1</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <International>True</International>
            <AccountType>2</AccountType>
            <InstallmentType>1</InstallmentType>
            <NumberOfInstallments>3</NumberOfInstallments>
            <AuthorizedAmount>1099.000000</AuthorizedAmount>
            <CapturedAmount>694.000000</CapturedAmount>
            <AuthorizationCurrencyCode>986</AuthorizationCurrencyCode>
            <IssuerAuthorizationCode>054973</IssuerAuthorizationCode>
            <BrandId>1</BrandId>
            <CardNumber>411111******1111</CardNumber>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>366.340000</GrossAmount>
                    <NetAmount>357.657742</NetAmount>
                    <PrevisionPaymentDate>20160609</PrevisionPaymentDate>
                </Installment>
                <Installment>
                    <InstallmentNumber>2</InstallmentNumber>
                    <GrossAmount>366.330000</GrossAmount>
                    <NetAmount>357.647979</NetAmount>
                    <PrevisionPaymentDate>20160709</PrevisionPaymentDate>
                </Installment>
                <Installment>
                    <InstallmentNumber>3</InstallmentNumber>
                    <GrossAmount>366.330000</GrossAmount>
                    <NetAmount>357.647979</NetAmount>
                    <PrevisionPaymentDate>20160809</PrevisionPaymentDate>
                </Installment>
            </Installments>
        </Transaction>
  ...
</FinancialTransactions>
```

```xml

<!-- Liquidação Parcela 1-->

<FinancialTransactionsAccounts>
  ...
    <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>1</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>366.340000</GrossAmount>
                    <NetAmount>357.657742</NetAmount>
                    <PaymentDate>20160609</PaymentDate>
                    <PaymentId>1234567</PaymentId>
                </Installment>
            </Installments>
       </Transaction>
    ...
<FinancialTransactionsAccounts>
 ...
<Payments>
        <Payment>
            <Id>1234567</Id>
            <TotalAmount>14185.81</TotalAmount>
            <TotalFinancialAccountsAmount>14185.81</TotalFinancialAccountsAmount>
            <LastNegativeAmount>0.00</LastNegativeAmount>
            <FavoredBankAccount>
                <BankCode>XX</BankCode>
                <BankBranch>XXXX</BankBranch>
                <BankAccountNumber>XXXXXXXXX</BankAccountNumber>
            </FavoredBankAccount>
        </Payment>
</Payments>
```

```xml

<!-- Cancelamento-->

<FinancialTransactions>
  ...
    <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>1</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Cancellations>
                <Cancellation>
                    <InstallmentNumber>1</InstallmentNumber>
                    <OperationKey>2276000071307928</OperationKey>
                    <CancellationDateTime>20160610040236</CancellationDateTime>
                    <ReturnedAmount>366.340000</ReturnedAmount>
                    <Billing>
                        <ChargedAmount>357.657742</ChargedAmount>
                        <PrevisionChargeDate>20160612</PrevisionChargeDate>
                    </Billing>
                </Cancellation>
                <Cancellation>
                    <InstallmentNumber>2</InstallmentNumber>
                    <OperationKey>2276000071307928</OperationKey>
                    <CancellationDateTime>20160610040236</CancellationDateTime>
                    <ReturnedAmount>366.330000</ReturnedAmount>
                    <Billing>
                        <ChargedAmount>357.647979</ChargedAmount>
                        <PrevisionChargeDate>20160612</PrevisionChargeDate>
                    </Billing>
                </Cancellation>
                <Cancellation>
                    <InstallmentNumber>3</InstallmentNumber>
                    <OperationKey>2276000071307928</OperationKey>
                    <CancellationDateTime>20160610040236</CancellationDateTime>
                    <ReturnedAmount>366.330000</ReturnedAmount>
                    <Billing>
                        <ChargedAmount>357.647979</ChargedAmount>
                        <PrevisionChargeDate>20160612</PrevisionChargeDate>
                    </Billing>
                </Cancellation>
           </Cancellations>
       </Transaction>
    ...
<FinancialTransactions>
```

```xml

<!-- Desconto do Cancelamento-->

<FinancialTransactionsAccounts>
  ...
    <Transaction>
            <Events>
                <CancellationCharges>3</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>2</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <!--Aceleração das parcelas-->
                <Installment>
                    <InstallmentNumber>2</InstallmentNumber>
                    <GrossAmount>366.330000</GrossAmount>
                    <NetAmount>357.647979</NetAmount>
                    <PaymentDate>20160612</PaymentDate>
                    <PaymentId>1234567</PaymentId>
                </Installment>
                <Installment>
                    <InstallmentNumber>3</InstallmentNumber>
                    <GrossAmount>366.330000</GrossAmount>
                    <NetAmount>357.647979</NetAmount>
                    <PaymentDate>20160612</PaymentDate>
                    <PaymentId>1234567</PaymentId>
                </Installment>
            </Installments>
            <Cancellations>
                <!--Cancelamento das parcelas aceleradas-->
                <Cancellation>
                    <InstallmentNumber>1</InstallmentNumber>
                    <OperationKey>2276000071307928</OperationKey>
                    <CancellationDateTime>20160610040236</CancellationDateTime>
                    <ReturnedAmount>366.340000</ReturnedAmount>
                    <Billing>
                        <ChargedAmount>357.657742</ChargedAmount>
                        <ChargeDate>20160612</ChargeDate>
                    </Billing>
                </Cancellation>
                <Cancellation>
                    <InstallmentNumber>2</InstallmentNumber>
                    <OperationKey>2276000071307928</OperationKey>
                    <CancellationDateTime>20160610040236</CancellationDateTime>
                    <ReturnedAmount>366.330000</ReturnedAmount>
                    <Billing>
                        <ChargedAmount>357.647979</ChargedAmount>
                        <ChargeDate>20160612</ChargeDate>
                    </Billing>
                </Cancellation>
                <Cancellation>
                    <InstallmentNumber>3</InstallmentNumber>
                    <OperationKey>2276000071307928</OperationKey>
                    <CancellationDateTime>20160610040236</CancellationDateTime>
                    <ReturnedAmount>366.330000</ReturnedAmount>
                    <Billing>
                        <ChargedAmount>357.647979</ChargedAmount>
                        <ChargeDate>20160612</ChargeDate>
                    </Billing>
                </Cancellation>
            </Cancellations>
       </Transaction>
    ...
<FinancialTransactionsAccounts>
```

<aside class="notice"> <b>Aceleração de Parcelas</b>

<ul>

<li>Acima podemos ver o exemplo de um fluxo de <b>Aceleração de parcelas<b>. Ou seja, se eu tenho uma transação de 2 parcelas, e após a liquidação da primeira parcela é enviado um cancelamento, no dia do desconto do cancelamento, é feita a aceleração da liquidação das parcelas restantes para liberar o saldo do cliente. Perceba que a PaymentDate no dia 12/06 foi antecipada.</li>

</ul>

</aside>

`Captura (10/05) > Cancelamento (10/05)`

```xml

<!-- Captura + Cancelamento-->

<FinancialTransactions>
  ...
   <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>1</Cancellations>
                <Captures>1</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <International>True</International>
            <AccountType>2</AccountType>
            <InstallmentType>1</InstallmentType>
            <NumberOfInstallments>3</NumberOfInstallments>
            <AuthorizedAmount>1099.000000</AuthorizedAmount>
            <CapturedAmount>694.000000</CapturedAmount>
            <AuthorizationCurrencyCode>986</AuthorizationCurrencyCode>
            <IssuerAuthorizationCode>054973</IssuerAuthorizationCode>
            <BrandId>1</BrandId>
            <CardNumber>411111******1111</CardNumber>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Cancellations>
                <Cancellation>
                    <OperationKey>2316000073093085</OperationKey>
                    <CancellationDateTime>20160510104014</CancellationDateTime>
                    <ReturnedAmount>694.000000</ReturnedAmount>
                </Cancellation>
            </Cancellations>
        </Transaction>
  ...
</FinancialTransactions>
```

<aside class="notice"> <b>Captura + Cancelamento</b>

<ul>

<li>Repare que quando o cancelamento é feito no mesmo dia da captura, o nó <em>Billing</em> não aparece, ou seja, não é agendado uma data de desconto do cancelamento.</li>

</ul>

</aside>

<aside class="success"> <b>Chargeback</b>

<ul>

<li>Quando uma transação sofre chargeback ela aparece tanto em <em>FinancialTransactions</em> no dia em que sofreu o chargeback, e em <em>FinancialTransactionAccounts</em> no dia em que foi descontada.</li>

</ul>

</aside>

### Exemplos de ciclos de vida do Chargeback:

`Captura (10/05) > Liquidação da Parcela (09/06) > Chargeback + Desconto do Chargeback (10/06)`

```xml

<!-- Captura-->

<FinancialTransactions>
  ...
   <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>1</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <International>True</International>
            <AccountType>2</AccountType>
            <InstallmentType>1</InstallmentType>
            <NumberOfInstallments>1</NumberOfInstallments>
            <AuthorizedAmount>694.000000</AuthorizedAmount>
            <CapturedAmount>694.000000</CapturedAmount>
            <AuthorizationCurrencyCode>986</AuthorizationCurrencyCode>
            <IssuerAuthorizationCode>054973</IssuerAuthorizationCode>
            <BrandId>1</BrandId>
            <CardNumber>411111******1111</CardNumber>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PrevisionPaymentDate>20160609</PrevisionPaymentDate>
                </Installment>
            </Installments>
        </Transaction>
  ...
</FinancialTransactions>
```


```xml

<!-- Liquidação da Parcela-->

<FinancialTransactionsAccounts>
  ...
    <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>1</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PaymentDate>20160609</PaymentDate>
                    <PaymentId>1234567</PaymentId>
                </Installment>
            </Installments>
       </Transaction>
    ...
<FinancialTransactionsAccounts>
 ...
<Payments>
        <Payment>
            <Id>1234567</Id>
            <TotalAmount>14185.81</TotalAmount>
            <TotalFinancialAccountsAmount>14185.81</TotalFinancialAccountsAmount>
            <LastNegativeAmount>0.00</LastNegativeAmount>
            <FavoredBankAccount>
                <BankCode>XX</BankCode>
                <BankBranch>XXXX</BankBranch>
                <BankAccountNumber>XXXXXXXXX</BankAccountNumber>
            </FavoredBankAccount>
        </Payment>
</Payments>
```


```xml

<!-- Chargeback + Desconto Chargeback-->

<FinancialTransactions>
  ...
    <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>1</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PrevisionPaymentDate>20160609</PrevisionPaymentDate>
                    <Chargeback>
                        <Id>187384389</Id>
                        <Amount>678.454400</Amount>
                        <Date>20160610</Date>
                        <ChargeDate>20160610</ChargeDate>
                        <ReasonCode>83</ReasonCode>
                    </Chargeback>
                </Installment>
            </Installments>
       </Transaction>
    ...
<FinancialTransactions>
```

<aside class="notice">  <b>Chargeback após liquidação da parcela</b>
<ul>

<li>Caso o chargeback ocorra após a liquidação da parcela, ele reaparecerá dentro de <em>Installment</em> e sua liquidação será imediata, sem a necessidade de aparecer novamente dentro de <em>FinancialTransactionsAccounts</em>.</li>

</ul>

</aside>

`Captura (10/05) > Chargeback (20/05) > Liquidação Parcela + Desconto do Chargeback (09/06)`

```xml

<!-- Captura--> 

<FinancialTransactions>
  ...
   <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>1</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <International>True</International>
            <AccountType>2</AccountType>
            <InstallmentType>1</InstallmentType>
            <NumberOfInstallments>1</NumberOfInstallments>
            <AuthorizedAmount>694.000000</AuthorizedAmount>
            <CapturedAmount>694.000000</CapturedAmount>
            <AuthorizationCurrencyCode>986</AuthorizationCurrencyCode>
            <IssuerAuthorizationCode>054973</IssuerAuthorizationCode>
            <BrandId>1</BrandId>
            <CardNumber>411111******1111</CardNumber>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PrevisionPaymentDate>20160609</PrevisionPaymentDate>
                </Installment>
            </Installments>
        </Transaction>
  ...
</FinancialTransactions>
```

```xml

<!-- Chargeback-->

<FinancialTransactions>
  ...
   <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>1</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PrevisionPaymentDate>20160609</PrevisionPaymentDate>
                    <Chargeback>
                        <Id>149222320</Id>
                        <Amount>678.454400</Amount>
                        <Date>20160520</Date>
                        <ChargeDate>20160609</ChargeDate>
                        <ReasonCode>83</ReasonCode>
                    </Chargeback>
                </Installment>
            </Installments>
        </Transaction>
  ...
</FinancialTransactions>
```


```xml

<!-- Liquidação Parcela + Desconto Chargeback--> 

<FinancialTransactionsAccounts>
  ...
    <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>1</Chargebacks>
                <Payments>1</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PaymentDate>20160609</PaymentDate>
                    <Chargeback>
                        <Id>149222320</Id>
                        <Amount>678.454400</Amount>
                        <Date>20160520</Date>
                        <ChargeDate>20160609</ChargeDate>
                        <ReasonCode>83</ReasonCode>
                    </Chargeback>
                    <PaymentId>1234567</PaymentId>
                </Installment>
            </Installments>
       </Transaction>
    ...
<FinancialTransactionsAccounts>
```

<aside class="notice">  <b>Chargeback antes da liquidação da parcela</b>
<ul>

<li>Caso o Chargeback ocorra antes da liquidação da parcela, o desconto virá no dia do pagamento da parcela, como no exemplo ao lado. Como o pagamento é igual ao desconto, os dois se anulam.</li>

</ul>

</aside> 

`Captura (10/05) > Chargeback (20/05) > Liquidação Parcela + Desconto do Chargeback (09/06)`


```xml

<!-- Captura--> 

<FinancialTransactions>
  ...
   <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>1</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <International>True</International>
            <AccountType>2</AccountType>
            <InstallmentType>1</InstallmentType>
            <NumberOfInstallments>3</NumberOfInstallments>
            <AuthorizedAmount>1099.000000</AuthorizedAmount>
            <CapturedAmount>694.000000</CapturedAmount>
            <AuthorizationCurrencyCode>986</AuthorizationCurrencyCode>
            <IssuerAuthorizationCode>054973</IssuerAuthorizationCode>
            <BrandId>1</BrandId>
            <CardNumber>411111******1111</CardNumber>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>366.340000</GrossAmount>
                    <NetAmount>357.657742</NetAmount>
                    <PrevisionPaymentDate>20160609</PrevisionPaymentDate>
                </Installment>
                <Installment>
                    <InstallmentNumber>2</InstallmentNumber>
                    <GrossAmount>366.330000</GrossAmount>
                    <NetAmount>357.647979</NetAmount>
                    <PrevisionPaymentDate>20160709</PrevisionPaymentDate>
                </Installment>
                <Installment>
                    <InstallmentNumber>3</InstallmentNumber>
                    <GrossAmount>366.330000</GrossAmount>
                    <NetAmount>357.647979</NetAmount>
                    <PrevisionPaymentDate>20160809</PrevisionPaymentDate>
                </Installment>
            </Installments>
        </Transaction>
  ...
</FinancialTransactions>
```

```xml

<!-- Chargeback-->

<FinancialTransactions>
  ...
   <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>1</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>366.340000</GrossAmount>
                    <NetAmount>357.657742</NetAmount>
                    <PrevisionPaymentDate>20160609</PrevisionPaymentDate>
                    <Chargeback>
                        <Id>149222320</Id>
                        <Amount>357.657742</Amount>
                        <Date>20160520</Date>
                        <ChargeDate>20160609</ChargeDate>
                        <ReasonCode>83</ReasonCode>
                    </Chargeback>
                </Installment>
                <Installment>
                    <InstallmentNumber>2</InstallmentNumber>
                    <GrossAmount>366.330000</GrossAmount>
                    <NetAmount>357.647979</NetAmount>
                    <SuspendedByChargeback>True</SuspendedByChargeback>
                </Installment>
                <Installment>
                    <InstallmentNumber>3</InstallmentNumber>
                    <GrossAmount>366.330000</GrossAmount>
                    <NetAmount>357.647979</NetAmount>
                    <SuspendedByChargeback>True</SuspendedByChargeback>
                </Installment>
            </Installments>
        </Transaction>
  ...
</FinancialTransactions>
```

```xml

<!-- Liquidação Parcela + Desconto do Chargeback-->


<FinancialTransactionsAccounts>
  ...
    <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>1</Chargebacks>
                <Payments>1</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>366.340000</GrossAmount>
                    <NetAmount>357.657742</NetAmount>
                    <PaymentDate>20160609</PaymentDate>
                    <Chargeback>
                        <Id>149222320</Id>
                        <Amount>357.657742</Amount>
                        <Date>20160520</Date>
                        <ChargeDate>20160609</ChargeDate>
                        <ReasonCode>83</ReasonCode>
                    </Chargeback>
                </Installment>
            </Installments>
       </Transaction>
    ...
<FinancialTransactionsAccounts>
```

<aside class="notice">  <b>Parcelas suspensas por Chargeback</b>

<ul>

<li>Em transações parceladas, caso o chargeback ocorra após o pagamento ou confirmação de uma parcela, as demais serão suspensas e em caso de reapresentação, reagendadas.</li>

</ul>

</aside>


<aside class="success">  <b>ChargebackRefund<b>

<ul>

<li>Se uma parcela é reapresentada após chargeback ela aparecerá em <em>FinancialTransaction</em> no dia em que foi realizado a reapresentação e em <em>FinancialTransactionsAccounts</em> no dia que for pago ao lojista a reapresentação.</li>

</ul>

</aside>

## Exemplos de ciclos de vida do ChargebackRefund:

`Captura (10/05) > Chargeback (20/05) > Liquidação Parcela + Desconto do Chargeback (09/06) > ChargebackRefund (10/06) > Liquidação ChargebackRefund (11/06)`

```xml

<!-- Captura-->

<FinancialTransactions>
  ...
   <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>1</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <International>True</International>
            <AccountType>2</AccountType>
            <InstallmentType>1</InstallmentType>
            <NumberOfInstallments>1</NumberOfInstallments>
            <AuthorizedAmount>694.000000</AuthorizedAmount>
            <CapturedAmount>694.000000</CapturedAmount>
            <AuthorizationCurrencyCode>986</AuthorizationCurrencyCode>
            <IssuerAuthorizationCode>054973</IssuerAuthorizationCode>
            <BrandId>1</BrandId>
            <CardNumber>411111******1111</CardNumber>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PrevisionPaymentDate>20160609</PrevisionPaymentDate>
                </Installment>
            </Installments>
        </Transaction>
  ...
</FinancialTransactions>
```

```xml

<!-- Chargeback-->

<FinancialTransactions>
  ...
   <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>1</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PrevisionPaymentDate>20160609</PrevisionPaymentDate>
                    <Chargeback>
                        <Id>149222320</Id>
                        <Amount>678.454400</Amount>
                        <Date>20160520</Date>
                        <ChargeDate>20160609</ChargeDate>
                        <ReasonCode>83</ReasonCode>
                    </Chargeback>
                </Installment>
            </Installments>
        </Transaction>
  ...
</FinancialTransactions>
```

```xml

<!-- Liquidação Parcela + Desconto Chargeback-->

<FinancialTransactionsAccounts>
  ...
    <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>1</Chargebacks>
                <Payments>1</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PaymentDate>20160609</PaymentDate>
                    <Chargeback>
                        <Id>149222320</Id>
                        <Amount>678.454400</Amount>
                        <Date>20160520</Date>
                        <ChargeDate>20160609</ChargeDate>
                        <ReasonCode>83</ReasonCode>
                    </Chargeback>
                    <PaymentId>1234567</PaymentId>
                </Installment>
            </Installments>
       </Transaction>
    ...
<FinancialTransactionsAccounts>
```

```xml

<!-- ChargebackRefund-->

<FinancialTransactions>
  ...
   <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>1</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PrevisionPaymentDate>20160609</PrevisionPaymentDate>
                    <ChargebackRefund>
                        <Id>149222320</Id>
                        <Amount>678.454400</Amount>
                        <Date>20160610</Date>
                        <PaymentDate>20160611</PaymentDate>
                        <ReasonCode>83</ReasonCode>
                    </ChargebackRefund>
                </Installment>
            </Installments>
        </Transaction>
  ...
</FinancialTransactions>
```

```xml

<!-- Liquidação ChargebackRefund-->

<FinancialTransactionsAccounts>
  ...
   <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>1</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>99960072739732</AcquirerTransactionKey>
            <InitiatorTransactionKey>123456789</InitiatorTransactionKey>
            <AuthorizationDateTime>20160509154748</AuthorizationDateTime>
            <CaptureLocalDateTime>20160510082639</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>694.000000</GrossAmount>
                    <NetAmount>678.454400</NetAmount>
                    <PrevisionPaymentDate>20160609</PrevisionPaymentDate>
                    <ChargebackRefund>
                        <Id>149222320</Id>
                        <Amount>678.454400</Amount>
                        <Date>20160610</Date>
                        <PaymentDate>20160611</PaymentDate>
                        <ReasonCode>83</ReasonCode>
                    </ChargebackRefund>
                </Installment>
            </Installments>
        </Transaction>
  ...
</FinancialTransactionsAccounts>
```

<aside class="warning"> <b>Atenção</b> 

<ul>

<li>Se com uma mesma transação ocorrer mais de um evento no mesmo dia, apenas um nó <em>Transaction</em> é criado para essa transação e as diversas modificações estarão descritas no nó <em>Events</em> (Ex: Uma transação capturada e cancelada no mesmo dia aparecerá com os nós <em>Captures</em> e <em>Cancellations</em> com o valor diferente de zero)</li>

</ul>

</aside>

<aside class="success"> <b>Event</b>

<ul>

<li>Além das transações do cliente a conciliação contempla eventos financeiros, como aluguéis de POS, ajustes financeiros e transferência interna.</li>

</ul>

</aside>

Quando ocorre um lançamento de um evento financeiro para o cliente um nó `Event` é criado em `FinancialEvents`, no dia em que esse evento for pago o mesmo nó aparecerá sob `FinancialEventsAccounts`.

## Exemplos de ciclos de vida do ChargebackRefund:

`Evento (10/05) > Liquidação Evento (20/05)`

```xml

<!-- Event-->

<FinancialEvents>
  ...
  <Event>
        <EventId>53162534</EventId>
        <Description>PosRent</Description>
        <Type>22</Type>
        <PrevisionPaymentDate>20150511</PrevisionPaymentDate>
        <Amount>-99.000000</Amount>
  </Event>
  ...
</FinancialEvents>

```

```xml

<!-- Liquidação Evento--> 

<FinancialEventsAccounts>
  ...
  <Event>
        <EventId>53162534</EventId>
        <Description>PosRent</Description>
        <Type>22</Type>
        <PaymentDate>20150511</PaymentDate>
        <Amount>-99.000000</Amount>
  </Event>
  ...
</FinancialEventsAccounts>
```

## Exemplo de Arquivo Completo 

```xml

<!-- Arquivo Completo-->

<Conciliation>
    <Header>
        <GenerationDateTime>20151013145131</GenerationDateTime>
        <StoneCode>123456789</StoneCode>
        <LayoutVersion>2</LayoutVersion>
        <FileId>020202</FileId>
        <ReferenceDate>20150920</ReferenceDate>
    </Header>
    <FinancialTransactions>
        <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>1</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>12345678912356</AcquirerTransactionKey>
            <InitiatorTransactionKey>1117737</InitiatorTransactionKey>
            <AuthorizationDateTime>20150818155931</AuthorizationDateTime>
            <CaptureLocalDateTime>20150818125935</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Cancellations>
                <Cancellation>
                    <OperationKey>3635000017434024</OperationKey>
                    <CancellationDateTime>20150920034340</CancellationDateTime>
                    <ReturnedAmount>20.000000</ReturnedAmount>
                    <Billing>
                        <ChargedAmount>19.602000</ChargedAmount>
                        <PrevisionChargeDate>20150921</PrevisionChargeDate>
                    </Billing>
                </Cancellation>
            </Cancellations>
        </Transaction>
        <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>1</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>12345678912345</AcquirerTransactionKey>
            <InitiatorTransactionKey>1331632</InitiatorTransactionKey>
            <AuthorizationDateTime>20150920030009</AuthorizationDateTime>
            <CaptureLocalDateTime>20150920000010</CaptureLocalDateTime>
            <AccountType>2</AccountType>
            <InstallmentType>1</InstallmentType>
            <NumberOfInstallments>1</NumberOfInstallments>
            <AuthorizedAmount>50.000000</AuthorizedAmount>
            <CapturedAmount>50.000000</CapturedAmount>
            <AuthorizationCurrencyCode>986</AuthorizationCurrencyCode>
            <IssuerAuthorizationCode>094736</IssuerAuthorizationCode>
            <International>True</International>
            <BrandId>2</BrandId>
            <CardNumber>132456******1122</CardNumber>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>50.000000</GrossAmount>
                    <NetAmount>49.005000</NetAmount>
                    <PrevisionPaymentDate>20151020</PrevisionPaymentDate>
                </Installment>
            </Installments>
        </Transaction>
        <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>1</Cancellations>
                <Captures>1</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>0</Payments>
            </Events>
            <AcquirerTransactionKey>36350017433715</AcquirerTransactionKey>
            <InitiatorTransactionKey>1331697</InitiatorTransactionKey>
            <AuthorizationDateTime>20150920033610</AuthorizationDateTime>
            <CaptureLocalDateTime>20150920003610</CaptureLocalDateTime>
            <AccountType>2</AccountType>
            <InstallmentType>1</InstallmentType>
            <NumberOfInstallments>1</NumberOfInstallments>
            <AuthorizedAmount>125.790000</AuthorizedAmount>
            <CapturedAmount>125.790000</CapturedAmount>
            <CanceledAmount>125.790000</CanceledAmount>
            <AuthorizationCurrencyCode>986</AuthorizationCurrencyCode>
            <IssuerAuthorizationCode>661137</IssuerAuthorizationCode>
            <International>True</International>
            <BrandId>1</BrandId>
            <CardNumber>123456******1122</CardNumber>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Cancellations>
                <Cancellation>
                    <CancellationDateTime>20150920000000</CancellationDateTime>
                    <ReturnedAmount>125.790000</ReturnedAmount>
                </Cancellation>
            </Cancellations>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>125.790000</GrossAmount>
                    <NetAmount />
                </Installment>
            </Installments>
        </Transaction>
    </FinancialTransactions>
    <FinancialEvents>
        <Event>
            <EventId>29869413</EventId>
            <Description>PosRent</Description>
            <Type>-22</Type>
            <PrevisionPaymentDate>20150923</PrevisionPaymentDate>
            <Amount>-590.000000</Amount>
        </Event>
    </FinancialEvents>
    <FinancialTransactionsAccounts>
        <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>1</Payments>
            </Events>
            <AcquirerTransactionKey>31550012403598</AcquirerTransactionKey>
            <InitiatorTransactionKey>ad50f27deee549b2</InitiatorTransactionKey>
            <AuthorizationDateTime>20150803210946</AuthorizationDateTime>
            <CaptureLocalDateTime>20150803182445</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>123.440000</GrossAmount>
                    <NetAmount>120.354375</NetAmount>
                    <PaymentDate>20150920</PaymentDate>
                    <PaymentId>109963</PaymentId>
                </Installment>
            </Installments>
        </Transaction>
        <Transaction>
            <Events>
                <CancellationCharges>0</CancellationCharges>
                <Cancellations>0</Cancellations>
                <Captures>0</Captures>
                <ChargebackRefunds>0</ChargebackRefunds>
                <Chargebacks>0</Chargebacks>
                <Payments>1</Payments>
            </Events>
            <AcquirerTransactionKey>31550012405762</AcquirerTransactionKey>
            <InitiatorTransactionKey>f172e42e9aa7446e</InitiatorTransactionKey>
            <AuthorizationDateTime>20150803212449</AuthorizationDateTime>
            <CaptureLocalDateTime>20150803183941</CaptureLocalDateTime>
            <Poi>
                <PoiType>4</PoiType>
            </Poi>
            <Installments>
                <Installment>
                    <InstallmentNumber>1</InstallmentNumber>
                    <GrossAmount>468.400000</GrossAmount>
                    <NetAmount>457.533120</NetAmount>
                    <PaymentDate>20150920</PaymentDate>
                    <PaymentId>109963</PaymentId>
                </Installment>
            </Installments>
        </Transaction>
    </FinancialTransactionsAccounts>
    <FinancialEventAccounts>
        <Event>
            <EventId>38883564</EventId>
            <PaymentId>109963</PaymentId>
            <Description>FinancialAdjustment</Description>
            <Type>5</Type>
            <PaymentDate>20150920</PaymentDate>
            <Amount>900.890000</Amount>
        </Event>
    </FinancialEventAccounts>
    <Payments>
        <Payment>
            <Id>109963</Id>
            <TotalAmount>1478.77</TotalAmount>
            <TotalFinancialAccountsAmount>1478.77</TotalFinancialAccountsAmount>
            <LastNegativeAmount>0.00</LastNegativeAmount>
            <FavoredBankAccount>
                <BankCode>1</BankCode>
                <BankBranch>24111</BankBranch>
                <BankAccountNumber>0123456</BankAccountNumber>
            </FavoredBankAccount>
        </Payment>
    </Payments>
    <Trailer>
        <CapturedTransactionsQuantity>2</CapturedTransactionsQuantity>
        <CanceledTransactionsQuantity>3</CanceledTransactionsQuantity>
        <PaidInstallmentsQuantity>2</PaidInstallmentsQuantity>
        <ChargedCancellationsQuantity>0</ChargedCancellationsQuantity>
        <ChargebacksQuantity>0</ChargebacksQuantity>
        <ChargebacksRefundQuantity>0</ChargebacksRefundQuantity>
        <ChargedChargebacksQuantity>0</ChargedChargebacksQuantity>
        <PaidChargebacksRefundQuantity>0</PaidChargebacksRefundQuantity>
        <PaidEventsQuantity>1</PaidEventsQuantity>
        <ChargedEventsQuantity>0</ChargedEventsQuantity>
    </Trailer>
</Conciliation>

```
# Apêndice

## AccountType

Retornar à [FinancialTransaction](#FinancialTransaction)

|Valor|Descrição|
|-----|---------|
|1|Debit|
|2|Credit|

## InstallmentType

Retornar à [FinancialTransaction](#FinancialTransaction)

|Valor|Descrição|
|-----|---------|
|1|À vista lojista|
|2|parcelado lojista|
|3|parcelado emissor|

## BrandId

Retornar à [FinancialTransaction](#FinancialTransaction)

|Valor|Descrição|
|-----|---------|
|1|Visa|
|2|MasterCard|

## POIType

Retornar à [FinancialTransaction](#FinancialTransaction)

|Valor|Descrição|
|-----|---------|
|1|POS|
|2|MICRO POS|
|3|TEF|
|4|ECOMMERCE|

## Type

Retornar à [FinancialEvents](#FinancialEvents)

|Valor|Descrição|
|-----|---------|
|2|InternalTransfer (Transferência Interna)|
|5|FinancialAdjustment (Ajuste financeiro)|
|22|PosRent (Aluguel de POS)|


# Dúvidas

Tem dúvidas ou sugestões? Entre em contato conosco: [integracoes@stone.com.br](mailto:integracoes@stone.combr)
