-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
-----------------------  VERSION 0 ------------------------
-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------


-------------------------------
------ CREATION DES TABLES ----
-------------------------------

SET echo ON;

DROP TABLE Operation;
DROP TABLE TypeOperation;
DROP TABLE CompteCourant;
DROP TABLE Client;
ALTER TABLE AgenceBancaire DROP CONSTRAINT fk_AgenceBancaire_Emp_ChefAg;
DROP TABLE Employe;
DROP TABLE AgenceBancaire;

CREATE TABLE AgenceBancaire(
	idAg NUMBER(3),
	nomAg VARCHAR(30),
	adressePostaleAg VARCHAR(50),
	idEmployeChefAg NUMBER(3),
	CONSTRAINT pk_AgenceBancaire PRIMARY KEY (idAg)	
);

CREATE TABLE Employe(
	idEmploye NUMBER(3),
	nom VARCHAR(25),
	prenom VARCHAR(15),
	droitsAccess VARCHAR(50),
	login VARCHAR(8),
	motPasse VARCHAR(15),
	idAg NUMBER(3),
	CONSTRAINT pk_Employe PRIMARY KEY (idEmploye),
	CONSTRAINT fk_Employe_AgenceBancaire
		FOREIGN KEY (idAg) REFERENCES AgenceBancaire(idAg),
	CONSTRAINT nn_Employe_idAg CHECK (idAG IS NOT NULL)	
);

/*
on doit ajouter cette contrainte après création de la table Employe 
car il y a 2 dépendances cycliques entre agence et employe...
*/
ALTER TABLE AgenceBancaire
ADD CONSTRAINT fk_AgenceBancaire_Emp_ChefAg 
		FOREIGN KEY (idEmployeChefAg) REFERENCES Employe(idEmploye);
		
CREATE TABLE Client(
	idNumCli NUMBER(5),
	nom VARCHAR(25),
	prenom VARCHAR(15),
	adressePostale VARCHAR(50),
	email VARCHAR(20),
	telephone CHAR(10),
	estInactif CHAR(1),
	idAg NUMBER(3),
	CONSTRAINT pk_Client PRIMARY KEY (idNumCli),
	CONSTRAINT fk_Client_AgenceBancaire
		FOREIGN KEY (idAg) REFERENCES AgenceBancaire(idAg),
	CONSTRAINT ck_Client_estInactif CHECK (estInactif IN ('O', 'N')),
	CONSTRAINT nn_Client_idAg CHECK (idAG IS NOT NULL)	
);

CREATE TABLE CompteCourant(
	idNumCompte NUMBER(5), 
	debitAutorise NUMBER(4),
	solde DECIMAL(10,2),
	idNumCli NUMBER(5), 
	CONSTRAINT pk_CompteCourant PRIMARY KEY (idNumCompte),
	CONSTRAINT fk_CpteCourant_Client
		FOREIGN KEY (idNumCli) REFERENCES Client(idNumCli),
	CONSTRAINT nn_CpteCourant_idNumCli CHECK (idNumCli IS NOT NULL)
);

CREATE TABLE TypeOperation(
	idTypeOp	VARCHAR(25),
	CONSTRAINT pk_TypeOperation PRIMARY KEY (idTypeOp)
);

CREATE TABLE Operation(
	idOperation NUMBER(12), 
	montant DECIMAL(8,2),
	dateOp	DATE DEFAULT sysdate,
	dateValeur DATE,
	idNumCompte NUMBER(5), 
	idTypeOp VARCHAR(25),
	CONSTRAINT pk_Operation PRIMARY KEY (idOperation),
	CONSTRAINT fk_Operation_CompteCourant
		FOREIGN KEY (idNumCompte) REFERENCES CompteCourant(idNumCompte),
	CONSTRAINT fk_Operation_TypeOperation
		FOREIGN KEY (idTypeOp) REFERENCES TypeOperation(idTypeOp),
	CONSTRAINT nn_Operation_CpteCourant CHECK (idNumCompte IS NOT NULL),
	CONSTRAINT nn_Operation_TypeOp CHECK (idTypeOp IS NOT NULL)
);
COMMIT;

