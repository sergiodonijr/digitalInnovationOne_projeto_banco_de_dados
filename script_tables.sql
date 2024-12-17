--criação do banco de dados para o cenário de E-commerce
CREATE DATABASE [ecommerce];
USE ecommerce;

-- criar tabela Clientes
CREATE TABLE Clientes(
	Id int IDENTITY(1,1) PRIMARY KEY,
	PrimeiroNome varchar(10) NOT NULL,
	SobreNome varchar(20) NOT NULL,
	CPF character(11) NOT NULL,
	Endereco varchar(30)
)
GO
ALTER TABLE Clientes ADD CONSTRAINT IDU_CLinetes_PrimeiroNome_SobreNome UNIQUE (PrimeiroNome,SobreNome);
GO
ALTER TABLE Clientes ADD CONSTRAINT IDU_CPF UNIQUE (CPF);
GO

-- criar Categorias
CREATE TABLE Categorias(
	Id int IDENTITY(1,1) PRIMARY KEY,
	Descricao varchar(30) NOT NULL,
	Ativo BIT NOT NULL DEFAULT 1
)
GO
ALTER TABLE Categorias ADD CONSTRAINT IDU_Categorias_Descricao UNIQUE (Descricao);
GO

-- criar tabela Produtos
CREATE TABLE Produtos(
	Id int IDENTITY(1,1) NOT NULL,
	Descricao varchar(30) NOT NULL,
	Classificacao BIT NOT NULL DEFAULT 0,
	CategoriaId int NOT NULL,
	Avaliacao numeric(5,2) NOT NULL DEFAULT 0,
	Tamanho varchar(10)
)
GO
ALTER TABLE Produtos ADD CONSTRAINT PK_Produtos PRIMARY KEY (Id);
GO
ALTER TABLE Produtos ADD CONSTRAINT IDU_Produtos_Descricao UNIQUE (Descricao);
GO
ALTER TABLE Produtos ADD CONSTRAINT FK_Produtos_CategoriaId FOREIGN KEY (CategoriaId) 
            REFERENCES Categorias(Id);
GO

-- criar tabela Pedidos
CREATE TABLE Pedidos(
	Id int IDENTITY(1,1) PRIMARY KEY,
	ClienteId int NOT NULL,
	Status varchar (20) NOT NULL CHECK (Status IN('Cancelado', 'Confirmado','Em processamento')) DEFAULT 'Em processamento',
	Descricao varchar(255) NOT NULL,
	Classificacao BIT NOT NULL DEFAULT 0,
	TipoPagamentoId int NOT NULL,
	Valor numeric(13,2) NOT NULL DEFAULT 10,
	PagamentoEmDinherio BIT NOT NULL DEFAULT 0
)
GO
ALTER TABLE Pedidos ADD CONSTRAINT IDU_Pedidos_Descricao UNIQUE (Descricao);
GO
ALTER TABLE Pedidos ADD CONSTRAINT FK_Pedidos_ClienteId FOREIGN KEY (ClienteId) 
            REFERENCES Clientes(Id);
GO

-- criar tabela Pagamentos
CREATE TABLE Pagamentos(
	ClienteId int NOT NULL,
	PedidoId int NOT NULL,
	TipoPagamento varchar (20) NOT NULL CHECK (TipoPagamento IN('Pix', 'Dinheiro', 'Boleto', 'Cartoes','Multiplos Cartões')),
	LimiteDisponivel numeric(13,2) NOT NULL
)
ALTER TABLE Pagamentos ADD CONSTRAINT PK_Pagamentos PRIMARY KEY (ClienteId, PedidoId);
GO
ALTER TABLE Pagamentos ADD CONSTRAINT FK_Pagamentos_ClienteId FOREIGN KEY (ClienteId) 
            REFERENCES Clientes(Id);
GO
ALTER TABLE Pagamentos ADD CONSTRAINT FK_Pagamentos_PedidoId FOREIGN KEY (PedidoId) 
            REFERENCES Pedidos(Id);
GO

-- criar tabela Estoque
CREATE TABLE Estoque(
	Id int IDENTITY(1,1) PRIMARY KEY,
	Localizacao varchar(255),
	Quantidade int NOT NULL DEFAULT 0
)
GO

