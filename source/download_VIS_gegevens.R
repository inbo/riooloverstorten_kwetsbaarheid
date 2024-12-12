library(inbodb)
library(DBI)
my_connection <- connect_inbo_dbase("W0001_10_vis")

# Drie andere queries

SELECT * FROM dbo.DimVispunt # alle vispunten selecteren uit de VIS + alle kolommen die aan die punten vasthangen
SELECT * FROM [ext].[vwDocumentatie] # overzicht van documentatie bij de kolommen
SELECT * FROM dbo.DimMethode # alle afvismethodes

### info voor mezelf (notitie ine)
### dbo. --> is een omgeving met daarin allemaal subtabellen in. Die subtabellen kan je opvragen
### die subtabellen hebben een lagere naam, maar de afkorten dw of fm zijn aliassen van die tabellen (gewoon makkelijker dan lange namen typen). Je geeft een alias door die erachter te typen
### uit een tabel kan je dan een kolom selecteren alias.kolomnaam

# Querie voor observaties van de soorten

## beschrijving van mijn querie
 strsql <- paste0("
SELECT ProjectNaam
    , dm.MethodeOmschrijving
    , MethodeGroepOmschrijving
    , dm.MethodeBerekening
    , dm.MethodeCPUEUnit
    , dw.WaarnemingDatumWID
    , dv.VispuntCode
    , dv.VispuntOmschrijving
    , VispuntX, Vispunty
    , VHAVispuntWaterloopSegment
    , VHAVispuntWaterloopGewestCode
    , VHAVispuntCategorieSegment
    , VHAVispuntBekkenNaam
    , VHAVispuntWkt
    , VHAVispuntNaam
    , VispuntSynoniem
    --watervlakken
    , VHAVispuntWatervlak
    , VHAVispuntWaterlichaamNaam
    , WaterlichaamNaam
    , VHAVispuntGemeente
    , fm.MetingTaxonAantal
    , fm.MetingTaxonLengtemaat
    , fm.MetingTaxonLengteTotaal
    , fm.MetingTaxonLengteVork
    , fm.LengtesGroepMeting
    , fm.MetingTaxonGewicht
    , fm.MetingTaxonGeslacht
    , dw.WaarnemingCPUEParameters
    , dt.NaamWET
FROM dbo.DimWaarneming dw
INNER JOIN dbo.FactMeting fm ON fm.WaarnemingWID = dw.WaarnemingWID
INNER JOIN dbo.DimMethode dm ON dm.MethodeWID = fm.MethodeWID
inner join dbo.DimVispunt dv ON dv.VispuntWID = fm.[VispuntWID]
LEFT OUTER JOIN dbo.DimTaxon dt ON dt.TaxonWID  =  fm.TaxonWID
LEFT OUTER JOIN dbo.DimProject dp ON dp.[ProjectWID] = fm.ProjectWID
WHERE dt.NaamNL IN ( 'grote modderkruiper', 'beekprik')
--AND dp.ProjectNaam NOT IN ('GIG Project')") # SOORT toevoegen/selecteren in voorlaatste lijn --> aan te passen zoals gewenst.
 # de -- tekens zijn zelfde als de # in R -> bij -- command wordt de lijn niet uitgevoerd maar toegevoegd als tekst in SQL language

 ## uitvoeren van de querie
 test <- dbGetQuery(my_connection, strsql)
