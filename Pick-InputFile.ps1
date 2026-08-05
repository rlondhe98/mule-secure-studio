Add-Type -AssemblyName System.Windows.Forms

$dialog = New-Object System.Windows.Forms.OpenFileDialog

$dialog.Title = "Select MuleSoft Secure Properties YAML File"
$dialog.Filter = "YAML files (*.yaml;*.yml)|*.yaml;*.yml|All files (*.*)|*.*"
$dialog.Multiselect = $false

if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    Write-Output $dialog.FileName
}
