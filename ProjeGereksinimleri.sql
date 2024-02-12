-- M��terinin hangi kitap t�r�n� y�zde ka� sevdi�inin bulan procedure

CREATE PROCEDURE EnSevdi�iTur 
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
 
    SELECT KitapTurleri.KitapTurAd AS 'KitapT�rleri', 
        COUNT(kt.KitapId) AS 'Sat�nAlmaSayisi', 
        (COUNT(kt.KitapId) * 100.0 / @ToplamTurSayisi) AS 'Y�zdelikOran�'
    FROM KitaplarveTurler kt
    JOIN SatinAlma s ON kt.KitapId = s.KitapId
    JOIN KitapTurleri ON kt.KitapTurId = KitapTurleri.KitapTurId
    WHERE s.MusteriId = @MusteriId
    GROUP BY KitapTurleri.KitapTurAd
    ORDER BY Y�zdelikOran� DESC
END

exec EnSevdi�iTur @MusteriId = 675
exec EnSevdi�iTur @MusteriId = 1230
exec EnSevdi�iTur @MusteriId = 5060


-- M��teri Tel No 0 ile ba�lamal� ve 11 haneli olmal� trigger

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
        RAISERROR('M��teri Tel No Kontrol Ediniz!!!', 16, 1)
        ROLLBACK TRANSACTION
    END
END
Insert Into Musteriler (MusteriAd, MusteriSoyad, MusteriTelNo, MusteriEmail, MusteriAdres, Sifre) Values ('Ebru Selin', 'Mercan', '0545594539', 'selin11@gmail.com', 'Y�ld�r�m/Bursa', '1234'); 


-- Kitab�n ad�n�, t�r�n�, sayfa say�s�, yazar�n�n ad�n�, sat�lan kitap say�s�n� ve sayfa say�s� 500'den fazla olan kitaplar� listeleyen  view 

CREATE VIEW K�TAPB�LG�LER�
AS
SELECT k.KitapAd AS 'Kitab�nAd�',kit.KitapTurAd AS 'Kitab�nT�r�' , k.SayfaSayisi AS 'Kitab�nSayfaSay�s�',y.YazarAd AS 'Yazar�nAd�'  ,COUNT(s.KitapId) AS 'Sat�lanKitapSay�s�' 
FROM Kitaplar k , KitaplarveTurler kt , Yazarlar y , KitapTurleri kit , SatinAlma s
where k.KitapId = kt.KitapId and y.YazarId = k.YazarId and kit.KitapTurId = kt.KitapTurId and s.KitapId = k.KitapId and k.SayfaSayisi > 500  
GROUP BY k.KitapAd, y.YazarAd, kit.KitapTurAd , k.SayfaSayisi

SELECT * FROM K�TAPB�LG�LER�



-- SQL Sorgular� 
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
SELECT kt.KitapAd AS 'Kitab�nAd�', y.YazarAd AS 'Yazar�nAd�'
FROM Kitaplar kt
JOIN Yazarlar y ON kt.YazarId = y.YazarId;
/**/
ALTER TABLE Kitaplar
DROP COLUMN kitapadedi
/**/
SELECT 
    k.KitapAd AS 'Kitab�nAd�',
    COUNT(s.MusteriId) AS 'ToplamSat�nAlmaSay�s�',
    y.YazarAd AS 'Yazar�nAd�'
FROM 
    Kitaplar k
JOIN SatinAlma s ON k.KitapId = s.KitapId
JOIN Yazarlar y ON k.YazarId = y.YazarId
GROUP BY 
    k.KitapAd, y.YazarAd
/**/
SELECT TOP 1
    k.KitapAd AS 'Kitab�nAd�',
    COUNT(*) AS 'Sat�nAlmaSay�s�'
FROM 
    SatinAlma s
JOIN Kitaplar k ON s.KitapId = k.KitapId
GROUP BY 
    k.KitapAd
ORDER BY 
    COUNT(*) DESC
