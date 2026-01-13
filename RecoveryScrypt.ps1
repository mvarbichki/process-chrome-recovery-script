Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# -----------------------------
# CONFIGURATION
# -----------------------------
$WebappExePath = "C:\wepapp\PSRV\PSRV_app.exe"
$ChromeExePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$ChromeCachePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
$ChromeCodeCache = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache"

$AllSuccess = $true

# -----------------------------
# FUNCTIONS
# -----------------------------
function Get-WebappProcess {
    param([string]$exePath)
    try {
        return Get-CimInstance Win32_Process | Where-Object { $_.ExecutablePath -eq $exePath }
    } catch { return $null }
}

# -----------------------------
# PROCESSING WINDOW
# -----------------------------
$processingForm = New-Object System.Windows.Forms.Form
$processingForm.Text = "Processing..."
$processingForm.Size = New-Object System.Drawing.Size(400,150)
$processingForm.StartPosition = "CenterScreen"
$processingForm.TopMost = $true
$processingForm.ControlBox = $false  # disables close button

$processingLabel = New-Object System.Windows.Forms.Label
$processingLabel.Text = "Processing Webapp Restart..."
$processingLabel.Font = New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold)
$processingLabel.ForeColor = [System.Drawing.Color]::Blue
$processingLabel.TextAlign = "MiddleCenter"
$processingLabel.Dock = "Fill"
$processingForm.Controls.Add($processingLabel)

# Show form non-blocking
$processingForm.Show()
$processingForm.Refresh()

# -----------------------------
# SCRIPT TASKS
# -----------------------------
try {
    # Restart Webapp
    $proc = Get-WebappProcess -exePath $WebappExePath
    if ($proc) { Stop-Process -Id $proc.ProcessId -Force; Start-Sleep -Seconds 1 }
    Start-Process -FilePath $WebappExePath; Start-Sleep -Seconds 2
} catch { $AllSuccess = $false }

try {
    # Restart Chrome
    Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force; Start-Sleep -Seconds 1
    Remove-Item "$ChromeCachePath\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$ChromeCodeCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Process -FilePath $ChromeExePath
} catch { $AllSuccess = $false }

# Close processing window
$processingForm.Close()

# -----------------------------
# SUMMARY WINDOW
# -----------------------------
$summaryForm = New-Object System.Windows.Forms.Form
$summaryForm.Text = "Webapp Restart Summary"
$summaryForm.Size = New-Object System.Drawing.Size(400,150)
$summaryForm.StartPosition = "CenterScreen"
$summaryForm.TopMost = $true

$label = New-Object System.Windows.Forms.Label
$label.Text = if ($AllSuccess) { "Successful Webapp Restart" } else { "Failed Webapp Restart" }
$label.ForeColor = if ($AllSuccess) { [System.Drawing.Color]::Green } else { [System.Drawing.Color]::Red }
$label.Font = New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold)
$label.AutoSize = $false
$label.TextAlign = "MiddleCenter"
$label.Dock = "Fill"
$summaryForm.Controls.Add($label)

$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "Close"
$okButton.Width = 100
$okButton.Height = 30
$okButton.Top = $summaryForm.ClientSize.Height - 50
$okButton.Left = ($summaryForm.ClientSize.Width - $okButton.Width)/2
$okButton.Add_Click({$summaryForm.Close()})
$summaryForm.Controls.Add($okButton)

$summaryForm.Add_Shown({$summaryForm.Activate()})
[void]$summaryForm.ShowDialog()