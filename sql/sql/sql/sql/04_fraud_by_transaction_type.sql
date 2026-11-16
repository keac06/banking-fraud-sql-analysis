-- Analyse de la fraude
-- Calcul du taux de fraude, montant total frauduleux
-- et part des montants frauduleux dans le volume financier
-- total pour chaque type de transaction

WITH table_fraud as
(
SELECT
  type as type_transaction,
  COUNT(*) as nb_fraude,
  sum(amount) as montant_fraude
FROM `banking-fraud-sql-analysis.banking_fraud.transactions`
WHERE IsFraud >0
GROUP BY type
ORDER BY nb_fraude DESC),
table_triee as (
SELECT
  type as type_transaction,
  COUNT(*) as nb_transaction,
  sum(amount) as montant_transaction
FROM `banking-fraud-sql-analysis.banking_fraud.transactions`
GROUP BY type)

SELECT
  b.type_transaction as type_operation,
  CONCAT(COALESCE(round(a.nb_fraude*100/b.nb_transaction,2),0), " %") as tx_fraude,
  COALESCE(a.montant_fraude,0) as montant_total_frauduleux,
  CONCAT(COALESCE(round(a.montant_fraude*100/b.montant_transaction,2),0)," %") as part_fraude
FROM table_triee b
FULL JOIN table_fraud a
ON a.type_transaction = b.type_transaction;
