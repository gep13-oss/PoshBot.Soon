properties {
    $projectRoot = $ENV:BHProjectPath
    if(-not $projectRoot) {
        $projectRoot = $PSScriptRoot
    }

    $sut = "$projectRoot\$env:BHProjectName"
    $tests = "$projectRoot\Tests"
    $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest

    $psVersion = $PSVersionTable.PSVersion.Major
}

task default -depends Test

task Init {
    "`nSTATUS: Testing with PowerShell $psVersion"
    "Build System Details:"
    Get-Item ENV:BH*
} -description 'Initialize build environment'

task Test -Depends Init, Analyze, Pester -description 'Run test suite'

task Analyze -Depends Init {
    $analysis = Invoke-ScriptAnalyzer -Path $sut -Recurse -Verbose:$false
    $errors = $analysis | Where-Object {$_.Severity -eq 'Error'}
    $warnings = $analysis | Where-Object {$_.Severity -eq 'Warning'}
    if (@($errors).Count -gt 0) {
        Write-Error -Message 'One or more Script Analyzer errors were found. Build cannot continue!'
        $errors | Format-Table
    }

    if (@($warnings).Count -gt 0) {
        Write-Warning -Message 'One or more Script Analyzer warnings were found. These should be corrected.'
        $warnings | Format-Table
    }
} -description 'Run PSScriptAnalyzer'

task Pester -Depends Init {
    Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue -Verbose:$false
    Import-Module -Name $env:BHPSModuleManifest -Force -Verbose:$false

     # Prep for testing
    $PesterParams = @{}
    $testResultFile = ''
    switch ($ENV:BHBuildSystem) {
        'AppVeyor' {
            $testResultFile = Join-Path -Path $projectRoot -ChildPath 'pester.xml'
            $PesterParams = @{
                OutputFile = $testResultFile
                OutputFormat = 'NUnitXML'
            }
            break
        }
        Default {}
    }

    # Run tests
    if (Test-Path -Path $tests) {
        $testResults = Invoke-Pester -Path $tests -PassThru @PesterParams

        # Post test results
        switch ($ENV:BHBuildSystem) {
            'AppVeyor' {
                (New-Object 'System.Net.WebClient').UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", $testResultFile)
                break
            }
            Default {}
        }
    }

    if ($testResults.FailedCount -gt 0) {
        throw "$($testResults.FailedCount) tests failed!"
    }

} -description 'Run Pester tests'

Task Publish -Depends Test {
    "    Publishing version [$($manifest.ModuleVersion)] to PSGallery..."
    Publish-Module -Path $sut -NuGetApiKey $env:PSGalleryApiKey -Repository PSGallery
}
