-- ============================================================
--  BASE DE DATOS: bdappentrenamiento
--  Generado: 2026-05-12
--  Entidades: 11 (Core, Catálogo, Registro, Progreso)
-- ============================================================

CREATE DATABASE IF NOT EXISTS bdappentrenamiento
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE bdappentrenamiento;

-- ------------------------------------------------------------
-- DESACTIVAR FOREIGN KEY CHECKS para creación limpia
-- ------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
--  CORE
-- ============================================================

-- ------------------------------------------------------------
-- Tabla: usuarios
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS usuarios (
    usuario_id          INT             NOT NULL AUTO_INCREMENT,
    nombre              VARCHAR(80)     NOT NULL,
    apellido            VARCHAR(80)     NOT NULL,
    email               VARCHAR(150)    NOT NULL UNIQUE,
    password_hash       VARCHAR(255)    NOT NULL,
    fecha_nacimiento    DATE                NULL,
    genero              ENUM('masculino','femenino','otro','prefiero_no_decir')
                                            NULL,
    peso_kg             DECIMAL(5,2)        NULL,
    altura_cm           DECIMAL(5,2)        NULL,
    nivel_fitness       ENUM('principiante','intermedio','avanzado')
                                            NULL,
    foto_perfil_url     VARCHAR(255)        NULL,
    fecha_registro      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activo              BOOLEAN         NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_usuarios PRIMARY KEY (usuario_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Usuarios registrados en la aplicación';


-- ============================================================
--  CATÁLOGO
-- ============================================================

-- ------------------------------------------------------------
-- Tabla: ejercicios
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ejercicios (
    ejercicio_id        INT             NOT NULL AUTO_INCREMENT,
    nombre              VARCHAR(120)    NOT NULL,
    descripcion         TEXT                NULL,
    grupo_muscular      ENUM('pecho','espalda','hombros','brazos','core',
                             'piernas','gluteos','cardio','cuerpo_completo')
                                            NULL,
    tipo_ejercicio      ENUM('fuerza','cardio','flexibilidad','equilibrio','hiit')
                                            NULL,
    equipo_necesario    ENUM('ninguno','mancuernas','barra','maquina',
                             'banda_elastica','kettlebell','otros')
                                            NULL,
    imagen_url          VARCHAR(255)        NULL,
    video_url           VARCHAR(255)        NULL,
    es_publico          BOOLEAN         NOT NULL DEFAULT TRUE,
    creado_por          INT                 NULL,

    CONSTRAINT pk_ejercicios PRIMARY KEY (ejercicio_id),
    CONSTRAINT fk_ejercicios_usuario
        FOREIGN KEY (creado_por) REFERENCES usuarios (usuario_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Catálogo de ejercicios disponibles';


-- ------------------------------------------------------------
-- Tabla: rutinas
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS rutinas (
    rutina_id               INT             NOT NULL AUTO_INCREMENT,
    usuario_id              INT             NOT NULL,
    nombre                  VARCHAR(120)    NOT NULL,
    descripcion             TEXT                NULL,
    objetivo                ENUM('perdida_peso','ganancia_muscular','resistencia',
                                 'flexibilidad','mantenimiento','rehabilitacion')
                                                NULL,
    dias_por_semana         TINYINT             NULL,
    duracion_estimada_min   SMALLINT            NULL,
    es_publica              BOOLEAN         NOT NULL DEFAULT FALSE,
    fecha_creacion          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_rutinas PRIMARY KEY (rutina_id),
    CONSTRAINT fk_rutinas_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuarios (usuario_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Rutinas de entrenamiento creadas por los usuarios';


-- ------------------------------------------------------------
-- Tabla: rutina_ejercicios  (relación Rutina ↔ Ejercicio)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS rutina_ejercicios (
    rutina_ejercicio_id     INT             NOT NULL AUTO_INCREMENT,
    rutina_id               INT             NOT NULL,
    ejercicio_id            INT             NOT NULL,
    orden                   TINYINT         NOT NULL DEFAULT 1,
    series                  TINYINT             NULL,
    repeticiones            TINYINT             NULL,
    peso_sugerido_kg        DECIMAL(6,2)        NULL,
    descanso_seg            SMALLINT            NULL,
    notas                   TEXT                NULL,

    CONSTRAINT pk_rutina_ejercicios PRIMARY KEY (rutina_ejercicio_id),
    CONSTRAINT fk_re_rutina
        FOREIGN KEY (rutina_id) REFERENCES rutinas (rutina_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_re_ejercicio
        FOREIGN KEY (ejercicio_id) REFERENCES ejercicios (ejercicio_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Ejercicios que componen cada rutina';


-- ============================================================
--  REGISTRO
-- ============================================================

-- ------------------------------------------------------------
-- Tabla: sesiones_entrenamiento
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sesiones_entrenamiento (
    sesion_id               INT             NOT NULL AUTO_INCREMENT,
    usuario_id              INT             NOT NULL,
    rutina_id               INT                 NULL,
    fecha_inicio            DATETIME        NOT NULL,
    fecha_fin               DATETIME            NULL,
    duracion_real_min       SMALLINT            NULL,
    calorias_quemadas       SMALLINT            NULL,
    notas                   TEXT                NULL,
    estado                  ENUM('en_progreso','completada','cancelada')
                                            NOT NULL DEFAULT 'en_progreso',

    CONSTRAINT pk_sesiones PRIMARY KEY (sesion_id),
    CONSTRAINT fk_sesiones_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuarios (usuario_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_sesiones_rutina
        FOREIGN KEY (rutina_id) REFERENCES rutinas (rutina_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Registro de sesiones de entrenamiento realizadas';


-- ------------------------------------------------------------
-- Tabla: sesion_ejercicios  (ejercicios ejecutados en sesión)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sesion_ejercicios (
    sesion_ejercicio_id     INT             NOT NULL AUTO_INCREMENT,
    sesion_id               INT             NOT NULL,
    ejercicio_id            INT             NOT NULL,
    orden                   TINYINT         NOT NULL DEFAULT 1,

    CONSTRAINT pk_sesion_ejercicios PRIMARY KEY (sesion_ejercicio_id),
    CONSTRAINT fk_se_sesion
        FOREIGN KEY (sesion_id) REFERENCES sesiones_entrenamiento (sesion_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_se_ejercicio
        FOREIGN KEY (ejercicio_id) REFERENCES ejercicios (ejercicio_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Ejercicios realizados dentro de cada sesión';


-- ------------------------------------------------------------
-- Tabla: series_registradas
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS series_registradas (
    serie_id                    INT             NOT NULL AUTO_INCREMENT,
    sesion_ejercicio_id         INT             NOT NULL,
    numero_serie                TINYINT         NOT NULL,
    repeticiones_realizadas     TINYINT             NULL,
    peso_kg                     DECIMAL(6,2)        NULL,
    duracion_seg                SMALLINT            NULL,
    distancia_km                DECIMAL(6,3)        NULL,
    completada                  BOOLEAN         NOT NULL DEFAULT FALSE,
    notas                       TEXT                NULL,

    CONSTRAINT pk_series PRIMARY KEY (serie_id),
    CONSTRAINT fk_series_sesion_ejercicio
        FOREIGN KEY (sesion_ejercicio_id) REFERENCES sesion_ejercicios (sesion_ejercicio_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Series ejecutadas por ejercicio dentro de cada sesión';


-- ============================================================
--  PROGRESO
-- ============================================================

-- ------------------------------------------------------------
-- Tabla: medidas_corporales
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS medidas_corporales (
    medida_id           INT             NOT NULL AUTO_INCREMENT,
    usuario_id          INT             NOT NULL,
    fecha               DATE            NOT NULL,
    peso_kg             DECIMAL(5,2)        NULL,
    porcentaje_grasa    DECIMAL(5,2)        NULL,
    masa_muscular_kg    DECIMAL(5,2)        NULL,
    imc                 DECIMAL(4,2)        NULL,
    pecho_cm            DECIMAL(5,2)        NULL,
    cintura_cm          DECIMAL(5,2)        NULL,
    cadera_cm           DECIMAL(5,2)        NULL,
    brazo_cm            DECIMAL(5,2)        NULL,
    pierna_cm           DECIMAL(5,2)        NULL,

    CONSTRAINT pk_medidas PRIMARY KEY (medida_id),
    CONSTRAINT fk_medidas_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuarios (usuario_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Historial de medidas corporales del usuario';


-- ------------------------------------------------------------
-- Tabla: metas
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS metas (
    meta_id             INT             NOT NULL AUTO_INCREMENT,
    usuario_id          INT             NOT NULL,
    tipo                ENUM('peso','repeticiones','distancia','tiempo',
                             'calorias','medida_corporal','otro')
                                            NULL,
    descripcion         TEXT                NULL,
    valor_objetivo      DECIMAL(8,2)        NULL,
    valor_actual        DECIMAL(8,2)        NULL,
    unidad              VARCHAR(20)         NULL,
    fecha_limite        DATE                NULL,
    estado              ENUM('activa','completada','cancelada')
                                        NOT NULL DEFAULT 'activa',

    CONSTRAINT pk_metas PRIMARY KEY (meta_id),
    CONSTRAINT fk_metas_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuarios (usuario_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Metas de fitness establecidas por los usuarios';


-- ------------------------------------------------------------
-- Tabla: logros  (catálogo de insignias/achievements)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS logros (
    logro_id            INT             NOT NULL AUTO_INCREMENT,
    nombre              VARCHAR(120)    NOT NULL,
    descripcion         TEXT                NULL,
    icono_url           VARCHAR(255)        NULL,
    condicion_tipo      ENUM('sesiones_completadas','peso_levantado',
                             'distancia_recorrida','racha_dias',
                             'meta_alcanzada','otro')
                                            NULL,
    condicion_valor     DECIMAL(8,2)        NULL,

    CONSTRAINT pk_logros PRIMARY KEY (logro_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Catálogo de logros/achievements disponibles';


-- ------------------------------------------------------------
-- Tabla: usuario_logros  (relación Usuario ↔ Logro)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS usuario_logros (
    usuario_logro_id    INT             NOT NULL AUTO_INCREMENT,
    usuario_id          INT             NOT NULL,
    logro_id            INT             NOT NULL,
    fecha_obtenido      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_usuario_logros PRIMARY KEY (usuario_logro_id),
    CONSTRAINT uq_usuario_logro  UNIQUE (usuario_id, logro_id),
    CONSTRAINT fk_ul_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuarios (usuario_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ul_logro
        FOREIGN KEY (logro_id) REFERENCES logros (logro_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Logros desbloqueados por cada usuario';


-- ------------------------------------------------------------
-- REACTIVAR FOREIGN KEY CHECKS
-- ------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 1;


-- ============================================================
--  ÍNDICES ADICIONALES (rendimiento en consultas frecuentes)
-- ============================================================

-- Búsqueda de usuarios por email
CREATE INDEX idx_usuarios_email       ON usuarios            (email);

-- Ejercicios por grupo muscular y tipo
CREATE INDEX idx_ejercicios_grupo     ON ejercicios          (grupo_muscular);
CREATE INDEX idx_ejercicios_tipo      ON ejercicios          (tipo_ejercicio);

-- Sesiones por usuario y fecha
CREATE INDEX idx_sesiones_usuario     ON sesiones_entrenamiento (usuario_id, fecha_inicio);

-- Medidas corporales por usuario y fecha
CREATE INDEX idx_medidas_usuario_fecha ON medidas_corporales  (usuario_id, fecha);

-- Metas activas por usuario
CREATE INDEX idx_metas_usuario_estado ON metas               (usuario_id, estado);

-- ============================================================
--  FIN DEL SCRIPT  –  bdappentrenamiento
-- ============================================================
