
CREATE TABLE IF NOT EXISTS households(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    household VARCHAR(128) NOT NULL,
    UNIQUE(household)
);

CREATE TABLE IF NOT EXISTS participants(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(128) NOT NULL,
    household INT NOT NULL,
    email VARCHAR(320) NOT NULL,
    FOREIGN KEY(household) REFERENCES households(id)
);

CREATE TABLE IF NOT EXISTS participant_households(
    participant INTEGER NOT NULL,
    household INTEGER NOT NULL,
    FOREIGN KEY(participant) REFERENCES participants(id),
    FOREIGN KEY(household) REFERENCES households(id),
    PRIMARY KEY (participant, household)
);

CREATE TABLE IF NOT EXISTS giftee_history(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    participant INTEGER NOT NULL,
    giftee INTEGER NOT NULL,
    date_selected TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY(participant) REFERENCES participants(id),
    FOREIGN KEY(giftee) REFERENCES participants(id)
);

-- insert statement for participant


-- participant view and rules
CREATE VIEW vw_participants AS SELECT P.id, P.name, H.household, P.email FROM participants AS P,households AS H WHERE H.id = P.household;

CREATE TRIGGER insert_into_vw_participants 
    INSTEAD OF INSERT ON vw_participants 
    BEGIN 
        INSERT INTO participants(name, household, email) 
        VALUES (NEW.name, (SELECT id FROM households WHERE household = NEW.household), NEW.email);
    END;

CREATE TRIGGER update_vw_participants
    INSTEAD OF UPDATE OF name, household, email ON vw_participants 
    BEGIN
        UPDATE participants SET name = NEW.name, household = (SELECT id FROM households WHERE household = NEW.household),
        email = NEW.email WHERE id = OLD.id;
    END; 

CREATE TRIGGER delete_vw_participants
    INSTEAD OF DELETE ON vw_participants
    BEGIN
        DELETE FROM participants WHERE id = OLD.id;
    END;


-- Retrives the most recent pair of participants and their giftee's
-- used to make sure no one gets the same person from the previous year
CREATE VIEW vw_recent_giftee_history AS
SELECT participant, giftee FROM giftee_history WHERE date_selected = (SELECT max(date_selected) FROM giftee_history);

-- List all possible giftee's 
-- Can't be in the same household, can't be the same person, can't have someone from the previous
-- run
SELECT P.id AS id, COUNT(G.id) AS num_possible_giftees, group_concat(G.id) AS possible_giftees FROM participants AS P, participants AS G WHERE P.id != G.id AND P.household != G.household AND ( (P.id, G.id) NOT IN (SELECT * FROM vw_recent_giftee_history)) GROUP BY P.id ORDER BY num_possible_giftees ASC;


