-- Détection des incohérences de soldes bancaires
-- Identifier les transactions présentant une incohérence
-- entre le montant transféré et l'évolution du solde
-- du compte émetteur, puis mesurer leur fréquence
-- par type d'opération

WITH suivi_transaction as (
SELECT
  type as type_operation,
  nameOrig as compte_emetteur,
  amount as montant_transfere,
  newbalanceOrig - oldbalanceOrg as evolution_solde,
  CASE
    WHEN type = 'CASH_IN'
      AND (newbalanceOrig - oldbalanceOrg) != amount
      THEN 'ANOMALIE'

    WHEN type IN ('CASH_OUT', 'TRANSFER', 'PAYMENT', 'DEBIT')
      AND (newbalanceOrig - oldbalanceOrg) != -amount
      THEN 'ANOMALIE'

    ELSE 'NORMAL'
  END AS statut_transaction
FROM `banking-fraud-sql-analysis.banking_fraud.transactions`
ORDER BY evolution_solde),

transaction_anormales as
(
SELECT
  type_operation,
  compte_emetteur,
  montant_transfere,
  evolution_solde
FROM suivi_transaction
WHERE statut_transaction = 'ANOMALIE'
),
trans_total as (
SELECT
  type_operation,
  count(*) as nb_total_transaction
FROM suivi_transaction
group by type_operation

), anorm_total as (
SELECT
  type_operation,
  count(*) as op_anormales
FROM transaction_anormales
group by type_operation
)

SELECT
  a.type_operation,
  b.op_anormales,
  a.nb_total_transaction,
  concat(round(b.op_anormales*100/a.nb_total_transaction,2), "%") as frequence
FROM trans_total a
LEFT JOIN anorm_total b
ON a.type_operation = b.type_operation;