-----------------------------------
------ REMPLISSAGE DES TABLES -----
-----------------------------------
DELETE FROM Operation;
DELETE FROM TypeOperation;
DELETE FROM CompteCourant;
DELETE FROM Client;
ALTER TABLE AgenceBancaire DISABLE CONSTRAINT fk_AgenceBancaire_Emp_ChefAg;
DELETE FROM Employe;
DELETE FROM AgenceBancaire;
ALTER TABLE AgenceBancaire ENABLE CONSTRAINT fk_AgenceBancaire_Emp_ChefAg;

-- On insère les 3 agences bancaires
INSERT INTO AgenceBancaire (idAg, nomAg, adressePostaleAg) VALUES (1, 'Agence Blagnac Centre', '2 rue Pasteur 31700 Blagnac');
INSERT INTO AgenceBancaire (idAg, nomAg, adressePostaleAg) VALUES (2, 'Agence Vieux Beauzelle', '14 rue de la république, 31700 Beauzelle');
INSERT INTO AgenceBancaire (idAg, nomAg, adressePostaleAg) VALUES (3, 'Agence Blagnac Ouest', '4 place brassens, 31700 Blagnac');

-- On crée une séquence afin de générer la clé primaire des employés
DROP SEQUENCE seq_id_employe;
CREATE SEQUENCE seq_id_employe
  MINVALUE 1  MAXVALUE 999999999999  
  START WITH 1 INCREMENT BY 1;
  
-- On insère les 3 chefs d'agence précédentes
INSERT INTO Employe VALUES (seq_id_employe.NEXTVAL,'Tuffery','Michel','chefAgence','Tuff','Lejeune', 1);
INSERT INTO Employe VALUES (seq_id_employe.NEXTVAL,'Crampes','Jean-Bernard','chefAgence','JBC','Basse', 2);
INSERT INTO Employe VALUES (seq_id_employe.NEXTVAL,'Inglebert','Jean-Michel','chefAgence','JMI','Belote', 3);

-- on met à jour la clé étrangère, dans AgenceBancaire, qui pointe vers l'employé Chef d'agence
UPDATE AgenceBancaire
	SET idEmployeChefAg = 1 
	WHERE idAg = 1;
UPDATE AgenceBancaire
	SET idEmployeChefAg = 2
	WHERE idAg = 2;
UPDATE AgenceBancaire
	SET idEmployeChefAg = 3
	WHERE idAg = 3;

-- on insere qq guichetiers 
INSERT INTO Employe VALUES (seq_id_employe.NEXTVAL,'Nonne','Laurent','guichetier','LN','Levieux',1); -- ag1
INSERT INTO Employe VALUES (seq_id_employe.NEXTVAL,'Teste','Olivier','guichetier','OT','Lemoyen',1); -- ag1
INSERT INTO Employe VALUES (seq_id_employe.NEXTVAL,'Peninou','André','guichetier','AP','TheVoice',2); -- ag2
INSERT INTO Employe VALUES (seq_id_employe.NEXTVAL,'Pelleau','Fabrice','guichetier','FP','TheEnterprise',2); -- ag2
INSERT INTO Employe VALUES (seq_id_employe.NEXTVAL,'Demichiel','Marianne','guichetier','MDM','TheGiant',3); -- ag3
INSERT INTO Employe VALUES (seq_id_employe.NEXTVAL,'Redon','Laurence','guichetier','LR','MissCobol',3); -- ag3
INSERT INTO Employe VALUES (seq_id_employe.NEXTVAL,'Pendaries','Esther','guichetier','EP','Paganini',3); -- ag3

-- On crée une séquence afin de générer la clé primaire des clients
DROP SEQUENCE seq_id_client;
CREATE SEQUENCE seq_id_client
  MINVALUE 1  MAXVALUE 999999999999  
  START WITH 1 INCREMENT BY 1;
  
-- on insere qq clients de l'agence 1
INSERT INTO Client VALUES (seq_id_client.NEXTVAL,'Gabin','Jean','3 rue t''as de beaux yeux tu sais, 31700 Blagnac','gabin@free.fr','0512345678','N',1);
INSERT INTO Client VALUES (seq_id_client.NEXTVAL,'Belmondo','Jean-Paul','4 rue des cascades, 31700 Blagnac','belmondo@gmail.com','0598765432','N',1);
INSERT INTO Client VALUES (seq_id_client.NEXTVAL,'Delon','Alain','34 rue du beau gosse, 31700 Blagnac','delon@gmail.com','0512457896','N',1);

