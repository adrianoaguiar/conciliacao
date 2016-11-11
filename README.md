# ATUALIZANDO A DOCUMENTAÇÃO

## COMO ATUALIZAR A DOCUMENTAÇÃO

Para atualizar a documentação basta navegar até a pasta **source** dentro da pasta **documentacao** e editar o arquivo index.md. Abaixo será ensinado como clonar nosso repositório, atualizar a documentação e postar as mudanças da documentação no repositório novamente.

## VERIFICANDO SEU SISTEMA

Nossa documentação é atualizada com um framework da linguagem Ruby chamado [Slate](https://github.com/lord/slate) e para que ele funcione de forma plena é necessário configurar seu sistema corretamente. Essa configuração pode ser demorada e não trivial porque as versões de várias dependências do framework são atualizadas constantemente e isso pode causar erros inesperados.

Pensando nisso, criamos um ambiente em um container do Docker configurado corretamente. O nome do arquivo de configuração é o Dockefile e, por isso, é altamente recomendável não alterá-lo a menos que tenha domínio suficiente sobre o Docker. 

## CLONANDO O REPOSITÓRIO

Para que a documentação seja atualizada será necessário inicialmente clonar o repositório para sua máquina utilizando o git:

* Instalando o git no Ubuntu/Linux Mint:

```shell

$ sudo apt-get install git 

```

* Clonando o repositório

```shell

$ git clone https://github.com.br/stone-pagamentos/documentação

```

## INSTALANDO O DOCKER

Caso não possua o Docker instalado no sistema Ubuntu/Linux Mint, a instalação é simples:

```shell

$ sudo apt-get install docker

```

## INCIANDO O SISTEMA

Para entrar no ambiente Docker basta rodar o script ``launch`` dentro da pasta documentacao:

* Alterando a pasta atual para a pasta documentação

```shell

$ cd documentacao 

```
* Garantindo permissão de execução para o arquivo 

```shell

$ sudo chmod 755 launch.sh 

```

* Rodando o script 

```shell

$ sudo sh launch.sh

```

Com isso, você estará no ambiente docker e basta rodar o script ``update`` para atualizar a documentação.

* Configurando o git para dar push para o repositório:

```shell

$ git config --global user.email seu_email_aqui

$ git config --global user.name "seu nome aqui"

```


## ATUALIZANDO A DOCUMENTAÇÃO

* Garantindo permissão de execução para o arquivo 

```shell

$ sudo chmod 755 update 

```

* Rodando o script (aperte enter em seguida para retornar ao terminal) 

```shell

$ sh update.sh

```

* Para ver o preview da documentação já atualizada basta acessar o endereço 0.0.0.0:4567 no seu navegador 

```shell

$ sh preview.sh

```

* Copiando o arquivo html gerado para a branch master para finalizar a atualização

```shell

$ git commit -am"Sua mensagem de commit" 

$ git checkout gh-pages

$ sh finish.sh

```

* Push para o repositório:

```shell

$ git commit -am"Sua mensagem de commit" 

$ git push 

```

* Sair do ambiente docker:

```shell

$ exit

```