-- criar tabela Fornecedores
CREATE TABLE Fornecedores(
	Id int IDENTITY(1,1) PRIMARY KEY,
	RazaoSocial varchar(255) NOT NULL,
	CNPJ character(15) NOT NULL,
	Contato character(11) NOT NULL
)
GO
ALTER TABLE Fornecedores ADD CONSTRAINT IDU_Fornecedores_RazaoSocial UNIQUE (RazaoSocial);
GO
ALTER TABLE Fornecedores ADD CONSTRAINT IDU_Fornecedores_CNPJ UNIQUE (CNPJ);
GO

-- criar tabela Vendedores
CREATE TABLE Vendedores(
	Id int IDENTITY(1,1) PRIMARY KEY,
	RazaoSocial varchar(45) NOT NULL,
	NomeFantasia varchar(45) NOT NULL,
	CNPJ character(15),
	CPF character(11),
	Contato character(11) NOT NULL,
	Localizacao varchar(45)
)
GO
ALTER TABLE Vendedores ADD CONSTRAINT IDU_Vendedores_RazaoSocial UNIQUE (RazaoSocial);
GO
ALTER TABLE Vendedores ADD CONSTRAINT IDU_Vendedores_NomeFantasia UNIQUE (NomeFantasia);
GO
ALTER TABLE Vendedores ADD CONSTRAINT IDU_Vendedores_CNPJ UNIQUE (CNPJ);
GO
ALTER TABLE Vendedores ADD CONSTRAINT IDU_Vendedores_CPF UNIQUE (CPF);
GO

-- criar tabela ProdutosFornecedores
CREATE TABLE ProdutosFornecedores(
	ProdutoId int NOT NULL,
	FornecedorId int NOT NULL
)
GO
ALTER TABLE ProdutosFornecedores ADD CONSTRAINT PK_ProdutosFornecedores PRIMARY KEY (ProdutoId, FornecedorId);
GO
ALTER TABLE ProdutosFornecedores ADD CONSTRAINT FK_ProdutosFornecedores_ProdutoId FOREIGN KEY (ProdutoId) 
            REFERENCES Produtos(Id);
GO
ALTER TABLE ProdutosFornecedores ADD CONSTRAINT FK_ProdutosFornecedores_FornecedorId FOREIGN KEY (FornecedorId) 
            REFERENCES Fornecedores(Id);
GO

-- criar tabela ProdutosVendedores
CREATE TABLE ProdutosVendedores(
	ProdutoId int NOT NULL,
	VendedorId int NOT NULL,
	QuantidadeProduto int NOT NULL DEFAULT 1
)
GO
ALTER TABLE ProdutosVendedores ADD CONSTRAINT PK_ProdutosVendedores PRIMARY KEY (ProdutoId, VendedorId);
GO
ALTER TABLE ProdutosVendedores ADD CONSTRAINT FK_ProdutosVendedores_ProdutoId FOREIGN KEY (ProdutoId) 
            REFERENCES Produtos(Id);
GO
ALTER TABLE ProdutosVendedores ADD CONSTRAINT FK_ProdutosVendedores_VendedorId FOREIGN KEY (VendedorId) 
            REFERENCES Vendedores(Id);
GO

-- criar tabela ProdutosPedidos
CREATE TABLE ProdutosPedidos(
	ProdutoId int NOT NULL,
	PedidoId int NOT NULL,
	QuantidadeProduto int NOT NULL DEFAULT 1,
	Status varchar (20) NOT NULL CHECK (Status IN('Disponível','Sem Estoque')) DEFAULT 'Disponível'
)
GO
ALTER TABLE ProdutosPedidos ADD CONSTRAINT PK_ProdutosPedidos PRIMARY KEY (ProdutoId, PedidoId);
GO
ALTER TABLE ProdutosPedidos ADD CONSTRAINT FK_ProdutosPedidos_ProdutoId FOREIGN KEY (ProdutoId) 
            REFERENCES Produtos(Id);
GO
ALTER TABLE ProdutosPedidos ADD CONSTRAINT FK_ProdutosPedidos_PedidoId FOREIGN KEY (PedidoId) 
            REFERENCES Pedidos(Id);
GO
