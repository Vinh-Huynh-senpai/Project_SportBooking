param([string]$ApiUrl='http://localhost:5290')
$ErrorActionPreference='Stop'
Set-Location $PSScriptRoot
$configPath=Join-Path $PSScriptRoot 'WebApi\appsettings.json'
if(Test-Path -LiteralPath $configPath){$config=Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json}else{$config=Get-Content 'WebApi\appsettings.example.json' -Raw | ConvertFrom-Json}
$rng=[Security.Cryptography.RandomNumberGenerator]::Create()
try{
 if([string]::IsNullOrWhiteSpace($config.Jwt.SecretKey) -or $config.Jwt.SecretKey.StartsWith('SET_')){
  $key=New-Object byte[] 48;$rng.GetBytes($key);$config.Jwt.SecretKey=[Convert]::ToBase64String($key)
 }
 if([string]::IsNullOrWhiteSpace($config.Seed.AdminPassword) -or $config.Seed.AdminPassword.StartsWith('SET_')){
  $password=New-Object byte[] 18;$rng.GetBytes($password);$config.Seed.AdminPassword=[Convert]::ToBase64String($password)
 }
}finally{$rng.Dispose()}
$config | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $configPath -Encoding UTF8
@("Email: $($config.Seed.AdminEmail)","Password: $($config.Seed.AdminPassword)") | Set-Content -LiteralPath 'LOCAL-ADMIN.txt' -Encoding UTF8
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'datsan\.env'),"API_URL=$ApiUrl`n",[Text.UTF8Encoding]::new($false))
dotnet restore WebApi
if($LASTEXITCODE -ne 0){throw 'Backend restore failed'}
dotnet run --project WebApi --no-launch-profile -- --init-db --init-only
if($LASTEXITCODE -ne 0){throw 'Migration/seed failed. Check SQL Server and connection string.'}
Write-Host 'Stage2 database and seed ready. Private admin credentials: LOCAL-ADMIN.txt'
Write-Host 'API: dotnet run --project WebApi --no-launch-profile --urls http://localhost:5290'
Write-Host 'Flutter: cd datsan; flutter pub get; flutter run -d chrome --web-port 7360'