-- on insere qq clients de l'agence 2, attention le client Lino Ventura est inactif...
INSERT INTO Client VALUES (seq_id_client.NEXTVAL,'Ventura','Lino','3 rue des baffes, 31000 Toulouse','ventura@free.fr','0635785215','O',2);
INSERT INTO Client VALUES (seq_id_client.NEXTVAL,'Montand','Yves','7 avenue de la fille du facteur, 31000 Toulouse','montand@free.fr','0612395415','N',2);
INSERT INTO Client VALUES (seq_id_client.NEXTVAL,'De Funes','Louis','3 avenue de ma biche, 31700 Beauzelle','funes@free.fr','0648565415','N',2);

-- on insere qq clients de l'agence 3
INSERT INTO Client VALUES (seq_id_client.NEXTVAL,'Bourvil','','4 impasse de la cuisine au beurre, 31700 Blagnac','bourvil@free.fr','0914265415','N',3);
INSERT INTO Client VALUES (seq_id_client.NEXTVAL,'Blier','Bernard','134 rue de la ventilation, 31700 Blagnac','blier@free.fr','0514265415','N',3);
INSERT INTO Client VALUES (seq_id_client.NEXTVAL,'Dépardieu','Gérard','134 rue des valseuses, 102151 Moscou','depardieu@kremlin.fr','0914265415','N',3);
INSERT INTO Client VALUES (seq_id_client.NEXTVAL,'Réno','Jean','13 rue des nettoyeurs, 31700 Beauzelle','reno@yahoo.fr','0814765415','N',3);

-- on insére les type operations

INSERT INTO TypeOperation VALUES ('Dépôt Espèces'); -- crédit : accessible guichet
INSERT INTO TypeOperation VALUES ('Retrait Espèces'); -- débit : accessible guichet
INSERT INTO TypeOperation VALUES ('Dépôt Chèque'); -- crédit : accessible guichet
INSERT INTO TypeOperation VALUES ('Paiement Chèque'); -- débit 
INSERT INTO TypeOperation VALUES ('Retrait Carte Bleue'); -- débit 
INSERT INTO TypeOperation VALUES ('Paiement Carte Bleue'); -- débit 
INSERT INTO TypeOperation VALUES ('Virement Compte à Compte'); -- débit ou crédit : accessible guichet
INSERT INTO TypeOperation VALUES ('Prélèvement automatique'); -- débit
INSERT INTO TypeOperation VALUES ('Prélèvement agios');  -- débit

-- On crée une séquence afin de générer la clé primaire des opérations
DROP SEQUENCE seq_id_operation;
CREATE SEQUENCE seq_id_operation
  MINVALUE 1  MAXVALUE 999999999999  
  START WITH 1 INCREMENT BY 1;
  
-- on insere 1 ou 2 comptes par client
-- on considère que le client doit, à la création du compte, déposer 200€ sur le compte
-- on a donc un solde initial de 200€ sur chaque compte (on crée donc une opération de crédit de 200€ pour compte créé)

DROP SEQUENCE seq_id_compte;
CREATE SEQUENCE seq_id_compte
  MINVALUE 1  MAXVALUE 999999999999  
  START WITH 1 INCREMENT BY 1;
  
INSERT INTO CompteCourant VALUES (seq_id_compte.NEXTVAL, -200, 200, 1);  -- cli 1, gabin
INSERT INTO Operation (idOperation, montant, dateValeur, idNumCompte, idTypeOp)
	VALUES (seq_id_operation.NEXTVAL, 200, sysdate +2, seq_id_compte.CURRVAL, 'Dépôt Espèces');
	
INSERT INTO CompteCourant VALUES (seq_id_compte.NEXTVAL, 0,    200, 1);  -- cli 1, gabin
INSERT INTO Operation (idOperation, montant, dateValeur, idNumCompte, idTypeOp)
	VALUES (seq_id_operation.NEXTVAL, 200, sysdate +2, seq_id_compte.CURRVAL, 'Dépôt Espèces');

INSERT INTO CompteCourant VALUES (seq_id_compte.NEXTVAL, -200,  100, 2); -- cli 2, belmondo
INSERT INTO Operation (idOperation, montant, dateValeur, idNumCompte, idTypeOp)
	VALUES (seq_id_operation.NEXTVAL, 100, sysdate +2, seq_id_compte.CURRVAL, 'Dépôt Espèces');
	
