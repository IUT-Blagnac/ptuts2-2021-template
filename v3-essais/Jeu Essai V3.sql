-- Jeu Essai V3

DELETE FROM Tache WHERE idCompetence >= 108;
DELETE FROM Projet WHERE idProjet = 95;
DELETE FROM Client WHERE idNumCli = 94;
DELETE FROM Employe WHERE idEmploye >= 125;
DELETE FROM NiveauCompetence WHERE idCompetence >= 108;
DELETE FROM Competence WHERE idCompetence >= 108;


INSERT INTO Competence VALUES(108, 'Concepteur UML'); -- compétence 108 CC
INSERT INTO Competence VALUES(109, 'Développeur Java J2EE'); -- compétence 109 CDJ
INSERT INTO Competence VALUES(110, 'Développeur Oracle'); -- compétence 110 CDO
INSERT INTO Competence VALUES(111, 'Suivi de projet MOE'); -- compétence 111 CMOE

INSERT INTO NiveauCompetence VALUES(108,1,60);
INSERT INTO NiveauCompetence VALUES(108,2,70);
INSERT INTO NiveauCompetence VALUES(108,3,80);

INSERT INTO NiveauCompetence VALUES(109,1,55);
INSERT INTO NiveauCompetence VALUES(109,2,65);
INSERT INTO NiveauCompetence VALUES(109,3,75);

INSERT INTO NiveauCompetence VALUES(110,1,55);
INSERT INTO NiveauCompetence VALUES(110,2,65);
INSERT INTO NiveauCompetence VALUES(110,3,75)
;
INSERT INTO NiveauCompetence VALUES(111,1,80);
INSERT INTO NiveauCompetence VALUES(111,2,90);
INSERT INTO NiveauCompetence VALUES(111,3,99.99);


------------- REPRENDRE ICI ---------------------------

INSERT INTO Employe VALUES (125,'Lopez','Julia','Julia','a5411edf929a4b91171dcd49699386f3be7706560b3af2a57f5bbc99ca6f8f1', 1, 2, 108, 3); 
INSERT INTO Employe VALUES (126,'Durand','Laurent','Laurent','ab31ea4ae505371d328d117172caf1fe173ac2275c01017343e8156a50679c', 1, 2, 108, 1); 					
INSERT INTO Employe VALUES (127,'Moran','Vianney','Vianney','8e5abdd396d53502cb3b24b6c998ab6d8f8118fe5c564c21c624c54964464e6', 1, 2, 110, 3); 					
INSERT INTO Employe VALUES (128,'Sol','Annie','Annie','de148153b07d429235e6324fa7eff44d0873484cafdb9742080213b1d34045', 1, 2, 109, 3);							
INSERT INTO Employe VALUES (129,'Tonk','Rémy','Rémy','3165be96f5833ae07a93e8baa073df6bae2dc719814af1088f844d637d8721a', 1, 2, 109, 1); 
INSERT INTO Employe VALUES (130,'Garon','Sophie','Sophie','58d9e33c417379bdf294f2e6907c186c529d7691e73867a8220314837701bea', 1, 1, 111, 3); 

COMMIT;

SELECT E.idEmploye, E.nom, E.prenom, E.login, R.nom, C.nom, N.intitule
FROM Employe E, Role R, NiveauCompetence NC, Niveau N, Competence C
WHERE E.idRole = R.idRole
AND E.idNiveau = NC.idNiveau
AND E.idCompetence = NC.idCompetence
AND NC.idCompetence = C.idCompetence
AND NC.idNiveau = N.idNiveau
AND E.idEmploye > 100
ORDER BY E.idEmploye;

-- Compétences-Niveau avec leur libellé
SELECT NC.idCompetence, NC.idNiveau, C.nom,  N.intitule, NC.tauxHoraire
FROM NiveauCompetence NC, Niveau N, Competence C
WHERE NC.idCompetence = C.idCompetence
AND NC.idNiveau = N.idNiveau
AND NC.idCompetence > 100
ORDER BY 1,2;


INSERT INTO Client (idNumCli,  nom,     prenom,      entreprise, email, telephone) 
VALUES (94, 'Lafarge', 'Daniel', 'FOLIOConcept', 'Lafarge.D@FolioConcept.com', '05.62.99.99.99'); -- cli num 94

INSERT INTO Projet VALUES 
(95, 'BiblioPo' , 'Application de référencement d''ouvrages sur la poésie espagnole', NULL, NULL, NULL, 94, NULL, NULL ); -- proj num 95



