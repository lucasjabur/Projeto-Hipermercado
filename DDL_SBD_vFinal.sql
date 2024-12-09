CREATE SCHEMA HIPERMERCADO;
SET SEARCH_PATH TO HIPERMERCADO;
SET datestyle TO DMY;

CREATE TABLE Promocao (
    Codigo_Promocao INT PRIMARY KEY,
    Data_Inicio DATE,
    Data_Fim DATE,
    Nome VARCHAR(100),
    Descricao VARCHAR(250)
);

CREATE TABLE Fornecedor (
    Nro_Fornecedor INT PRIMARY KEY,
    CNPJ VARCHAR(14),
    Nome_Contato VARCHAR(100),
    Denominacao_Social VARCHAR(100),
    Prazo_Entrega INT,
    Endereco VARCHAR(50),
    Condicoes_Pagamento VARCHAR(200),
	Bairro VARCHAR(50),
	Descontos DECIMAL (10,2),
	Cidade VARCHAR(50),
    Valor_Total_Ultimo_Ano DECIMAL(10, 2),
    Estado VARCHAR(2),
    CEP VARCHAR(10),
    Email VARCHAR(100)
);

CREATE TABLE Pedido_Compra(
	Nro_Pedido INT PRIMARY KEY,
	Data_Emissao DATE,
	Previsao_Entrega DATE,
	Condicao_Pagamento VARCHAR(200),
	Devolucao BOOLEAN,
	Valor_Total DECIMAL(10,2),
	Valor_Com_Desconto DECIMAL(10,2),
	Data_Entrega DATE
);

CREATE TABLE Funcionario (
    CPF VARCHAR(11) PRIMARY KEY,
    Nome VARCHAR(100),
    Endereco VARCHAR(200),
    Telefone VARCHAR(15),
    Data_Nascimento DATE,
    Nivel_Escolar VARCHAR(50),
    Estado_Civil VARCHAR(50)
);

CREATE TABLE Solicita (
    Nro_Pedido INT,
    CPF_Funcionario VARCHAR(11),
    PRIMARY KEY (Nro_Pedido, CPF_Funcionario),
    FOREIGN KEY (Nro_Pedido) REFERENCES Pedido_Compra(Nro_Pedido),
    FOREIGN KEY (CPF_Funcionario) REFERENCES Gerente(CPF_Funcionario)
);

CREATE TABLE Funcionario_Mes (
	Ano_Mes VARCHAR(7),
    CPF_Funcionario VARCHAR(11),
    Bonificacao DECIMAL(10, 2),
    Nro_Votos INT,
    PRIMARY KEY (CPF_Funcionario),
    FOREIGN KEY (CPF_Funcionario) REFERENCES Funcionario(CPF)
);

CREATE TABLE Gerente (
    CPF_Funcionario VARCHAR(11),
	Nome_Gerente VARCHAR(100),
    Data_Ingresso DATE,
    Possui_Formacao BOOLEAN,
    PRIMARY KEY (CPF_Funcionario),
    FOREIGN KEY (CPF_Funcionario) REFERENCES Funcionario(CPF)
);

CREATE TABLE Telefone_Fornecedor (
    Telefone VARCHAR(15),
    Nro_Fornecedor INT,
    PRIMARY KEY (Telefone, Nro_Fornecedor),
    FOREIGN KEY (Nro_Fornecedor) REFERENCES Fornecedor(Nro_Fornecedor)
);

CREATE TABLE Categoria (
    Codigo_Categoria INT PRIMARY KEY,
    Descricao VARCHAR(100),
    Codigo_Cat_Pai INT,
    FOREIGN KEY (Codigo_Cat_Pai) REFERENCES Categoria(Codigo_Categoria)
);

CREATE TABLE Sessao (
    Codigo_Sessao INT PRIMARY KEY,
    Nome VARCHAR(100)
);

CREATE TABLE Produto (
    Nro_Produto INT PRIMARY KEY,
    Media_Vendas_Mes DECIMAL(10, 2),
    Sessao_Gondola VARCHAR(100),
    Descricao VARCHAR(250),
    Nome_Fabricante VARCHAR(100),
    Unidade_Venda VARCHAR(50),
    Preco_Venda DECIMAL(10, 2),
    Codigo_Sessao INT,
    Codigo_Categoria INT,
    Quantidade INT,
    FOREIGN KEY (Codigo_Sessao) REFERENCES Sessao(Codigo_Sessao),
    FOREIGN KEY (Codigo_Categoria) REFERENCES Categoria(Codigo_Categoria)
);

CREATE TABLE Participa (
    Nro_Produto INT,
    Codigo_Promocao INT,
    Valor_Desconto DECIMAL(10, 2),
    Valor_Desconto_Prata DECIMAL(10, 2),
    Valor_Desconto_Ouro DECIMAL(10, 2),
    Valor_Desconto_Diamante DECIMAL(10, 2),
    PRIMARY KEY (Nro_Produto, Codigo_Promocao),
    FOREIGN KEY (Nro_Produto) REFERENCES Produto(Nro_Produto),
    FOREIGN KEY (Codigo_Promocao) REFERENCES Promocao(Codigo_Promocao)
);

CREATE TABLE Produto_Fornecido (
    Nro_Produto INT,
    Nro_Fornecedor INT,
    Preco_Compra DECIMAL(10, 2),
    PRIMARY KEY (Nro_Produto, Nro_Fornecedor),
    FOREIGN KEY (Nro_Produto) REFERENCES Produto(Nro_Produto),
    FOREIGN KEY (Nro_Fornecedor) REFERENCES Fornecedor(Nro_Fornecedor)
);

