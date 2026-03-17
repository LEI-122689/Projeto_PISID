-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
<<<<<<<< HEAD:pisid.sql
-- Host: MySQL
-- Tempo de geração: 17-Mar-2026 às 12:48
-- Versão do servidor: 8.0.45
-- versão do PHP: 8.3.30
========
-- Host: 127.0.0.1
-- Tempo de geração: 17-Mar-2026 às 13:26
-- Versão do servidor: 10.4.32-MariaDB
-- versão do PHP: 8.2.12
>>>>>>>> 194cde78acdfe303699b0ab0cda25125a57f1f31:pisid_maze(1).sql

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de dados: `pisid`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`%` PROCEDURE `UpdateUserName` (IN `requester_email` VARCHAR(50), IN `target_email` VARCHAR(50), IN `new_name` VARCHAR(100))   BEGIN
    IF requester_email != target_email THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Acesso negado: O utilizador não tem permissão para alterar este registo.';
    ELSE
        UPDATE utilizador
        SET Nome = new_name
        WHERE Email = target_email;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `medicoes_passagens`
--

CREATE TABLE `medicoes_passagens` (
<<<<<<<< HEAD:pisid.sql
  `IDMedicao` int NOT NULL,
  `Hora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SalaOrigem` int DEFAULT NULL,
  `SalaDestino` int DEFAULT NULL,
  `Marsami` int DEFAULT NULL,
  `Status` int DEFAULT NULL
========
  `IDMedicao` int(11) NOT NULL,
  `IDSimulacao` int(11) DEFAULT NULL,
  `Hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `SalaOrigem` int(11) DEFAULT NULL,
  `SalaDestino` int(11) DEFAULT NULL,
  `Marsami` int(11) DEFAULT NULL,
  `Status` int(11) DEFAULT NULL
>>>>>>>> 194cde78acdfe303699b0ab0cda25125a57f1f31:pisid_maze(1).sql
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `medicoes_passagens`
--
DELIMITER $$
CREATE TRIGGER `Trg_AtualizaOcupacao` AFTER INSERT ON `medicoes_passagens` FOR EACH ROW BEGIN
    -- Tratar a saída da sala de origem (se não for o início da simulação)
    IF NEW.SalaOrigem IS NOT NULL AND NEW.SalaOrigem > 0 THEN
        IF (NEW.Marsami % 2 = 0) THEN
            UPDATE ocupacao_labirinto 
            SET NumeroMarsamisEven = NumeroMarsamisEven - 1 
            WHERE Sala = NEW.SalaOrigem;
        ELSE
            UPDATE ocupacao_labirinto 
            SET NumeroMarsamisOdd = NumeroMarsamisOdd - 1 
            WHERE Sala = NEW.SalaOrigem;
        END IF;
    END IF;

    -- Tratar a entrada na sala de destino
    -- Primeiro, verifica se a sala já existe na tabela de ocupação
    IF NOT EXISTS (SELECT 1 FROM ocupacao_labirinto WHERE Sala = NEW.SalaDestino) THEN
        INSERT INTO ocupacao_labirinto (IDJogo, Sala, NumeroMarsamisOdd, NumeroMarsamisEven)
        VALUES (1, NEW.SalaDestino, 0, 0);
    END IF;

    -- Atualiza o contador na sala de destino
    IF (NEW.Marsami % 2 = 0) THEN
        UPDATE ocupacao_labirinto 
        SET NumeroMarsamisEven = NumeroMarsamisEven + 1 
        WHERE Sala = NEW.SalaDestino;
    ELSE
        UPDATE ocupacao_labirinto 
        SET NumeroMarsamisOdd = NumeroMarsamisOdd + 1 
        WHERE Sala = NEW.SalaDestino;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `mensagens`
--

CREATE TABLE `mensagens` (
  `ID` int NOT NULL,
  `Hora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Sala` int DEFAULT NULL,
  `Sensor` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Leitura` decimal(6,2) DEFAULT NULL,
  `TipoAlerta` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Msg` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `HoraEscrita` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `ocupacao_labirinto`
--

CREATE TABLE `ocupacao_labirinto` (
  `IDJogo` int NOT NULL,
  `Sala` int NOT NULL,
  `NumeroMarsamisOdd` int DEFAULT '0',
  `NumeroMarsamisEven` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `setup_maze`
--

CREATE TABLE `setup_maze` (
  `IDSetup` int NOT NULL,
  `NumberRooms` int DEFAULT NULL,
  `NumberMarsamis` int DEFAULT NULL,
  `NormalTemperature` decimal(5,2) DEFAULT NULL,
  `LimitTemperature` decimal(5,2) DEFAULT NULL,
  `DataConfiguracao` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Extraindo dados da tabela `setup_maze`
--

INSERT INTO `setup_maze` (`IDSetup`, `NumberRooms`, `NumberMarsamis`, `NormalTemperature`, `LimitTemperature`, `DataConfiguracao`) VALUES
(1, 10, 30, 20.00, 35.00, '2026-03-12 18:12:51');

-- --------------------------------------------------------

--
-- Estrutura da tabela `simulacao`
--

CREATE TABLE `simulacao` (
  `IDSimulacao` int NOT NULL,
  `Descricao` text COLLATE utf8mb4_general_ci,
  `Equipa` int DEFAULT NULL,
  `DataHoraInicio` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `som`
--

CREATE TABLE `som` (
<<<<<<<< HEAD:pisid.sql
  `ID` int NOT NULL,
  `Hora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
========
  `ID` int(11) NOT NULL,
  `IDSimulacao` int(11) DEFAULT NULL,
  `Hora` timestamp NOT NULL DEFAULT current_timestamp(),
>>>>>>>> 194cde78acdfe303699b0ab0cda25125a57f1f31:pisid_maze(1).sql
  `Leitura` decimal(6,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `temperatura`
--

CREATE TABLE `temperatura` (
<<<<<<<< HEAD:pisid.sql
  `ID` int NOT NULL,
  `Hora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
========
  `ID` int(11) NOT NULL,
  `IDSimulacao` int(11) DEFAULT NULL,
  `Hora` timestamp NOT NULL DEFAULT current_timestamp(),
>>>>>>>> 194cde78acdfe303699b0ab0cda25125a57f1f31:pisid_maze(1).sql
  `Leitura` decimal(6,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `utilizador`
--

CREATE TABLE `utilizador` (
  `Email` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `Nome` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Telemovel` varchar(12) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DataNascimento` date DEFAULT NULL,
  `Equipa` int DEFAULT NULL,
  `Tipo` varchar(3) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `medicoes_passagens`
--
ALTER TABLE `medicoes_passagens`
  ADD PRIMARY KEY (`IDMedicao`),
  ADD KEY `fk_medicoes_simulacao` (`IDSimulacao`);

--
-- Índices para tabela `mensagens`
--
ALTER TABLE `mensagens`
  ADD PRIMARY KEY (`ID`);

--
-- Índices para tabela `ocupacao_labirinto`
--
ALTER TABLE `ocupacao_labirinto`
  ADD PRIMARY KEY (`IDJogo`,`Sala`);

--
-- Índices para tabela `setup_maze`
--
ALTER TABLE `setup_maze`
  ADD PRIMARY KEY (`IDSetup`);

--
-- Índices para tabela `simulacao`
--
ALTER TABLE `simulacao`
  ADD PRIMARY KEY (`IDSimulacao`),
  ADD KEY `fk_equipa_utilizador` (`Equipa`);

--
-- Índices para tabela `som`
--
ALTER TABLE `som`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `fk_som_simulacao` (`IDSimulacao`);

--
-- Índices para tabela `temperatura`
--
ALTER TABLE `temperatura`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `fk_temperatura_simulacao` (`IDSimulacao`);

--
-- Índices para tabela `utilizador`
--
ALTER TABLE `utilizador`
  ADD PRIMARY KEY (`Email`),
  ADD KEY `Equipa` (`Equipa`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `medicoes_passagens`
--
ALTER TABLE `medicoes_passagens`
  MODIFY `IDMedicao` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `mensagens`
--
ALTER TABLE `mensagens`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `setup_maze`
--
ALTER TABLE `setup_maze`
  MODIFY `IDSetup` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `simulacao`
--
ALTER TABLE `simulacao`
  MODIFY `IDSimulacao` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `som`
--
ALTER TABLE `som`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `temperatura`
--
ALTER TABLE `temperatura`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `medicoes_passagens`
--
ALTER TABLE `medicoes_passagens`
  ADD CONSTRAINT `fk_medicoes_simulacao` FOREIGN KEY (`IDSimulacao`) REFERENCES `simulacao` (`IDSimulacao`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `simulacao`
--
ALTER TABLE `simulacao`
  ADD CONSTRAINT `fk_equipa_utilizador` FOREIGN KEY (`Equipa`) REFERENCES `utilizador` (`Equipa`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `som`
--
ALTER TABLE `som`
  ADD CONSTRAINT `fk_som_simulacao` FOREIGN KEY (`IDSimulacao`) REFERENCES `simulacao` (`IDSimulacao`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `temperatura`
--
ALTER TABLE `temperatura`
  ADD CONSTRAINT `fk_temperatura_simulacao` FOREIGN KEY (`IDSimulacao`) REFERENCES `simulacao` (`IDSimulacao`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
