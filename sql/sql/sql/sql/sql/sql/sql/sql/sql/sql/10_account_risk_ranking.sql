-- Classement des comptes selon leur exposition
-- au risque de fraude

WITH analyse_comptes AS (
  SELECT
    nameOrig AS compte_emetteur,
    COUNT(*) AS nb_transactions,
    ROUND(SUM(amount), 2) AS montant_total,

    COUNTIF(isFraud = 1) AS nb_fraudes,

    ROUND(
      SUM(IF(isFraud = 1, amount, 0)),
      2
    ) AS montant_frauduleux

  FROM `banking-fraud-sql-analysis.banking_fraud.transactions`
  GROUP BY nameOrig
),

evaluation_risque AS (
  SELECT
    *,
    ROUND(
      100 * SAFE_DIVIDE(nb_fraudes, nb_transactions),
      2
    ) AS taux_fraude_pct

  FROM analyse_comptes
)

SELECT
  compte_emetteur,
  nb_transactions,
  montant_total,
  nb_fraudes,
  montant_frauduleux,
  taux_fraude_pct,

  DENSE_RANK() OVER (
    ORDER BY montant_frauduleux DESC
  ) AS rang_risque

FROM evaluation_risque
WHERE nb_fraudes > 0
ORDER BY rang_risque, compte_emetteur;
