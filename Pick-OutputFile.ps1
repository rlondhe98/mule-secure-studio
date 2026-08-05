Add-Type -AssemblyName System.Windows.Forms

$dialog = New-Object System.Windows.Forms.SaveFileDialog

$dialog.Title = "Choose Location for Decrypted YAML File"
$dialog.Filter = "YAML files (*.yaml)|*.yaml|YML files (*.yml)|*.yml|All files (*.*)|*.*"
$dialog.DefaultExt = "yaml"
$dialog.AddExtension = $true
$dialog.FileName = "secure-decrypted.yaml"

if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    Write-Output $dialog.FileName
}
