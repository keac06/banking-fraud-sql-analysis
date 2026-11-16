-- Analyse des flux financiers

SELECT
  DIV(step - 1, 24) + 1 as jour_operation,
  type as type_operation,
  COUNT(*) as nombre_transactions,
  round(sum(amount),2) as montant_transfere,
  round(avg(amount),2) as montant_moyen
FROM `banking-fraud-sql-analysis.banking_fraud.transactions`
GROUP BY DIV(step - 1, 24) + 1 , type
ORDER BY jour_operation, type_operation;