CREATE TABLE Contem(
	Nro_Pedido INT REFERENCES Pedido_Compra(Nro_Pedido),
	Nro_Fornecedor INT,
	Nro_Produto INT,
	Quantidade INT,
	FOREIGN KEY (Nro_Fornecedor, Nro_Produto) REFERENCES Produto_Fornecido(Nro_Fornecedor, Nro_Produto),
	PRIMARY KEY (Nro_Pedido, Nro_Fornecedor, Nro_Produto)
);


CREATE TABLE Atendente_Caixa (
    CPF_Funcionario VARCHAR(11) PRIMARY KEY,
    FOREIGN KEY (CPF_Funcionario) REFERENCES Funcionario(CPF)
);


CREATE TABLE Repositor (
    CPF_Funcionario VARCHAR(11) PRIMARY KEY,
    FOREIGN KEY (CPF_Funcionario) REFERENCES Funcionario(CPF)
);


CREATE TABLE Empacotador (
    CPF_Funcionario VARCHAR(11) PRIMARY KEY,
    FOREIGN KEY (CPF_Funcionario) REFERENCES Funcionario(CPF)
);


CREATE TABLE Faxineiro (
    CPF_Funcionario VARCHAR(11) PRIMARY KEY,
    FOREIGN KEY (CPF_Funcionario) REFERENCES Funcionario(CPF)
);


CREATE TABLE Atendente_Padaria (
    CPF_Funcionario VARCHAR(11) PRIMARY KEY,
    FOREIGN KEY (CPF_Funcionario) REFERENCES Funcionario(CPF)
);

CREATE TABLE Responsavel (
    Codigo_Sessao INT,
    CPF_Repositor VARCHAR(11),
    PRIMARY KEY (Codigo_Sessao, CPF_Repositor),
    FOREIGN KEY (Codigo_Sessao) REFERENCES Sessao(Codigo_Sessao),
    FOREIGN KEY (CPF_Repositor) REFERENCES Repositor(CPF_Funcionario)
);

CREATE TABLE Categoria_Cliente (
    Nome_Categoria VARCHAR(50) PRIMARY KEY,
    Piso_Gasto_Anual DECIMAL(10, 2)
);

CREATE TABLE Cliente (
    CPF VARCHAR(11) PRIMARY KEY,
    Nome_Cliente VARCHAR(100),
    Endereco_Residencial VARCHAR(200),
	Data_Nascimento DATE,
    Profissao VARCHAR(100),
    Valor_Gasto_Anual DECIMAL(10, 2),
    Nome_Categoria VARCHAR(50),
    FOREIGN KEY (Nome_Categoria) REFERENCES Categoria_Cliente(Nome_Categoria)
);

CREATE TABLE Compra (
    Nro_Cupom_Fiscal INT PRIMARY KEY,
    Data DATE,
    Valor_Total DECIMAL(10, 2),
    Valor_Total_Desconto DECIMAL(10, 2),
    Forma_Pagamento VARCHAR(50),
    CPF_Atendente VARCHAR(11),
    CPF_Cliente VARCHAR(11),
    FOREIGN KEY (CPF_Atendente) REFERENCES Atendente_Caixa(CPF_Funcionario),
    FOREIGN KEY (CPF_Cliente) REFERENCES Cliente(CPF)
);

CREATE TABLE Inclui (
    Nro_Produto INT,
    Nro_Cupom_Fiscal INT,
    Quantidade INT,
    Desconto_Aplicado DECIMAL(5, 2),
    PRIMARY KEY (Nro_Produto, Nro_Cupom_Fiscal),
    FOREIGN KEY (Nro_Produto) REFERENCES Produto(Nro_Produto),
    FOREIGN KEY (Nro_Cupom_Fiscal) REFERENCES Compra(Nro_Cupom_Fiscal)
);

CREATE TABLE Telefone_Cliente (
    Telefone VARCHAR(15),
    CPF_Cliente VARCHAR(11),
    PRIMARY KEY (Telefone, CPF_Cliente),
    FOREIGN KEY (CPF_Cliente) REFERENCES Cliente(CPF)
);

CREATE TABLE Endereco_Entrega (
    Endereco VARCHAR(200),
    CPF_Cliente VARCHAR(11),
    PRIMARY KEY (Endereco, CPF_Cliente),
    FOREIGN KEY (CPF_Cliente) REFERENCES Cliente(CPF)
);


CREATE TABLE Avaliacao (
    Data DATE,
    CPF_Cliente VARCHAR(11),
    Nro_Cupom_Fiscal INT,
    Nota_Produtos INT,
    Nota_Atendimento INT,
    Descricao VARCHAR(250),
    PRIMARY KEY (Data, CPF_Cliente, Nro_Cupom_Fiscal),
    FOREIGN KEY (CPF_Cliente) REFERENCES Cliente(CPF),
    FOREIGN KEY (Nro_Cupom_Fiscal) REFERENCES Compra(Nro_Cupom_Fiscal)
);


CREATE TABLE Cupom (
    Codigo_Acionamento INT,
    Nro_Cupom_Fiscal INT,
    Data_Inicio DATE,
    Porcentagem_Desconto DECIMAL(5, 2),
	Data_Validade DATE,
    PRIMARY KEY (Codigo_Acionamento, Nro_Cupom_Fiscal),
    FOREIGN KEY (Nro_Cupom_Fiscal) REFERENCES Compra(Nro_Cupom_Fiscal)
);

ALTER TABLE Funcionario ADD COLUMN
    CPF_Gerente VARCHAR(11);
ALTER TABLE Funcionario ADD CONSTRAINT fk_gerente
    FOREIGN KEY (CPF_Gerente) REFERENCES Gerente(CPF_Funcionario);