INSERT INTO CompteCourant VALUES (seq_id_compte.NEXTVAL, -3000, 300, 3); -- cli 3, delon
INSERT INTO Operation (idOperation, montant, dateValeur, idNumCompte, idTypeOp)
	VALUES (seq_id_operation.NEXTVAL, 300, sysdate +2, seq_id_compte.CURRVAL, 'Dépôt Espèces');

INSERT INTO CompteCourant VALUES (seq_id_compte.NEXTVAL, -150,  200, 4); -- cli 4, ventura
INSERT INTO Operation (idOperation, montant, dateValeur, idNumCompte, idTypeOp)
	VALUES (seq_id_operation.NEXTVAL, 200, sysdate +2, seq_id_compte.CURRVAL, 'Dépôt Espèces');
	
INSERT INTO CompteCourant VALUES (seq_id_compte.NEXTVAL, -800,  50, 5); -- cli 5, montand
INSERT INTO Operation (idOperation, montant, dateValeur, idNumCompte, idTypeOp)
	VALUES (seq_id_operation.NEXTVAL, 50, sysdate +2, seq_id_compte.CURRVAL, 'Dépôt Espèces');
	
INSERT INTO CompteCourant VALUES (seq_id_compte.NEXTVAL, -50,   50, 6); -- cli 6, de funes
INSERT INTO Operation (idOperation, montant, dateValeur, idNumCompte, idTypeOp)
	VALUES (seq_id_operation.NEXTVAL, 50, sysdate +2, seq_id_compte.CURRVAL, 'Dépôt Espèces');

INSERT INTO CompteCourant VALUES (seq_id_compte.NEXTVAL, -850,  250, 7); -- cli 7, bourvil
INSERT INTO Operation (idOperation, montant, dateValeur, idNumCompte, idTypeOp)
	VALUES (seq_id_operation.NEXTVAL, 250, sysdate +2, seq_id_compte.CURRVAL, 'Dépôt Espèces');
	
INSERT INTO CompteCourant VALUES (seq_id_compte.NEXTVAL, -100,  300, 8); -- cli 8, blier
INSERT INTO Operation (idOperation, montant, dateValeur, idNumCompte, idTypeOp)
	VALUES (seq_id_operation.NEXTVAL, 300, sysdate +2, seq_id_compte.CURRVAL, 'Dépôt Espèces');
	
INSERT INTO CompteCourant VALUES (seq_id_compte.NEXTVAL, 0,     800, 9); -- cli 9, depardieu
INSERT INTO Operation (idOperation, montant, dateValeur, idNumCompte, idTypeOp)
	VALUES (seq_id_operation.NEXTVAL, 800, sysdate +2, seq_id_compte.CURRVAL, 'Dépôt Espèces');
	
INSERT INTO CompteCourant VALUES (seq_id_compte.NEXTVAL, 0,     1200, 10); -- cli 10, reno     
INSERT INTO Operation (idOperation, montant, dateValeur, idNumCompte, idTypeOp)
	VALUES (seq_id_operation.NEXTVAL, 1200, sysdate +2, seq_id_compte.CURRVAL, 'Dépôt Espèces');
	
	
---------------------------------------------------
--------- UC DEBITER ------------------------------	
---------------------------------------------------

CREATE OR REPLACE PROCEDURE Debiter	(
	vidNumCompte CompteCourant.idNumCompte%TYPE,
	vMontantDebit Operation.montant%TYPE,
	vTypeOp TypeOperation.idTypeOp%TYPE,
	retour OUT NUMBER)