INSERT INTO Tache (idTache, nom, description, dateDebutReal, dateFinReal, dureeEstimeeReal, dureeReelleReal, idProjet, idCompetence, idNiveau, idEmploye)
VALUES (1000, 'Redaction Doc Fonctionnelle', 'Partie fonctionnelle', TO_DATE('25/05/2021', 'DD/MM/YYYY'), TO_DATE('27/05/2021', 'DD/MM/YYYY'), 
20, 21, 95, 108, 1, 125);

INSERT INTO Tache VALUES (1001, 'Redaction Doc Technique', 'Partie technique', TO_DATE('25/05/2021', 'DD/MM/YYYY'), TO_DATE('27/05/2021', 'DD/MM/YYYY'), 22, 21, 95, 109, 3,  128);

INSERT INTO Tache VALUES (1002, 'Validation documentation', 'Validation', TO_DATE('25/05/2021', 'DD/MM/YYYY'), TO_DATE('25/05/2021', 'DD/MM/YYYY'), 8, 7, 95, 111, 3, 130);

INSERT INTO Tache VALUES (1003, 'Mise en place envt de test', '', TO_DATE('26/05/2021', 'DD/MM/YYYY'), TO_DATE('27/05/2021', 'DD/MM/YYYY'), 15, 14, 95, 110, 3, 127);

INSERT INTO Tache VALUES (1004, 'Développement Java', '', TO_DATE('28/05/2021', 'DD/MM/YYYY'), TO_DATE('02/06/2021', 'DD/MM/YYYY'), 28, 28, 95, 109, 3, 128);

INSERT INTO Tache VALUES (1005, 'Développement Oracle', '',TO_DATE('28/05/2021', 'DD/MM/YYYY'), TO_DATE('02/06/2021', 'DD/MM/YYYY'), 28, 28, 95, 110, 3, 127);

INSERT INTO Tache VALUES (1006, 'Tests unitaires - techniques', '', TO_DATE('03/06/2021', 'DD/MM/YYYY'), TO_DATE('03/06/2021', 'DD/MM/YYYY'), 7, 7, 95,  109, 1, 129);

INSERT INTO Tache VALUES (1007, 'Corrections des bugs éventuels', '', TO_DATE('04/06/2021', 'DD/MM/YYYY'), TO_DATE('04/06/2021', 'DD/MM/YYYY'), 7, 7, 95, 109, 1, 128);

INSERT INTO Tache VALUES (1008, 'Recette Créat° scenarios tests', '', TO_DATE('28/05/2021', 'DD/MM/YYYY'), TO_DATE('28/05/2021', 'DD/MM/YYYY'), 7, 7, 95, 108, 3, 125);

INSERT INTO Tache VALUES (1009, 'Recette Réal° tests fonctionn.', '', TO_DATE('07/06/2021', 'DD/MM/YYYY'), TO_DATE('07/06/2021', 'DD/MM/YYYY'), 7, 7, 95, 108, 1, 126);

INSERT INTO Tache VALUES (1010, 'Corrections des bugs éventuels', '', TO_DATE('08/06/2021', 'DD/MM/YYYY'), TO_DATE('09/06/2021', 'DD/MM/YYYY'), 15, 14, 95, 109, 3, 128);

INSERT INTO Tache VALUES (1011, 'Validat° PV de recette', '', TO_DATE('10/06/2021', 'DD/MM/YYYY'), TO_DATE('10/06/2021', 'DD/MM/YYYY'), 6, 7, 95, 111, 3, 130);

INSERT INTO Tache VALUES (1012, 'Mise en production', '', TO_DATE('11/06/2021', 'DD/MM/YYYY'), TO_DATE('11/06/2021', 'DD/MM/YYYY'), 6, 7, 95, 110, 3, 127);

INSERT INTO Tache VALUES (1013, 'Formation', '', TO_DATE('14/06/2021', 'DD/MM/YYYY'), TO_DATE('15/06/2021', 'DD/MM/YYYY'), 15, 14, 95, 110, 3, 127);

INSERT INTO Tache VALUES (1014, 'Suivi du projet', 'Planification, réunion …', TO_DATE('26/05/2021', 'DD/MM/YYYY'), TO_DATE('01/06/2021', 'DD/MM/YYYY'), 35, 35, 95, 111, 3, 130);

COMMIT;

