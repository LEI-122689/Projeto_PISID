-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 17-Mar-2026 às 13:26
-- Versão do servidor: 10.4.32-MariaDB
-- versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `pisid_maze`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `medicoes_passagens`
--

CREATE TABLE `medicoes_passagens` (
  `IDMedicao` int(11) NOT NULL,
  `IDSimulacao` int(11) DEFAULT NULL,
  `Hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `SalaOrigem` int(11) DEFAULT NULL,
  `SalaDestino` int(11) DEFAULT NULL,
  `Marsami` int(11) DEFAULT NULL,
  `Status` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Acionadores `medicoes_passagens`
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
  `ID` int(11) NOT NULL,
  `Hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `Sala` int(11) DEFAULT NULL,
  `Sensor` varchar(10) DEFAULT NULL,
  `Leitura` decimal(6,2) DEFAULT NULL,
  `TipoAlerta` varchar(50) DEFAULT NULL,
  `Msg` varchar(100) DEFAULT NULL,
  `HoraEscrita` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `ocupacao_labirinto`
--

CREATE TABLE `ocupacao_labirinto` (
  `IDJogo` int(11) NOT NULL,
  `Sala` int(11) NOT NULL,
  `NumeroMarsamisOdd` int(11) DEFAULT 0,
  `NumeroMarsamisEven` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `simulacao`
--

CREATE TABLE `simulacao` (
  `IDSimulacao` int(11) NOT NULL,
  `Descricao` text DEFAULT NULL,
  `Equipa` int(11) DEFAULT NULL,
  `DataHoraInicio` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `som`
--

CREATE TABLE `som` (
  `ID` int(11) NOT NULL,
  `IDSimulacao` int(11) DEFAULT NULL,
  `Hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `Leitura` decimal(6,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `temperatura`
--

CREATE TABLE `temperatura` (
  `ID` int(11) NOT NULL,
  `IDSimulacao` int(11) DEFAULT NULL,
  `Hora` timestamp NOT NULL DEFAULT current_timestamp(),
  `Leitura` decimal(6,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `utilizador`
--

CREATE TABLE `utilizador` (
  `Email` varchar(50) NOT NULL,
  `Nome` varchar(100) DEFAULT NULL,
  `Telemovel` varchar(12) DEFAULT NULL,
  `DataNascimento` date DEFAULT NULL,
  `Equipa` int(11) DEFAULT NULL,
  `Tipo` varchar(3) DEFAULT NULL
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
  MODIFY `IDMedicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `mensagens`
--
ALTER TABLE `mensagens`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `simulacao`
--
ALTER TABLE `simulacao`
  MODIFY `IDSimulacao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `som`
--
ALTER TABLE `som`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `temperatura`
--
ALTER TABLE `temperatura`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

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
