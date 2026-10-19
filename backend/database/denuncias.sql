USE projeto;

CREATE TABLE IF NOT EXISTS denuncias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    veiculo_id INT NULL,
    placa VARCHAR(10) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    descricao TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDENTE',
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_denuncias_placa (placa),
    INDEX idx_denuncias_status (status),

    CONSTRAINT fk_denuncia_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_denuncia_veiculo
        FOREIGN KEY (veiculo_id) REFERENCES veiculos(id)
        ON DELETE SET NULL
);

DROP PROCEDURE IF EXISTS buscar_denuncias;

DELIMITER $$

CREATE PROCEDURE buscar_denuncias(
    IN p_tipo VARCHAR(30),
    IN p_status VARCHAR(20),
    IN p_placa VARCHAR(10),
    IN p_ordem VARCHAR(20)
)
BEGIN
    IF p_ordem = 'data_asc' THEN
        SELECT d.id, d.usuario_id, u.nome AS denunciante, d.veiculo_id,
               d.placa, d.tipo, d.descricao, d.status, d.data_criacao
        FROM denuncias d
        INNER JOIN usuarios u ON u.id = d.usuario_id
        WHERE (p_tipo IS NULL OR d.tipo = p_tipo)
          AND (p_status IS NULL OR d.status = p_status)
          AND (p_placa IS NULL OR d.placa = p_placa)
        ORDER BY d.data_criacao ASC;
    ELSE
        SELECT d.id, d.usuario_id, u.nome AS denunciante, d.veiculo_id,
               d.placa, d.tipo, d.descricao, d.status, d.data_criacao
        FROM denuncias d
        INNER JOIN usuarios u ON u.id = d.usuario_id
        WHERE (p_tipo IS NULL OR d.tipo = p_tipo)
          AND (p_status IS NULL OR d.status = p_status)
          AND (p_placa IS NULL OR d.placa = p_placa)
        ORDER BY d.data_criacao DESC;
    END IF;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS consultar_placa_denuncias;

DELIMITER $$

CREATE PROCEDURE consultar_placa_denuncias(
    IN p_placa VARCHAR(10)
)
BEGIN
    SELECT
        p_placa AS placa,
        COUNT(*) AS total,
        COALESCE(SUM(status = 'PROCEDENTE'), 0) AS confirmadas,
        COALESCE(SUM(status = 'EM_ANALISE'), 0) AS em_analise,
        COALESCE(SUM(status = 'PENDENTE'), 0) AS pendentes,
        MAX(data_criacao) AS ultima_denuncia
    FROM denuncias
    WHERE placa = p_placa
      AND status <> 'IMPROCEDENTE';
END$$

DELIMITER ;