-- Taches avec leurs informations, niveauCompétence nécessaire et employe-niveau-compétence affecté (si celui est connu)
COLUMN ProjCli FORMAT A30 HEADING "Projet - Client";
COLUMN CompNivTache FORMAT A45 HEADING "Comp-Niv requis";
COLUMN CompNivEmpAff FORMAT A45 HEADING "Comp-Niv Emp Affecté";
SELECT T.idTache, T.nom, T.dateDebutReal, T.dateFinReal, T.dureeReelleReal, NC_E.tauxHoraire, P.nom||' - '||Cli.entreprise as ProjCli,
		C_T.nom||' - ' ||N_T.intitule as CompNivTache, C_E.nom||' - ' ||N_E.intitule as CompNivEmpAff,  E.nom as "Emp Affecté"
-- NC_T correspond au niveau de compétence liée à la tâche, NC_E correspond au niveau de compétence de l'employe affecté à la tâche (>= au NC_T)
FROM Tache T, Projet P, Client Cli, NiveauCompetence NC_T, Niveau N_T, Competence C_T, NiveauCompetence NC_E, Niveau N_E, Competence C_E, Employe E, Parametre Pa
WHERE T.idProjet = P.idProjet
AND Pa.margeBeneficiaire = 0.1
AND P.idProjet = T.idProjet
AND P.idProjet = 95 -- celui que l'on veut facturer
AND P.idNumCli = Cli.idNumCli
AND T.idEmploye = E.idEmploye
AND T.idCompetence = NC_T.idCompetence
AND T.idNiveau = NC_T.idNiveau
AND NC_T.idCompetence = C_T.idCompetence 
AND NC_T.idNiveau = N_T.idNiveau
AND E.idCompetence = NC_E.idCompetence
AND E.idNiveau = NC_E.idNiveau
AND NC_E.idCompetence = C_E.idCompetence 
AND NC_E.idNiveau = N_E.idNiveau
ORDER BY 1;

-- Facturation détaillée du Projet 95
COLUMN ProjCli FORMAT A30 HEADING "Projet - Client";
COLUMN CompNivEmpAff FORMAT A45 HEADING "Comp-Niv Emp Affecté";
SELECT T.idTache, T.nom, T.dureeReelleReal, NC.tauxHoraire, T.dureeReelleReal*NC.tauxHoraire as coutTâche, T.dureeReelleReal*NC.tauxHoraire*(1+Pa.margeBeneficiaire) as coutFacturé, P.nom||' - '||Cli.entreprise as ProjCli, C.nom||' - ' ||N.intitule as CompNivEmpAff,  E.nom as "Emp Affecté"
FROM Tache T, Projet P, Client Cli, Competence C, NiveauCompetence NC, Niveau N, Employe E, Parametre Pa
WHERE T.idProjet = P.idProjet
AND Pa.margeBeneficiaire = 0.1
AND P.idProjet = T.idProjet
AND P.idProjet = 95 -- celui que l'on veut facturer
AND P.idNumCli = Cli.idNumCli
AND T.idEmploye = E.idEmploye
AND E.idCompetence = NC.idCompetence
AND E.idNiveau = NC.idNiveau
AND NC.idCompetence = C.idCompetence 
AND NC.idNiveau = N.idNiveau
ORDER BY 1;

-- Cumul montant Facturation  du Projet 95
SELECT  P.nom,
		sum(T.dureeReelleReal*NC.tauxHoraire) as coutTotalTâche, 
		sum(T.dureeReelleReal*NC.tauxHoraire*(1+Pa.margeBeneficiaire)) as coutTotalFacturéHT,
		(sum(T.dureeReelleReal*NC.tauxHoraire*(1+Pa.margeBeneficiaire)))*0.2 as montantTVA,
		(sum(T.dureeReelleReal*NC.tauxHoraire*(1+Pa.margeBeneficiaire)))*1.2 as coutTotalFacturéTTC
FROM Tache T, Projet P, Client Cli, Competence C, NiveauCompetence NC, Niveau N, Employe E, Parametre Pa
WHERE T.idProjet = P.idProjet
AND Pa.margeBeneficiaire = 0.1
AND P.idProjet = T.idProjet
AND P.idProjet = 95 -- celui que l'on veut facturer
AND P.idNumCli = Cli.idNumCli
AND T.idEmploye = E.idEmploye
AND E.idCompetence = NC.idCompetence
AND E.idNiveau = NC.idNiveau
AND NC.idCompetence = C.idCompetence 
AND NC.idNiveau = N.idNiveau
GROUP BY P.nom, P.idProjet;



