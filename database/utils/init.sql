-- ======================
-- TABLE USERS
-- ======================
CREATE TABLE Users (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    superuser BOOLEAN NOT NULL DEFAULT FALSE
);

-- ======================
-- TABLE GROUPS
-- ======================
CREATE TABLE Groups (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    update_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- ======================
-- TABLE ROLES
-- ======================
CREATE TABLE Roles (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    name VARCHAR(50) NOT NULL UNIQUE
);

-- ======================
-- TABLE GROUPS_USERS
-- ======================
CREATE TABLE Groups_users (
    group_id UUID NOT NULL,
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,

    PRIMARY KEY (group_id, user_id),

    FOREIGN KEY (group_id) REFERENCES Groups(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (user_id) REFERENCES Users(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (role_id) REFERENCES Roles(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ======================
-- TABLE DOCUMENTS
-- ======================
CREATE TABLE Documents (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    name VARCHAR(255) NOT NULL,
    volume BIGINT,
    type VARCHAR(100),
    path VARCHAR(500) NOT NULL,
    update_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- ======================
-- TABLE DOCUMENTS_GROUPS
-- ======================
CREATE TABLE Documents_groups (
    document_id UUID NOT NULL,
    group_id UUID NOT NULL,

    PRIMARY KEY (document_id, group_id),

    FOREIGN KEY (document_id) REFERENCES Documents(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (group_id) REFERENCES Groups(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);