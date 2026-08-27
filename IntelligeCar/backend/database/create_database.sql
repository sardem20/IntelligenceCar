
CREATE DATABASE IF NOT EXISTS projeto;

USE projeto;



CREATE TABLE IF NOT EXISTS usuarios (

    id INT PRIMARY KEY AUTO_INCREMENT,

    nome VARCHAR(100) NOT NULL,

    email VARCHAR(100) NOT NULL UNIQUE

);



CREATE TABLE IF NOT EXISTS veiculos (

    id INT PRIMARY KEY AUTO_INCREMENT,

    usuario_id INT NOT NULL,

    marca VARCHAR(50) NOT NULL,

    modelo VARCHAR(100) NOT NULL,

    ano INT NOT NULL,

    placa VARCHAR(10) NOT NULL UNIQUE,

    quilometragem INT NOT NULL DEFAULT 0,

    CONSTRAINT fk_veiculo_usuario

        FOREIGN KEY (usuario_id)

        REFERENCES usuarios(id)

        ON DELETE CASCADE

);



CREATE TABLE IF NOT EXISTS manutencoes (

    id INT PRIMARY KEY AUTO_INCREMENT,

    veiculo_id INT NOT NULL,

    tipo VARCHAR(100) NOT NULL,

    descricao TEXT,

    data_manutencao DATE NOT NULL,

    quilometragem INT NOT NULL,

    valor DECIMAL(10,2) DEFAULT 0,

    CONSTRAINT fk_manutencao_veiculo

        FOREIGN KEY (veiculo_id)

        REFERENCES veiculos(id)

        ON DELETE CASCADE

);



CREATE TABLE IF NOT EXISTS documentos (

    id INT PRIMARY KEY AUTO_INCREMENT,

    veiculo_id INT NOT NULL,

    tipo VARCHAR(100) NOT NULL,

    data_emissao DATE,

    data_validade DATE NOT NULL,

    CONSTRAINT fk_documento_veiculo

        FOREIGN KEY (veiculo_id)

        REFERENCES veiculos(id)

        ON DELETE CASCADE

);



DROP PROCEDURE IF EXISTS buscar_veiculos;

DELIMITER $$

CREATE PROCEDURE buscar_veiculos(

    IN p_marca VARCHAR(50),

    IN p_modelo VARCHAR(100),

    IN p_ordem VARCHAR(20)

)

BEGIN

    IF p_ordem = 'ano_asc' THEN

        SELECT

            v.id,

            v.usuario_id,

            u.nome AS proprietario,

            v.marca,

            v.modelo,

            v.ano,

            v.placa,

            v.quilometragem

        FROM veiculos v

        INNER JOIN usuarios u

            ON u.id = v.usuario_id

        WHERE

            (
                p_marca IS NULL

                OR v.marca LIKE CONCAT('%', p_marca, '%')
            )

            AND

            (
                p_modelo IS NULL

                OR v.modelo LIKE CONCAT('%', p_modelo, '%')
            )

        ORDER BY v.ano ASC;


    ELSEIF p_ordem = 'ano_desc' THEN

        SELECT

            v.id,

            v.usuario_id,

            u.nome AS proprietario,

            v.marca,

            v.modelo,

            v.ano,

            v.placa,

            v.quilometragem

        FROM veiculos v

        INNER JOIN usuarios u

            ON u.id = v.usuario_id

        WHERE

            (
                p_marca IS NULL

                OR v.marca LIKE CONCAT('%', p_marca, '%')
            )

            AND

            (
                p_modelo IS NULL

                OR v.modelo LIKE CONCAT('%', p_modelo, '%')
            )

        ORDER BY v.ano DESC;


    ELSE

        SELECT

            v.id,

            v.usuario_id,

            u.nome AS proprietario,

            v.marca,

            v.modelo,

            v.ano,

            v.placa,

            v.quilometragem

        FROM veiculos v

        INNER JOIN usuarios u

            ON u.id = v.usuario_id

        WHERE

            (
                p_marca IS NULL

                OR v.marca LIKE CONCAT('%', p_marca, '%')
            )

            AND

            (
                p_modelo IS NULL

                OR v.modelo LIKE CONCAT('%', p_modelo, '%')
            )

        ORDER BY v.modelo ASC;

    END IF;

END$$

DELIMITER ;



DROP PROCEDURE IF EXISTS historico_manutencoes;

DELIMITER $$

CREATE PROCEDURE historico_manutencoes(

    IN p_veiculo_id INT

)

BEGIN

    SELECT

        m.id,

        m.veiculo_id,

        v.marca,

        v.modelo,

        v.placa,

        m.tipo,

        m.descricao,

        m.data_manutencao,

        m.quilometragem,

        m.valor

    FROM manutencoes m

    INNER JOIN veiculos v

        ON v.id = m.veiculo_id

    WHERE

        m.veiculo_id = p_veiculo_id

    ORDER BY

        m.data_manutencao DESC;

END$$

DELIMITER ;



DROP PROCEDURE IF EXISTS documentos_proximos_vencimento;

DELIMITER $$

CREATE PROCEDURE documentos_proximos_vencimento()

BEGIN

    SELECT

        d.id,

        d.veiculo_id,

        v.marca,

        v.modelo,

        v.placa,

        d.tipo,

        d.data_emissao,

        d.data_validade,

        DATEDIFF(

            d.data_validade,

            CURDATE()

        ) AS dias_para_vencer

    FROM documentos d

    INNER JOIN veiculos v

        ON v.id = d.veiculo_id

    WHERE

        d.data_validade

        BETWEEN CURDATE()

        AND DATE_ADD(
            CURDATE(),
            INTERVAL 30 DAY
        )

    ORDER BY

        d.data_validade ASC;

END$$

DELIMITER ;