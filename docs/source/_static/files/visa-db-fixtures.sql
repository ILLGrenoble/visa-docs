INSERT INTO role (description, name) VALUES ('Administrator role', 'ADMIN');
INSERT INTO role (description, name) VALUES ('Staff Role', 'STAFF');
INSERT INTO role (description, name) VALUES ('Instrument Control role', 'INSTRUMENT_CONTROL');
INSERT INTO role (description, name) VALUES ('Instrument Scientist role', 'INSTRUMENT_SCIENTIST');
INSERT INTO role (description, name) VALUES ('IT Support role', 'IT_SUPPORT');
INSERT INTO role (description, name) VALUES ('Scientific Computing role', 'SCIENTIFIC_COMPUTING');
INSERT INTO role (description, name) VALUES ('Guest Role', 'GUEST');

INSERT INTO protocol (name, port, optional) VALUES ('RDP', 3389, false);
INSERT INTO protocol (name, port, optional) VALUES ('GUACD', 4822, false);
INSERT INTO protocol (name, port, optional) VALUES ('JUPYTER', 8888, true);
INSERT INTO protocol (name, port, optional) VALUES ('VISA_FS', 8090, true);
INSERT INTO protocol (name, port, optional) VALUES ('VISA_PRINT', 8091, true);
INSERT INTO protocol (name, port, optional) VALUES ('WEBX', 5555, true);
