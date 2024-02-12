declare @counter int = 1 

while @counter <= 100000
begin 
  declare @MusteriID int = round(rand()*99999+1,0)
  declare @KitapID int = round(rand()*659+1,0)

  insert into SatinAlma (MusteriId,KitapId)
  values (@MusteriID,@KitapID)
  set @counter = @counter+1

end

select * from SatinAlma

WITH RandomDates AS (
  SELECT 
    SatinAlmaId,
    DATEADD(DAY, 
            CAST(RAND(CHECKSUM(NEWID())) * (DATEDIFF(DAY, '2024-02-06', '2010-01-04')) AS INT), 
            '2023-01-01') AS RandomDate
  FROM 
    SatinAlma
)
UPDATE SatinAlma
SET SatinAlmaTarih = RandomDates.RandomDate
FROM SatinAlma
JOIN RandomDates ON SatinAlma.SatinAlmaId = RandomDates.SatinAlmaId;

