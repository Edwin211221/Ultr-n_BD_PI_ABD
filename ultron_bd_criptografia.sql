-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-06-2025 a las 02:58:24
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ultron_bd`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_estado_alerta` (IN `alerta` INT, IN `nuevo_estado` VARCHAR(20))   BEGIN
    UPDATE alertas
    SET estado = nuevo_estado
    WHERE id_alerta = alerta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_monitoreo` (IN `servidor` INT, IN `parametro` INT, IN `valor_param` DECIMAL(6,2))   BEGIN
    INSERT INTO monitoreo (id_servidor, id_parametro, valor, fecha_hora) 
    VALUES (servidor, parametro, valor_param, NOW());
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `promedio_parametro` (`param` INT) RETURNS DECIMAL(6,2)  BEGIN
    DECLARE promedio DECIMAL(6,2);
    SELECT AVG(valor) INTO promedio FROM monitoreo WHERE id_parametro = param;
    RETURN promedio;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alertas`
--

CREATE TABLE `alertas` (
  `id_alerta` int(11) NOT NULL,
  `id_servidor` int(11) DEFAULT NULL,
  `id_parametro` int(11) DEFAULT NULL,
  `tipo` varchar(30) DEFAULT NULL,
  `valor` decimal(6,2) DEFAULT NULL,
  `fecha_hora` datetime DEFAULT NULL,
  `mensaje` varchar(255) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `alertas`
--

INSERT INTO `alertas` (`id_alerta`, `id_servidor`, `id_parametro`, `tipo`, `valor`, `fecha_hora`, `mensaje`, `estado`) VALUES
(1, 1, 1, 'Alto uso de CPU', 95.50, '2025-06-09 09:00:00', 'La CPU superó el 90%', 'pendiente'),
(2, 2, 2, 'Alerta crítica', 93.75, '2025-06-20 19:22:43', 'Valor crítico mayor a 90', 'resuelta');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `monitoreo`
--

CREATE TABLE `monitoreo` (
  `id_monitoreo` int(11) NOT NULL,
  `id_servidor` int(11) DEFAULT NULL,
  `id_parametro` int(11) DEFAULT NULL,
  `valor` decimal(6,2) DEFAULT NULL,
  `fecha_hora` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `monitoreo`
--

INSERT INTO `monitoreo` (`id_monitoreo`, `id_servidor`, `id_parametro`, `valor`, `fecha_hora`) VALUES
(1, 1, 1, 85.25, '2025-06-09 08:10:00'),
(2, 1, 2, 15.70, '2025-06-09 08:10:00'),
(3, 2, 1, 65.80, '2025-06-09 08:10:00'),
(4, 1, 1, 88.50, '2025-06-20 19:22:10'),
(5, 2, 2, 93.75, '2025-06-20 19:22:43');

--
-- Disparadores `monitoreo`
--
DELIMITER $$
CREATE TRIGGER `trigger_alerta_monitoreo` AFTER INSERT ON `monitoreo` FOR EACH ROW BEGIN
    IF NEW.valor > 90 THEN
        INSERT INTO alertas (id_servidor, id_parametro, tipo, valor, fecha_hora, mensaje, estado)
        VALUES (NEW.id_servidor, NEW.id_parametro, 'Alerta crítica', NEW.valor, NOW(), 'Valor crítico mayor a 90', 'pendiente');
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parametros`
--

CREATE TABLE `parametros` (
  `id_parametro` int(11) NOT NULL,
  `nombre_parametro` varchar(30) NOT NULL,
  `unidad` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `parametros`
--

INSERT INTO `parametros` (`id_parametro`, `nombre_parametro`, `unidad`) VALUES
(1, 'CPU', '%'),
(2, 'RAM', 'GB'),
(3, 'Disco', 'GB');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servidores`
--

CREATE TABLE `servidores` (
  `id_servidor` int(11) NOT NULL,
  `nombre_servidor` varchar(50) NOT NULL,
  `ip` blob DEFAULT NULL,
  `ubicacion` varchar(100) DEFAULT NULL,
  `sistema_operativo` varchar(30) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `servidores`
--

INSERT INTO `servidores` (`id_servidor`, `nombre_servidor`, `ip`, `ubicacion`, `sistema_operativo`, `estado`) VALUES
(1, 'Servidor1', 0x3139322e3136382e312e3130, 'Quito', 'Windows Server', 'activo'),
(2, 'Servidor2', 0x3139322e3136382e312e3131, 'Guayaquil', 'Linux', 'mantenimiento'),
(3, 'Servidor Quito', 0x0ad2fa1579fcfd14c1967b8e6248aaa5, 'Quito', 'Linux', 'activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `contrasena` varchar(64) DEFAULT NULL,
  `rol` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre_usuario`, `contrasena`, `rol`) VALUES
(1, 'admin', 'admin123', 'admin'),
(2, 'tecnico1', 'tec123', 'tecnico'),
(3, 'Edwin Barrazueta', '49623ac02240abe0356c8d707b3b9e14b554128eff1f83a1f827e6c09de9c3c7', 'admin'),
(4, 'Renata Salazar', '1d40fee73fa8c241b9f215c3ce559570b29e578090a3ce2c5d6b99ee1067d5db', 'tecnico');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_monitoreo_detalle`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_monitoreo_detalle` (
`id_monitoreo` int(11)
,`nombre_servidor` varchar(50)
,`nombre_parametro` varchar(30)
,`valor` decimal(6,2)
,`fecha_hora` datetime
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_monitoreo_detalle`
--
DROP TABLE IF EXISTS `vista_monitoreo_detalle`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_monitoreo_detalle`  AS SELECT `m`.`id_monitoreo` AS `id_monitoreo`, `s`.`nombre_servidor` AS `nombre_servidor`, `p`.`nombre_parametro` AS `nombre_parametro`, `m`.`valor` AS `valor`, `m`.`fecha_hora` AS `fecha_hora` FROM ((`monitoreo` `m` join `servidores` `s` on(`m`.`id_servidor` = `s`.`id_servidor`)) join `parametros` `p` on(`m`.`id_parametro` = `p`.`id_parametro`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `alertas`
--
ALTER TABLE `alertas`
  ADD PRIMARY KEY (`id_alerta`),
  ADD KEY `id_servidor` (`id_servidor`),
  ADD KEY `id_parametro` (`id_parametro`);

--
-- Indices de la tabla `monitoreo`
--
ALTER TABLE `monitoreo`
  ADD PRIMARY KEY (`id_monitoreo`),
  ADD KEY `id_servidor` (`id_servidor`),
  ADD KEY `id_parametro` (`id_parametro`);

--
-- Indices de la tabla `parametros`
--
ALTER TABLE `parametros`
  ADD PRIMARY KEY (`id_parametro`);

--
-- Indices de la tabla `servidores`
--
ALTER TABLE `servidores`
  ADD PRIMARY KEY (`id_servidor`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `alertas`
--
ALTER TABLE `alertas`
  MODIFY `id_alerta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `monitoreo`
--
ALTER TABLE `monitoreo`
  MODIFY `id_monitoreo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `parametros`
--
ALTER TABLE `parametros`
  MODIFY `id_parametro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `servidores`
--
ALTER TABLE `servidores`
  MODIFY `id_servidor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `alertas`
--
ALTER TABLE `alertas`
  ADD CONSTRAINT `alertas_ibfk_1` FOREIGN KEY (`id_servidor`) REFERENCES `servidores` (`id_servidor`),
  ADD CONSTRAINT `alertas_ibfk_2` FOREIGN KEY (`id_parametro`) REFERENCES `parametros` (`id_parametro`);

--
-- Filtros para la tabla `monitoreo`
--
ALTER TABLE `monitoreo`
  ADD CONSTRAINT `monitoreo_ibfk_1` FOREIGN KEY (`id_servidor`) REFERENCES `servidores` (`id_servidor`),
  ADD CONSTRAINT `monitoreo_ibfk_2` FOREIGN KEY (`id_parametro`) REFERENCES `parametros` (`id_parametro`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
