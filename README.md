# Projeto Consulta de CEP

## Como baixar e compilar o projeto
### Video demostrativo: https://share.vidyard.com/watch/vp9VXZypwKWHAQ5dVDdxzs?
- Clone o repositório : git clone https://github.com/gittiagohub/softplan.git
- Baixe e instale o gerenciador de denpendêcias boss: https://github.com/hashload/boss/releases
- Abra o terminal na pasta ".\softplan" e execute "boss i" para instalar a dependências restRequest4delphi que uso para fazer as requisições.
- Abra o Delphi, e abra o projeto do componente que esta em "softplan\Component" com o nome PckCep.dproj. Compile e instale o mesmo.
- Crie um banco de dados no mysql.
  - Não precisa criar a tabela.
- Para configurar o banco de dados mysql, Na pasta "softplan\Win32\Debug" abra o arquivo Config.ini e preencha as propriedades para o banco. 

  - port= Porta que esta executando o banco de dados
  - Database= Nome do banco de dados
  - username= Usuário do banco de dados
  - password= Senha do banco de dados
  - host= Local onde esta rodando o banco de dados
  - DLL= O nome da DLL que já se encontra na mesma pasta
    
- Abra o projeto que esta em "softplan" com o nome ConsultaCEP.dproj. Compile e execute.

 
  ## Respondendo perguntas.
- Qual arquiterura utilizada ?
  - Arquitetura em camadas, onde cada camada é responsável por um conjunto de funcionalidades.
- Qual pattern foi utilizado ?
  - Factory, Facilita a usabilidade isolada de uma classe, que faciita fazer testes unitários.
  ## Falando um pouco sobre o projeto.
  https://share.vidyard.com/watch/QHAHNnvmpJw96KWECzYdN7?



  