IS
-- On ne teste pas les exceptions ici, on suppose que cela est fait au niveau JAVA :
-- (cela peut être changé mais il faut être capable d'intercepter et traiter les exceptions
-- SQL depuis JDBC...
-- Contraintes qu'il faut verifier :
--			   le compte n'est pas clôturé (pas fait ci-dessous)
--             ancien solde - vMontantDebit doit être >= debitAutorise (fait ci-dessous)

	vDebitAutorise CompteCourant.debitAutorise%TYPE;
	vSolde CompteCourant.solde%TYPE;
	vNouveauSolde CompteCourant.solde%TYPE;
	
BEGIN
	-- on n'insère pas la dateOp car elle est définie dans la table pour prendre la valeur du jour par défaut
	-- on insere la date du jour (sysdate) + 2 jours pour la date de valeur de l'operation
    
	-- la valeur vMontantDebit est passée en valeur absolue (ex : 120) donc on ajoute un signe - pour que cela devienne un débit (ex: -120)
	
	SELECT debitAutorise, solde into vDebitAutorise, vSolde FROM CompteCourant WHERE idNumCompte = vidNumCompte;
	
	-- ex: -300   := 150    - 450
	vNouveauSolde := vSolde - vMontantDebit;
	-- ex: -300      >=    -400 donc on peut faire le débit
	IF vNouveauSolde >= vDebitAutorise THEN
		INSERT INTO Operation (idOperation, montant, dateValeur, idNumCompte, idTypeOp)
		VALUES (seq_id_operation.NEXTVAL, -vMontantDebit, sysdate +2, vidNumCompte, vTypeOp);

		-- on met à jour le solde du compte correspondant à l'opération
		UPDATE CompteCourant
		SET solde = vNouveauSolde
		WHERE idNumCompte = vidNumCompte;
		
		COMMIT;
		retour := 0;
	
	-- ex: -300      <    -250
	-- vNouveauSolde <    vDebitAutorise donc on ne fait pas le débit 
	ELSE
		retour := -1;
	END IF;
	
END;
/

-- ACCEPT pIdNumCompte PROMPT 'Entrer le numero du compte courant à débiter : ';
-- ACCEPT pMontantDebit PROMPT 'Entrer le montant à débiter : ';

-- ATTENTION : Le serveur Oracle de l'IUT est parametré en FRANCAIS dont la décimale est représentée par une virgule
-- Pour que la procédure fonctionne avec le montant en décimal, il faut écrire le montant comme un varchar (ex : '15,2')
-- et le convertir en number avec la fonction TO_NUMBER()

-- Avant le débit réussi...
SELECT * FROM CompteCourant WHERE idNumCompte = 1;
SELECT * FROM Operation WHERE idNumCompte = 1; 
-- On donne le montant à débiter en valeur absolue à l'appel
VARIABLE ret NUMBER;
EXECUTE Debiter(1, TO_NUMBER('15,2'), 'Retrait Espèces', :ret);
PRINT ret;
-- Après le débit réussi...
SELECT * FROM CompteCourant WHERE idNumCompte = 1;
SELECT * FROM Operation WHERE idNumCompte = 1; 

-- On teste un cas qui plante, toujours sur compte 1, car nouveau solde serait inférieur au debitAutorisé
VARIABLE ret NUMBER;
EXECUTE Debiter(1, TO_NUMBER('500'), 'Retrait Espèces', :ret);
PRINT ret;

-- Après le débit raté...
SELECT * FROM CompteCourant WHERE idNumCompte = 1;
SELECT * FROM Operation WHERE idNumCompte = 1; 


-- On insère au moins une opération sans erreur par compte en utilisant la procédure stockée avec des valeurs "en dur"

-- 'Retrait Especes' est le seul Type Operation de débit qu'un guichetier peut réaliser avec cette procédure Debiter
VARIABLE ret NUMBER;
EXECUTE Debiter(1, 120, 'Retrait Espèces', :ret);
PRINT ret;
EXECUTE Debiter(1, 40, 'Retrait Espèces', :ret);
PRINT ret;
EXECUTE Debiter(1, 2, 'Retrait Espèces', :ret);
PRINT ret;
EXECUTE Debiter(1, 157, 'Retrait Espèces', :ret);
PRINT ret;
EXECUTE Debiter(2, 188, 'Retrait Espèces', :ret);
PRINT ret;
EXECUTE Debiter(3, 97, 'Retrait Espèces', :ret);
PRINT ret;
EXECUTE Debiter(4, 7, 'Retrait Espèces', :ret);
PRINT ret;
EXECUTE Debiter(5, 58, 'Retrait Espèces', :ret);
PRINT ret;
EXECUTE Debiter(6, 7, 'Retrait Espèces', :ret);
PRINT ret;
EXECUTE Debiter(7, 27, 'Retrait Espèces', :ret);
PRINT ret;
EXECUTE Debiter(8, 100, 'Retrait Espèces', :ret);
PRINT ret;
EXECUTE Debiter(9, 5, 'Retrait Espèces', :ret);
PRINT ret;
EXECUTE Debiter(10, 27, 'Retrait Espèces', :ret);
PRINT ret;
EXECUTE Debiter(11, 47, 'Retrait Espèces', :ret);
PRINT ret;

SELECT * FROM Operation ORDER BY idNumCompte;
SELECT * FROM CompteCourant ORDER BY idNumCompte;

COMMIT;

-------- FIN ----------------------------------------------------