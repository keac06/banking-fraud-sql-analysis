-- Évaluer la détection des fraudes

WITH performance_fraude AS (
  SELECT
    COUNT(*) AS total_transactions,

    COUNTIF(isFraud = 1 AND isFlaggedFraud = 1)
      AS vrais_positifs,

    COUNTIF(isFraud = 1 AND isFlaggedFraud = 0)
      AS faux_negatifs,

    COUNTIF(isFraud = 0 AND isFlaggedFraud = 1)
      AS faux_positifs,

    COUNTIF(isFraud = 0 AND isFlaggedFraud = 0)
      AS vrais_negatifs

  FROM `banking-fraud-sql-analysis.banking_fraud.transactions`
)

SELECT
  total_transactions,
  vrais_positifs,
  faux_negatifs,
  faux_positifs,
  vrais_negatifs,

  ROUND(
    100 * SAFE_DIVIDE(
      vrais_positifs,
      vrais_positifs + faux_negatifs
    ), 2
  ) AS recall_pct,

  ROUND(
    100 * SAFE_DIVIDE(
      vrais_positifs,
      vrais_positifs + faux_positifs
    ), 2
  ) AS precision_pct,

  ROUND(
    100 * SAFE_DIVIDE(
      vrais_positifs + vrais_negatifs,
      total_transactions
    ), 2
  ) AS accuracy_pct,

  ROUND(
    100 * SAFE_DIVIDE(
      2 * vrais_positifs,
      2 * vrais_positifs + faux_positifs + faux_negatifs
    ), 2
  ) AS f1_score_pct

FROM performance_fraude;
