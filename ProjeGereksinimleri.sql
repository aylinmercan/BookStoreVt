-- Müþterinin hangi kitap türünü yüzde kaç sevdiðinin bulan procedure

CREATE PROCEDURE EnSevdiðiTur 
(
    @MusteriId int
)
AS
BEGIN
    DECLARE @ToplamTurSayisi int

    SELECT @ToplamTurSayisi = COUNT(kt.KitapTurId) 
	FROM KitaplarveTurler kt
	JOIN SatinAlma s ON kt.KitapId = s.KitapId
    WHERE MusteriId = @MusteriId
 
    SELECT KitapTurleri.KitapTurAd AS 'KitapTürleri', 
        COUNT(kt.KitapId) AS 'SatýnAlmaSayisi', 
        (COUNT(kt.KitapId) * 100.0 / @ToplamTurSayisi) AS 'YüzdelikOraný'
    FROM KitaplarveTurler kt
    JOIN SatinAlma s ON kt.KitapId = s.KitapId
    JOIN KitapTurleri ON kt.KitapTurId = KitapTurleri.KitapTurId
    WHERE s.MusteriId = @MusteriId
    GROUP BY KitapTurleri.KitapTurAd
    ORDER BY YüzdelikOraný DESC
END

exec EnSevdiðiTur @MusteriId = 675
exec EnSevdiðiTur @MusteriId = 1230
exec EnSevdiðiTur @MusteriId = 5060


-- Müþteri Tel No 0 ile baþlamalý ve 11 haneli olmalý trigger

CREATE TRIGGER MusteriTelNoKontrol
ON Musteriler
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE LEN(MusteriTelNo) <> 11 OR MusteriTelNo NOT LIKE '0%'
    )
    BEGIN
        RAISERROR('Müþteri Tel No Kontrol Ediniz!!!', 16, 1)
        ROLLBACK TRANSACTION
    END
END
Insert Into Musteriler (MusteriAd, MusteriSoyad, MusteriTelNo, MusteriEmail, MusteriAdres, Sifre) Values ('Ebru Selin', 'Mercan', '0545594539', 'selin11@gmail.com', 'Yýldýrým/Bursa', '1234'); 


-- Kitabýn adýný, türünü, sayfa sayýsý, yazarýnýn adýný, satýlan kitap sayýsýný ve sayfa sayýsý 500'den fazla olan kitaplarý listeleyen  view 

CREATE VIEW KÝTAPBÝLGÝLERÝ
AS
SELECT k.KitapAd AS 'KitabýnAdý',kit.KitapTurAd AS 'KitabýnTürü' , k.SayfaSayisi AS 'KitabýnSayfaSayýsý',y.YazarAd AS 'YazarýnAdý'  ,COUNT(s.KitapId) AS 'SatýlanKitapSayýsý' 
FROM Kitaplar k , KitaplarveTurler kt , Yazarlar y , KitapTurleri kit , SatinAlma s
where k.KitapId = kt.KitapId and y.YazarId = k.YazarId and kit.KitapTurId = kt.KitapTurId and s.KitapId = k.KitapId and k.SayfaSayisi > 500  
GROUP BY k.KitapAd, y.YazarAd, kit.KitapTurAd , k.SayfaSayisi

SELECT * FROM KÝTAPBÝLGÝLERÝ



-- SQL Sorgularý 
ALTER TABLE Kitaplar
ADD kitapadedi int
/**/
UPDATE Kitaplar
SET kitapadedi = 500
WHERE KitapId = 100
/**/
SELECT DISTINCT KitapTurAd
FROM KitapTurleri
/**/
SELECT kt.KitapAd AS 'KitabýnAdý', y.YazarAd AS 'YazarýnAdý'
FROM Kitaplar kt
JOIN Yazarlar y ON kt.YazarId = y.YazarId;
/**/
ALTER TABLE Kitaplar
DROP COLUMN kitapadedi
/**/
SELECT 
    k.KitapAd AS 'KitabýnAdý',
    COUNT(s.MusteriId) AS 'ToplamSatýnAlmaSayýsý',
    y.YazarAd AS 'YazarýnAdý'
FROM 
    Kitaplar k
JOIN SatinAlma s ON k.KitapId = s.KitapId
JOIN Yazarlar y ON k.YazarId = y.YazarId
GROUP BY 
    k.KitapAd, y.YazarAd
/**/
SELECT TOP 1
    k.KitapAd AS 'KitabýnAdý',
    COUNT(*) AS 'SatýnAlmaSayýsý'
FROM 
    SatinAlma s
JOIN Kitaplar k ON s.KitapId = k.KitapId
GROUP BY 
    k.KitapAd
ORDER BY 
    COUNT(*) DESC
