-- Surveillance des opérations répétitives
-- Les comptes ayant effectué au moins cinq transactions
-- au cours d'une même heure simulée

SELECT
  step,
  nameOrig as compte_emetteur,
  count(*) as nombre_transactions,
  sum(amount) as volume_financier
FROM `banking-fraud-sql-analysis.banking_fraud.transactions`
GROUP BY step,compte_emetteur
Having nombre_transactions>=5
ORDER BY sum(amount) DESC;
