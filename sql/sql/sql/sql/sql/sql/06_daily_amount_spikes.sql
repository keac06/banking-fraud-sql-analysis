-- Détection des changements de comportement financier
-- Identifier les comptes émetteurs dont le montant total
-- transféré au cours d'une journée simulée dépasse
-- de plus de 100 % leur montant journalier moyen
-- des trois journées simulées précédentes

WITH transaction as (
SELECT
  nameOrig as compte_emetteur,
  DIV(step - 1, 24) + 1 as jour_operation,
  sum(amount) as montant_total
FROM `banking-fraud-sql-analysis.banking_fraud.transactions`
GROUP BY compte_emetteur, jour_operation
ORDER BY jour_operation
), transaction_veille as (
SELECT
  compte_emetteur,
  jour_operation,
  montant_total,
  LAG(montant_total) OVER(
    PARTITION BY compte_emetteur
    ORDER BY jour_operation
  ) as jour_precedent
FROM transaction)

SELECT
  compte_emetteur,
  jour_operation,
  montant_total,
  jour_precedent,
  AVG(montant_total) OVER (
    PARTITION BY compte_emetteur
    ORDER BY jour_operation
    ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
  ) AS moyenne_3_jours
FROM transaction_veille
QUALIFY ((montant_total - moyenne_3_jours)/ moyenne_3_jours)>1;
