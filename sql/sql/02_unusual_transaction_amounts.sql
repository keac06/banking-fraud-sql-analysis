-- Détection des transactions atypiques
-- Les transactions dont le montant dépasse trois fois
-- le montant moyen des opérations du même compte émetteur

SELECT
  DIV(step - 1, 24) + 1 as jour_operation,
  nameOrig as compte_emetteur,
  type as type_operation,
  amount as montant_transfere,
  AVG(amount) OVER (PARTITION BY nameOrig) AS moyenne_trans
FROM `banking-fraud-sql-analysis.banking_fraud.transactions`
QUALIFY amount>3*moyenne_trans
ORDER BY jour_operation,compte_emetteur, type_operation;
