-- Concentration des flux financiers
-- Les comptes émetteurs permettant plus de 80 %
-- du montant total transféré, avec leur contribution
-- individuelle et cumulée

WITH table_ind as (
SELECT
  nameOrig as compte_emetteur,
  sum(amount) as montant_total,
  sum(amount)/ sum(sum(amount)) over() as contribution_ind
FROM `banking-fraud-sql-analysis.banking_fraud.transactions`
GROUP BY compte_emetteur
ORDER BY montant_total DESC),

table_cumule as (
SELECT
  compte_emetteur,
  montant_total,
  contribution_ind,
  sum(contribution_ind) OVER(
    ORDER BY montant_total DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) as contribution_cum
FROM table_ind
ORDER BY montant_total DESC
)

SELECT
  compte_emetteur,
  montant_total,
  round(100*contribution_ind,6),
  round(100*contribution_cum,6)
FROM table_cumule
WHERE contribution_cum >= 0.8;
