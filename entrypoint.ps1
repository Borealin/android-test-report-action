param(
    [string]$ActionPath
)

$status_code = 0
$num_files = 0
$log_file = 'extractReport_status.log'
$status_message = 'Android Test Report Action executed successfully.'

Write-Host ''
Write-Host '------------------------------------------------'
Write-Host '---        Android Test Report Action        ---'
Write-Host '------------------------------------------------'
Write-Host ''
Write-Host ''

New-Item -ItemType File -Path $log_file -Force | Out-Null

$test_files = Get-ChildItem -Path . -Recurse -Name "TEST-*.xml" -File
foreach ($file in $test_files) {
    $num_files++
    python "$ActionPath/extractReport.py" $file
    Write-Host ''
}

if ($num_files -eq 0) {
   $status_code = 1
   $status_message = 'No test reports found. Please verify the tests were executed successfully. Android Test Report Action failed the job.'
}

if (Test-Path $log_file) {
    $log_content = Get-Content $log_file -Raw
    if ($log_content -match 'error') {
        $status_code = 1
        $status_message = 'There were failing tests. Android Test Report Action failed the job.'
    }
}

Remove-Item $log_file -ErrorAction SilentlyContinue

Write-Host $status_message
Write-Host ''
exit $status_code 