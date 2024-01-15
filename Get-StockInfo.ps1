# Get-StockInfo.ps1
# Retrieve stock information daily
# from: https://github.com/rreichel3/US-Stock-Symbols/tree/main
########################################################################
cd "C:\git\awsles\stock\history"
$d = get-date -Format "yyyy-MM-dd"
$exchanges = @('amex', 'nyse', 'nasdaq')
$results = @()
foreach ($ex in $exchanges)
{ 
    write-host -ForegroundColor Yellow "Exchange: $ex"
    # $r = get-Content -Path "$($d)_$($ex)_full_tickers.json" | ConvertFrom-json
    $f = invoke-webRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/rreichel3/US-Stock-Symbols/main/$($ex)/$($ex)_full_tickers.json"  
      #    -UserAgent  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:85.0) Gecko/20100101 Firefox/85.0'
    $r = $f | ConvertFrom-Json
    $r = $r | Add-Member -NotePropertyName 'exchange' -NotePropertyValue $ex -PassThru
    $r = $r | Add-Member -NotePropertyName 'updated' -NotePropertyValue $d  -PassThru
    $r = $r | Select-Object -Property exchange,symbol,name,country,industry,sector,ipoyear,lastsale,netchange,pctchange,volume,marketCap,updated,url
    $results += $r
}
write-host -ForegroundColor Yellow "$($results.count) results"
$results | export-csv -NoTypeInformation -Path "$($d)_AllStocks.csv" -Force
$results | ConvertTo-Json -depth 5 | Out-File "$($d)_AllStocks.json" -Force
cd ".."
