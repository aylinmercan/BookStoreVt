use BookStoreVT
WITH RandomDates AS (
  SELECT 
    MusteriId,
    DATEADD(DAY, 
            CAST(RAND(CHECKSUM(NEWID())) * (DATEDIFF(DAY, '2024-02-06', '2020-01-01')) AS INT), 
            '2023-01-01') AS RandomDate
  FROM 
    Musteriler
)
UPDATE Musteriler
SET MusteriKayitTarih = RandomDates.RandomDate
FROM Musteriler
JOIN RandomDates ON Musteriler.MusteriId = RandomDates.MusteriId;


WITH RandomDates AS (
  SELECT 
    MusteriId,
    DATEADD(DAY, 
            CAST(RAND(CHECKSUM(NEWID())) * (DATEDIFF(DAY, '1950-02-06', '2010-01-01')) AS INT), 
            '2023-01-01') AS RandomDate
  FROM 
    Musteriler
)
UPDATE Musteriler
SET MusteriDogumTarihi = RandomDates.RandomDate
FROM Musteriler
JOIN RandomDates ON Musteriler.MusteriId = RandomDates.MusteriId;

