create database BookStoreVT
use BookStoreVT

create table Yazarlar(
 YazarId int primary key identity(1,1),
 YazarAd nvarchar(50),
 YazarSoyad nvarchar(50)
)

create table YayinEvi (
 YayinEviId int primary key identity(1,1),
 YayinEviAd nvarchar(50),
 YayinEviAdres nvarchar(300)
) 

create table Kitaplar(
  KitapId int primary key identity(1,1),
  KitapAd nvarchar(150),
  YayinEviId int foreign key references YayinEvi(YayinEviId),
  YazarId int foreign key references Yazarlar(YazarId),
  YayinYili date,
  SayfaSayisi int,
  Fiyati float

)

create table Musteriler(
 MusteriId int primary key identity(1,1),
 MusteriAd nvarchar(50),
 MusteriSoyad nvarchar(50),
 MusteriTelNo nvarchar(11) Unique,
 MusteriEmail nvarchar(100) Unique,
 MusteriAdres nvarchar(300),
 Sifre nvarchar(50),
 MusteriKayitTarih date,
 MusteriDogumTarihi date
)

create table SatinAlma(
 SatinAlmaId int primary key identity(1,1),
 MusteriId int foreign key references Musteriler(MusteriId),
 KitapId int foreign key references Kitaplar(KitapId),
 SatinAlmaTarih date 
)

create table KitapTurleri(
   KitapTurId int primary key identity(1,1),
   KitapTurAd nvarchar(50)
)

create table KitaplarveTurler(
 KitaplarveTurlerId int primary key identity(1,1),
 KitapTurId int foreign key references KitapTurleri(KitapTurId),
 KitapId int foreign key references Kitaplar(KitapId)
)



