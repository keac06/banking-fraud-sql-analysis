-- Analyse des contreparties
-- Comptes émetteurs ayant transféré de l'argent vers
-- le plus grand nombre de destinataires distincts
-- au cours d'une même journée simulée

SELECT
  DIV(step - 1, 24) + 1 AS jour_operation,
  nameOrig AS compte_emetteur,
  COUNT(DISTINCT nameDest) AS nb_destinataires,
  SUM(amount) AS montant_total
FROM `banking-fraud-sql-analysis.banking_fraud.transactions`
WHERE type = 'TRANSFER'
GROUP BY jour_operation, compte_emetteur;
